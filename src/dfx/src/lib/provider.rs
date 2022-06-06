use crate::config::dfinity::{Config, ConfigLocalProvider, ConfigNetwork, NetworkType};
use crate::lib::environment::{AgentEnvironment, Environment};
use crate::lib::error::DfxResult;
use crate::lib::network::local_server_descriptor::LocalServerDescriptor;
use crate::lib::network::network_descriptor::NetworkDescriptor;
use crate::util::{self, expiry_duration};
use std::path::Path;

use anyhow::{anyhow, Context};
use fn_error_context::context;
use lazy_static::lazy_static;
use std::sync::{Arc, RwLock};
use url::Url;

lazy_static! {
    static ref NETWORK_CONTEXT: Arc<RwLock<Option<String>>> = Arc::new(RwLock::new(None));
}

fn set_network_context(network: Option<String>) {
    let name = network.unwrap_or_else(|| "local".to_string());

    let mut n = NETWORK_CONTEXT.write().unwrap();
    *n = Some(name);
}

#[context("Failed to get network context.")]
pub fn get_network_context() -> DfxResult<String> {
    NETWORK_CONTEXT
        .read()
        .unwrap()
        .clone()
        .ok_or_else(|| anyhow!("Cannot find network context."))
}

pub enum LocalBindDetermination {
    // /// Use host passed in from command-line
    // SpecificHost(String),
    //
    // /// Use ip and port passed in from command-line
    // SpecificSocketAddr(SocketAddr),
    //
    /// Use value from configuration
    AsConfigured,

    /// Get port of running server from webserver-port file
    ApplyRunningWebserverPort,
}

// always returns at least one url
#[context("Failed to get network descriptor for network '{}.", network.unwrap_or_else(||"local".to_string()))]
pub fn get_network_descriptor(
    config: Option<Arc<Config>>,
    network: Option<String>,
    local_bind_determination: LocalBindDetermination,
) -> DfxResult<NetworkDescriptor> {
    set_network_context(network.clone());
    let config = config.unwrap_or_else(|| {
        eprintln!("dfx.json not found, using default.");
        Arc::new(Config::from_str("{}").unwrap())
    });
    let data_directory = config.get_temp_path();
    let config = config.as_ref().get_config();
    let network_name = get_network_context()?;
    match config.get_network(&network_name) {
        Some(ConfigNetwork::ConfigNetworkProvider(network_provider)) => {
            let providers = if !network_provider.providers.is_empty() {
                network_provider
                    .providers
                    .iter()
                    .map(|provider| parse_provider_url(provider))
                    .collect::<DfxResult<_>>()
            } else {
                Err(anyhow!(
                    "Cannot find providers for network \"{}\"",
                    network_name
                ))
            }?;
            let is_ic = NetworkDescriptor::is_ic(&network_name.to_string(), &providers);
            Ok(NetworkDescriptor {
                name: network_name.to_string(),
                providers,
                r#type: network_provider.r#type,
                is_ic,
                local_server_descriptor: None,
            })
        }
        Some(ConfigNetwork::ConfigLocalProvider(local_provider)) => {
            let network_type = local_provider.r#type;
            let bind_address =
                get_local_bind_address(local_provider, local_bind_determination, &data_directory)?;
            let provider_url = format!("http://{}", bind_address);
            let providers = vec![parse_provider_url(&provider_url)?];
            let local_server_descriptor = LocalServerDescriptor::new(bind_address)?;
            Ok(NetworkDescriptor {
                name: network_name.to_string(),
                providers,
                r#type: network_type,
                is_ic: false,
                local_server_descriptor: Some(local_server_descriptor),
            })
        }
        None => {
            // Allow a URL to be specified as a network (if it's parseable as a URL).
            if let Ok(url) = parse_provider_url(&network_name) {
                // Replace any non-ascii-alphanumeric characters with `_`, to create an
                // OS-friendly directory name for it.
                let name = util::network_to_pathcompat(&network_name);
                let is_ic = NetworkDescriptor::is_ic(&name, &vec![url.to_string()]);

                Ok(NetworkDescriptor {
                    name,
                    providers: vec![url],
                    r#type: NetworkType::Ephemeral,
                    is_ic,
                    local_server_descriptor: None,
                })
            } else {
                Err(anyhow!("ComputeNetworkNotFound({})", network_name))
            }
        }
    }
}

