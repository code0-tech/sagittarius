# frozen_string_literal: true

Runtime.where(name: ['Global Runtime', 'Code1-Runtime']).find_each do |runtime|
  DataType.seed_once :runtime_id, :identifier do |dt|
    dt.version = '0.0.0'
    dt.variant = :primitive
    dt.runtime_id = runtime.id
    dt.identifier = 'string'
    dt.names = [
      Translation.new(
        code: 'en',
        content: 'String'
      )
    ]
  end

  DataType.seed_once :runtime_id, :identifier do |dt|
    dt.version = '0.0.0'
    dt.variant = :primitive
    dt.runtime_id = runtime.id
    dt.identifier = 'number'
    dt.names = [
      Translation.new(
        code: 'en',
        content: 'Number'
      )
    ]
  end
end
