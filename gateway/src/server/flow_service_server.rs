#![allow(dead_code)]

use std::pin::Pin;

use tonic::codegen::tokio_stream::Stream;
use tucana::sagittarius_gateway::flow_service_server::FlowService;
use tucana::sagittarius_gateway::{
    FlowLogonRequest, FlowPushRequest, FlowPushResponse, FlowResponse,
};

pub struct SagittariusFlowService {}

type FlowUpdateStream =
    Pin<Box<dyn Stream<Item = Result<FlowResponse, tonic::Status>> + Send + 'static>>;

#[tonic::async_trait]
impl FlowService for SagittariusFlowService {
    type UpdateStream = FlowUpdateStream;

    // This route will be called by Aquila
    async fn update(
        &self,
        _request: tonic::Request<FlowLogonRequest>,
    ) -> Result<tonic::Response<Self::UpdateStream>, tonic::Status> {
        todo!()
    }

    // This route will be called by Sagittarius
    async fn push(
        &self,
        _request: tonic::Request<FlowPushRequest>,
    ) -> Result<tonic::Response<FlowPushResponse>, tonic::Status> {
        todo!()
    }
}