fn get_local_bind_address(
    local_provider: ConfigLocalProvider,
    local_bind_determination: LocalBindDetermination,
    data_directory: &Path,
) -> DfxResult<String> {
    match local_bind_determination {
        // LocalBindDetermination::SpecificHost(host) => Ok(host),
        // LocalBindDetermination::SpecificSocketAddr(socket_addr) => Ok(format!("{}", socket_addr)),
        LocalBindDetermination::AsConfigured => Ok(local_provider.bind),
        LocalBindDetermination::ApplyRunningWebserverPort => {
            get_running_webserver_bind_address(data_directory, local_provider)
        }
    }
}

fn get_running_webserver_bind_address(
    data_directory: &Path,
    local_provider: ConfigLocalProvider,
) -> DfxResult<String> {
    let path = data_directory.join("webserver-port");
    if path.exists() {
        let s = std::fs::read_to_string(&path).with_context(|| {
            format!(
                "Unable to read webserver port from {}",
                path.to_string_lossy()
            )
        })?;
        let s = s.trim();
        if s.is_empty() {
            Ok(local_provider.bind)
        } else {
            let port = s.parse::<u16>().with_context(|| {
                format!(
                    "Unable to read contents of {} as a port value",
                    path.to_string_lossy()
                )
            })?;
            // converting to a socket address, and then setting the port,
            // will unfortunately transform "localhost:port" to "[::1]:{port}",
            // which the agent fails to connect with.
            let host = match local_provider.bind.rfind(':') {
                None => local_provider.bind,
                Some(index) => local_provider.bind[0..index].to_string(),
            };
            Ok(format!("{}:{}", host, port))
            //
            // let mut socket_addr = to_socket_addr(&local_provider.bind)?;
            // socket_addr.set_port(port);
            // // let address_with_port = SocketAddr::new(socket_addr.ip(), port);
            // format!("{}", socket_addr)
        }
    } else {
        Ok(local_provider.bind)
    }
}

#[context("Failed to create AgentEnvironment.")]
pub fn create_agent_environment<'a>(
    env: &'a (dyn Environment + 'a),
    network: Option<String>,
) -> DfxResult<AgentEnvironment<'a>> {
    let network_descriptor = get_network_descriptor(
        env.get_config(),
        network,
        LocalBindDetermination::ApplyRunningWebserverPort,
    )?;
    let timeout = expiry_duration();
    AgentEnvironment::new(env, network_descriptor, timeout)
}

#[context("Failed to parse supplied provider url {}.", s)]
pub fn command_line_provider_to_url(s: &str) -> DfxResult<String> {
    match parse_provider_url(s) {
        Ok(url) => Ok(url),
        Err(original_error) => {
            let prefixed_with_http = format!("http://{}", s);
            parse_provider_url(&prefixed_with_http).or(Err(original_error))
        }
    }
}

