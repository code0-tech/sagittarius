# frozen_string_literal: true

class FlowSetting < ApplicationRecord
  belongs_to :flow, optional: true

  validates :flow_setting_id, presence: true

  validate :value_unique_within_scope

  def to_grpc
    Tucana::Shared::FlowSetting.new(
      database_id: id,
      flow_setting_id: flow_setting_id,
      value: Tucana::Shared::Value.from_ruby(object),
      cast: cast
    )
  end

  private

  # Each flow setting is validated independently: when the matching flow type
  # setting declares a uniqueness scope, the value may only exist once within
  # that scope (e.g. `project` => unique across all flows of the project).
  def value_unique_within_scope
    return if flow.nil? || object.nil?

    flow_type_setting = flow.flow_type&.flow_type_settings&.find_by(identifier: flow_setting_id)
    return if flow_type_setting.nil?

    conflicts =
      case flow_type_setting.unique.to_sym
      when :project then scoped_conflicts(flow.project_id)
      else return # :unknown / :none => no uniqueness requirement
      end

    errors.add(:object, :not_unique_in_scope) if conflicts.exists?
  end

  def scoped_conflicts(project_id)
    self.class
        .joins(:flow)
        .where(flows: { project_id: project_id })
        .where(flow_setting_id: flow_setting_id, object: object)
        .where.not(flow_id: flow_id)
  end
end
