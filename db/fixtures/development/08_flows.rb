# frozen_string_literal: true

FlowType.seed_once :runtime_id, :identifier do |ft|
  ft.runtime_id = Runtime.find_by(name: 'Code1-Runtime').id
  ft.identifier = 'sample-flow-type'
  ft.version = '0.0.0'
  ft.names = [
    Translation.new(
      code: 'en',
      content: 'Sample Flow Type'
    )
  ]
  ft.descriptions = [
    Translation.new(
      code: 'en',
      content: 'A sample flow type for demonstration purposes.'
    )
  ]
  ft.aliases = [
    Translation.new(
      code: 'en',
      content: 'SFT'
    )
  ]
  ft.display_messages = [
    Translation.new(
      code: 'en',
      content: 'This is a sample flow type.'
    )
  ]
  ft.flow_type_settings = [
    FlowTypeSetting.new(
      identifier: 'url',
      unique: false,
      data_type: DataType.find_by(identifier: 'string', runtime_id: Runtime.find_by(name: 'Code1-Runtime').id),
      names: [
        Translation.new(
          code: 'en',
          content: 'Url for callback'
        )
      ],
      descriptions: [
        Translation.new(
          code: 'en',
          content: 'The URL to be used for callback operations.'
        )
      ]
    )
  ]
end

RuntimeFunctionDefinition.seed_once :runtime_id, :runtime_name do |rfd|
  rfd.runtime_id = Runtime.find_by(name: 'Code1-Runtime').id
  rfd.runtime_name = 'std::math::square'
  rfd.version = '0.0.0'
  rfd.names = [
    Translation.new(
      code: 'en',
      content: 'Square Function'
    )
  ]
  rfd.descriptions = [
    Translation.new(
      code: 'en',
      content: 'Calculates the square of a number.'
    )
  ]
  rfd.aliases = [
    Translation.new(
      code: 'en',
      content: '^2'
    )
  ]
  rfd.parameters = [
    RuntimeParameterDefinition.new(
      runtime_name: 'std::math::square::value',
      data_type: DataTypeIdentifier.new(data_type: DataType.find_by(identifier: 'number',
                                                                    runtime_id: Runtime.find_by(
                                                                      name: 'Code1-Runtime'
                                                                    ).id)),
      names: [
        Translation.new(
          code: 'en',
          content: 'Value'
        )
      ],
      descriptions: [
        Translation.new(
          code: 'en',
          content: 'The number to be squared.'
        )
      ]
    )
  ]
end

Flow.seed_once :project_id, :name do |flow|
  flow.project_id = NamespaceProject.find_by(
    namespace: Organization.find_by(name: 'Code1').ensure_namespace,
    name: 'First Project'
  ).id
  flow.name = 'Sample Flow'

  flow.flow_settings = [
    FlowSetting.new(
      flow_setting_id: FlowType.find_by(identifier: 'sample-flow-type').flow_type_settings.first.identifier,
      object: 'https://example.com/callback'
    )
  ]

  flow.flow_type = FlowType.find_by(identifier: 'sample-flow-type')
  flow.starting_node = NodeFunction.new(
    runtime_function: RuntimeFunctionDefinition.find_by(runtime_name: 'std::math::square'),
    node_parameters: [
      NodeParameter.new(
        literal_value: '5',
        runtime_parameter_id: RuntimeFunctionDefinition.find_by(runtime_name: 'std::math::square').parameters.first.id
      )
    ]
  )
end
