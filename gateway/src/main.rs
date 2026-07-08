use tonic::transport::Channel;

use crate::client::execution_service_client::SagittariusRailsExecutionServiceClient;
use crate::client::flow_service_client::SagittariusRailsFlowServiceClient;
use crate::client::module_service_client::SagittariusRailsModuleServiceClient;
use crate::client::runtime_status_service_client::SagittariusRailsRuntimeStatusServiceClient;
use crate::client::token_service_client::SagittariusRailsTokenServiceClient;
use crate::config::Config;

mod client;
mod config;
mod server;

#[tokio::main]
async fn main() -> anyhow::Result<()> {
    let config = Config::default();

    let url = config.backend.url.clone();
    let channel = Channel::from_shared(url)?;

    let _rails_execution_client =
        SagittariusRailsExecutionServiceClient::connect(channel.clone()).await?;
    let _rails_flow_client = SagittariusRailsFlowServiceClient::connect(channel.clone()).await?;
    let _rails_module_client =
        SagittariusRailsModuleServiceClient::connect(channel.clone()).await?;
    let _rails_status_client =
        SagittariusRailsRuntimeStatusServiceClient::connect(channel.clone()).await?;
    let _rails_token_client = SagittariusRailsTokenServiceClient::connect(channel.clone()).await?;

    Ok(())
}
