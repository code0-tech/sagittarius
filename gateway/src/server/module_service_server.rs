#![allow(dead_code)]

use std::pin::Pin;

use tonic::codegen::tokio_stream::Stream;
use tucana::sagittarius_gateway::module_service_server::ModuleService;
use tucana::sagittarius_gateway::{ModuleUpdateRequest, ModuleUpdateResponse};

pub struct SagittariusModuleService {}

type ModuleConfigurationsStream =
    Pin<Box<dyn Stream<Item = Result<ModuleUpdateResponse, tonic::Status>> + Send + 'static>>;

#[tonic::async_trait]
impl ModuleService for SagittariusModuleService {
    async fn update(
        &self,
        _request: tonic::Request<ModuleUpdateRequest>,
    ) -> Result<tonic::Response<ModuleUpdateResponse>, tonic::Status> {
        todo!()
    }

    type ConfigurationsStream = ModuleConfigurationsStream;

    async fn configurations(
        &self,
        _request: tonic::Request<ModuleUpdateRequest>,
    ) -> Result<tonic::Response<Self::ConfigurationsStream>, tonic::Status> {
        todo!()
    }
}
