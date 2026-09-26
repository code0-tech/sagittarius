# frozen_string_literal: true

module Types
  class RuntimeFlowTypeSettingUniqueEnum < Types::BaseEnum
    description 'Unique scope of the runtime flow type setting'

    value :NONE, 'This setting has no uniqueness scope', value: 'none'
    value :PROJECT, 'This setting must be unique within a project', value: 'project'
  end
end
