use crate::config::dfinity::to_socket_addr;
use crate::config::dfinity::{
    ConfigDefaultsBitcoin, ConfigDefaultsBootstrap, ConfigDefaultsCanisterHttp,
    ConfigDefaultsReplica,
};
use crate::lib::error::DfxResult;

use anyhow::Context;
use fn_error_context::context;
use std::net::SocketAddr;
use std::path::PathBuf;

#[derive(Clone, Debug, PartialEq)]
pub struct LocalServerDescriptor {
    pub data_directory: PathBuf,

    pub bind_address: SocketAddr,

    pub bitcoin: ConfigDefaultsBitcoin,
    pub bootstrap: ConfigDefaultsBootstrap,
    pub canister_http: ConfigDefaultsCanisterHttp,
    pub replica: ConfigDefaultsReplica,
}

impl LocalServerDescriptor {
    #[context("Failed to construct local server descriptor.")]
    pub(crate) fn new(
        data_directory: PathBuf,
        bind: String,
        bitcoin: ConfigDefaultsBitcoin,
        bootstrap: ConfigDefaultsBootstrap,
        canister_http: ConfigDefaultsCanisterHttp,
        replica: ConfigDefaultsReplica,
    ) -> DfxResult<Self> {
        let bind_address =
            to_socket_addr(&bind).context("Failed to convert 'bind' field to a SocketAddress")?;
        Ok(LocalServerDescriptor {
            data_directory,
            bind_address,
            bitcoin,
            bootstrap,
            canister_http,
            replica,
        })
    }

    pub fn dfx_pid_path(&self) -> PathBuf {
        self.data_directory.join("pid")
    }

    pub fn icx_proxy_pid_path(&self) -> PathBuf {
        self.data_directory.join("icx-proxy-pid")
    }

    pub fn ic_ref_port_path(&self) -> PathBuf {
        self.data_directory.join("ic-ref.port")
    }

    pub fn btc_adapter_pid_path(&self) -> PathBuf {
        self.data_directory.join("ic-btc-adapter-pid")
    }

    pub fn btc_adapter_config_path(&self) -> PathBuf {
        self.data_directory.join("ic-btc-adapter-config.json")
    }

    pub fn btc_adapter_socket_holder_path(&self) -> PathBuf {
        self.data_directory.join("ic-btc-adapter-socket-path")
    }

    pub fn canister_http_adapter_config_path(&self) -> PathBuf {
        self.data_directory.join("ic-canister-http-config.json")
    }

    pub fn canister_http_adapter_pid_path(&self) -> PathBuf {
        self.data_directory.join("ic-canister-http-adapter-pid")
    }

    pub fn canister_http_adapter_socket_holder_path(&self) -> PathBuf {
        self.data_directory.join("ic-canister-http-socket-path")
    }

    pub fn replica_configuration_dir(&self) -> PathBuf {
        self.data_directory.join("replica-configuration")
    }

    pub fn replica_port_path(&self) -> PathBuf {
        self.replica_configuration_dir().join("replica-1.port")
    }

    /// Return the directory where state for the replica is kept.
    pub fn state_dir(&self) -> PathBuf {
        self.data_directory.join("state")
    }

    pub fn webserver_port_path(&self) -> PathBuf {
        self.data_directory.join("webserver-port")
    }
}
