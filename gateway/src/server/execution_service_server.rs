#![allow(dead_code)]

use std::pin::Pin;

use tonic::codegen::tokio_stream::Stream;
use tucana::sagittarius_gateway::execution_service_server::ExecutionService;
use tucana::sagittarius_gateway::{
    ExecutionLogonRequest, ExecutionLogonResponse, ExecutionPushRequest, ExecutionPushResponse,
};

pub struct SagittariusExecutionService {}

type ExecutionUpdateStream =
    Pin<Box<dyn Stream<Item = Result<ExecutionLogonResponse, tonic::Status>> + Send + 'static>>;

#[tonic::async_trait]
impl ExecutionService for SagittariusExecutionService {
    type UpdateStream = ExecutionUpdateStream;

    // This route will be called by Aquila
    async fn update(
        &self,
        _request: tonic::Request<tonic::Streaming<ExecutionLogonRequest>>,
    ) -> Result<tonic::Response<Self::UpdateStream>, tonic::Status> {
        todo!()
    }

    // This route will be called by Sagittarius
    async fn push(
        &self,
        _request: tonic::Request<ExecutionPushRequest>,
    ) -> Result<tonic::Response<ExecutionPushResponse>, tonic::Status> {
        todo!()
    }
}
