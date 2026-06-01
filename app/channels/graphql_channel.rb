# frozen_string_literal: true

class GraphqlChannel < ApplicationCable::Channel
  periodically :verify_authentication, every: 30.seconds

  def subscribed
    @token = params[:token]
    @subscription_ids = []

    verify_authentication
  end

  def execute(data)
    result = SagittariusSchema.execute(
      query: data['query'],
      context: {
        current_authentication: find_authentication(@token),
        visibility_profile: :execution,
        channel: self,
      },
      variables: data['variables'],
      operation_name: data['operationName']
    )

    @subscription_ids << result.context[:subscription_id] if result.context[:subscription_id]

    transmit({ result: result.to_h, more: result.subscription? })
  end

  def unsubscribed
    @subscription_ids.each do |sid|
      SagittariusSchema.subscriptions.delete_subscription(sid)
    end
  end

  private

  def verify_authentication
    with_context do
      authentication = find_authentication(@token)
      return unless authentication.invalid? || authentication.none?

      @subscription_ids.each { |sid| SagittariusSchema.subscriptions.delete_subscription(sid) }
      reject
    end
  end
end
