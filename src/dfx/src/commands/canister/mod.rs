use crate::lib::environment::Environment;
use crate::lib::error::DfxResult;
use crate::lib::identity::identity_utils::call_sender;
use crate::lib::provider::create_agent_environment;

use clap::Clap;
use tokio::runtime::Runtime;

mod call;
mod create;
mod delete;
mod id;
mod info;
mod install;
mod request_status;
mod send;
mod set_controller;
mod sign;
mod start;
mod status;
mod stop;

/// Manages canisters deployed on a network replica.
#[derive(Clap)]
#[clap(name("canister"))]
pub struct CanisterOpts {
    /// Override the compute network to connect to. By default, the local network is used.
    /// A valid URL (starting with `http:` or `https:`) can be used here, and a special
    /// ephemeral network will be created specifically for this request. E.g.
    /// "http://localhost:12345/" is a valid network name.
    #[clap(long)]
    network: Option<String>,

    /// Specify a wallet canister id to perform the call.
    /// If none specified, defaults to use the selected Identity's wallet canister.
    #[clap(long)]
    wallet: Option<String>,

    /// Performs the call with the user Identity as the Sender of messages.
    /// Bypasses the Wallet canister.
    #[clap(long, conflicts_with("wallet"))]
    no_wallet: bool,

    #[clap(subcommand)]
    subcmd: SubCommand,
}

#[derive(Clap)]
enum SubCommand {
    Call(call::CanisterCallOpts),
    Create(create::CanisterCreateOpts),
    Delete(delete::CanisterDeleteOpts),
    Id(id::CanisterIdOpts),
    Info(info::InfoOpts),
    Install(install::CanisterInstallOpts),
    RequestStatus(request_status::RequestStatusOpts),
    Send(send::CanisterSendOpts),
    SetController(set_controller::SetControllerOpts),
    Sign(sign::CanisterSignOpts),
    Start(start::CanisterStartOpts),
    Status(status::CanisterStatusOpts),
    Stop(stop::CanisterStopOpts),
}

pub fn exec(env: &dyn Environment, opts: CanisterOpts) -> DfxResult {
    let agent_env = create_agent_environment(env, opts.network.clone())?;
    let runtime = Runtime::new().expect("Unable to create a runtime");
    runtime.block_on(async {
        let call_sender = call_sender(&agent_env, &opts.wallet, opts.no_wallet).await?;
        match opts.subcmd {
            SubCommand::Call(v) => call::exec(&agent_env, v, &call_sender).await,
            SubCommand::Create(v) => create::exec(&agent_env, v, &call_sender).await,
            SubCommand::Delete(v) => delete::exec(&agent_env, v, &call_sender).await,
            SubCommand::Id(v) => id::exec(&agent_env, v).await,
            SubCommand::Install(v) => install::exec(&agent_env, v, &call_sender).await,
            SubCommand::Info(v) => info::exec(&agent_env, v).await,
            SubCommand::RequestStatus(v) => request_status::exec(&agent_env, v).await,
            SubCommand::Send(v) => send::exec(&agent_env, v, &call_sender).await,
            SubCommand::SetController(v) => set_controller::exec(&agent_env, v, &call_sender).await,
            SubCommand::Sign(v) => sign::exec(&agent_env, v, &call_sender).await,
            SubCommand::Start(v) => start::exec(&agent_env, v, &call_sender).await,
            SubCommand::Status(v) => status::exec(&agent_env, v, &call_sender).await,
            SubCommand::Stop(v) => stop::exec(&agent_env, v, &call_sender).await,
        }
    })
}
