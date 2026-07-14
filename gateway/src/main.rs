use tonic::transport::{Channel, Server};
use tucana::sagittarius_gateway::execution_service_server::ExecutionServiceServer;
use tucana::sagittarius_gateway::flow_service_server::FlowServiceServer;
use tucana::sagittarius_gateway::module_service_server::ModuleServiceServer;
use tucana::sagittarius_gateway::runtime_status_service_server::RuntimeStatusServiceServer;

use crate::auth::JwtVerifier;
use crate::client::execution_service_client::SagittariusRailsExecutionServiceClient;
use crate::client::flow_service_client::SagittariusRailsFlowServiceClient;
use crate::client::module_service_client::SagittariusRailsModuleServiceClient;
use crate::client::runtime_status_service_client::SagittariusRailsRuntimeStatusServiceClient;
use crate::client::token_service_client::SagittariusRailsTokenServiceClient;
use crate::config::Config;
use crate::server::execution_service_server::SagittariusExecutionService;
use crate::server::flow_service_server::SagittariusFlowService;
use crate::server::module_service_server::SagittariusModuleService;
use crate::server::runtime_status_service_server::SagittariusRuntimeStatusService;

mod auth;
mod client;
mod config;
mod server;

#[tokio::main]
async fn main() -> anyhow::Result<()> {
    let config = Config::new();

    let url = config.backend.url.clone();
    let channel = Channel::from_shared(url)?;

    let rails_execution_client =
        SagittariusRailsExecutionServiceClient::connect(channel.clone()).await?;
    let rails_flow_client = SagittariusRailsFlowServiceClient::connect(channel.clone()).await?;
    let rails_module_client = SagittariusRailsModuleServiceClient::connect(channel.clone()).await?;
    let rails_status_client =
        SagittariusRailsRuntimeStatusServiceClient::connect(channel.clone()).await?;
    let rails_token_client = SagittariusRailsTokenServiceClient::connect(channel.clone()).await?;
    let jwt_verifier = JwtVerifier::new_hs256(config.auth.jwt_secret.as_bytes());

    let address = match format!("{}:{}", config.grpc.host, config.grpc.port).parse() {
        Ok(addr) => addr,
        Err(e) => panic!("Failed to parse address: {:?}", e),
    };

    let rails_execution_server = SagittariusExecutionService::new(
        rails_execution_client,
        rails_token_client.clone(),
        jwt_verifier.clone(),
    );
    let rails_flow_server = SagittariusFlowService::new(
        rails_flow_client,
        rails_token_client.clone(),
        jwt_verifier.clone(),
    );
    let rails_module_server =
        SagittariusModuleService::new(rails_module_client, rails_token_client, jwt_verifier);
    let rails_status_server = SagittariusRuntimeStatusService::new(rails_status_client);
    let mut server_builder = Server::builder()
        .add_service(ExecutionServiceServer::new(rails_execution_server))
        .add_service(FlowServiceServer::new(rails_flow_server))
        .add_service(ModuleServiceServer::new(rails_module_server))
        .add_service(RuntimeStatusServiceServer::new(rails_status_server));

    if config.grpc.with_health_service {
        let (_health_reporter, health_service) = tonic_health::server::health_reporter();
        server_builder = server_builder.add_service(health_service);
    }

    server_builder.serve(address).await?;

    Ok(())
}