pub fn parse_provider_url(url: &str) -> DfxResult<String> {
    Url::parse(url)
        .map(|_| String::from(url))
        .with_context(|| format!("Cannot parse provider URL {}.", url))
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::config::dfinity::to_socket_addr;
    use std::fs;

    #[test]
    fn use_running_webserver_address() {
        // no file - use default
        test_with_webserver_port(
            LocalBindDetermination::ApplyRunningWebserverPort,
            None,
            "localhost:8000",
        );

        // port file present and populated: reflected in socket address
        test_with_webserver_port(
            LocalBindDetermination::ApplyRunningWebserverPort,
            Some("1234"),
            "localhost:1234",
        );

        // port file present and populated, but not asked for: ignored
        test_with_webserver_port(
            LocalBindDetermination::AsConfigured,
            Some("1234"),
            "localhost:8000",
        );

        // trailing newline is ok
        test_with_webserver_port(
            LocalBindDetermination::ApplyRunningWebserverPort,
            Some("3456\n"),
            "localhost:3456",
        );

        // empty is ok: ignore
        test_with_webserver_port(
            LocalBindDetermination::ApplyRunningWebserverPort,
            Some(""),
            "localhost:8000",
        );

        // just whitespace is ok: ignore
        test_with_webserver_port(
            LocalBindDetermination::ApplyRunningWebserverPort,
            Some("\n"),
            "localhost:8000",
        );
    }

    fn test_with_webserver_port(
        local_bind_determination: LocalBindDetermination,
        webserver_port_contents: Option<&str>,
        expected_socket_addr: &str,
    ) {
        let temp_dir = tempfile::tempdir().unwrap();
        let project_dir = temp_dir.path().join("project");
        fs::create_dir_all(&project_dir).unwrap();
        let project_dfx_json = project_dir.join("dfx.json");
        std::fs::write(
            project_dfx_json,
            r#"{
            "networks": {
                "local": {
                    "bind": "localhost:8000"
                }
            }
        }"#,
        )
        .unwrap();

        if let Some(webserver_port_contents) = webserver_port_contents {
            let dot_dfx_dir = project_dir.join(".dfx");
            fs::create_dir_all(&dot_dfx_dir).unwrap();
            std::fs::write(dot_dfx_dir.join("webserver-port"), webserver_port_contents).unwrap();
        }

        let config = Config::from_dir(&project_dir).unwrap().unwrap();
        let network_descriptor =
            get_network_descriptor(Some(Arc::new(config)), None, local_bind_determination).unwrap();

        assert_eq!(
            network_descriptor
                .local_server_descriptor()
                .unwrap()
                .bind_address,
            to_socket_addr(expected_socket_addr).unwrap()
        );
    }

    #[test]
    fn config_with_local_bind_addr() {
        let config = Config::from_str(
            r#"{
            "networks": {
                "local": {
                    "bind": "localhost:8000"
                }
            }
        }"#,
        )
        .unwrap();

        let network_descriptor = get_network_descriptor(
            Some(Arc::new(config)),
            None,
            LocalBindDetermination::AsConfigured,
        )
        .unwrap();

        assert_eq!(
            network_descriptor
                .local_server_descriptor()
                .unwrap()
                .bind_address,
            to_socket_addr("localhost:8000").unwrap()
        );
    }

    #[test]
    fn config_with_invalid_local_bind_addr() {
        let config = Config::from_str(
            r#"{
            "networks": {
                "local": {
                    "bind": "not a valid bind address"
                }
            }
        }"#,
        )
        .unwrap();

        let result = get_network_descriptor(Some(Arc::new(config)), None,
                                            LocalBindDetermination::AsConfigured);
        assert!(result.is_err());
    }

    #[test]
    fn config_returns_local_bind_address_if_no_local_network() {
        let config = Config::from_str(
            r#"{
            "networks": {
            }
        }"#,
        )
        .unwrap();
        let network_descriptor = get_network_descriptor(
            Some(Arc::new(config)),
            None,
            LocalBindDetermination::AsConfigured,
        )
        .unwrap();

        assert_eq!(
            network_descriptor
                .local_server_descriptor()
                .unwrap()
                .bind_address,
            to_socket_addr("127.0.0.1:8000").unwrap()
        );
    }

    #[test]
    fn config_returns_local_bind_address_if_no_networks() {
        let config = Config::from_str(
            r#"{
        }"#,
        )
        .unwrap();
        let network_descriptor = get_network_descriptor(
            Some(Arc::new(config)),
            None,
            LocalBindDetermination::AsConfigured,
        )
        .unwrap();

        assert_eq!(
            network_descriptor
                .local_server_descriptor()
                .unwrap()
                .bind_address,
            to_socket_addr("127.0.0.1:8000").unwrap()
        );
    }

    #[test]
    fn url_is_url() {
        assert_eq!(
            command_line_provider_to_url(&"http://127.0.0.1:8000".to_string()).unwrap(),
            "http://127.0.0.1:8000"
        );
    }

    #[test]
    fn addr_and_port_to_url() {
        assert_eq!(
            command_line_provider_to_url(&"127.0.0.1:8000".to_string()).unwrap(),
            "http://127.0.0.1:8000"
        );
    }
}
