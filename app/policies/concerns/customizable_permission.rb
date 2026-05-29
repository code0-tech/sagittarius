# frozen_string_literal: true

module CustomizablePermission
  extend ActiveSupport::Concern

  class_methods do
    attr_reader :namespace_resolver_block

    def namespace_resolver(&block)
      @namespace_resolver_block = block
    end

    def customizable_permission(ability)
      condition(ability) { user_has_ability?(ability, user, subject) }

      rule { send(ability) | namespace_admin }.enable ability
    end
  end

  included do
    condition(:namespace_admin) do
      user_has_ability?(:namespace_administrator, user, subject) || can?(:namespace_administrator)
    end

    def namespace(subject)
      @namespace ||= self.class.namespace_resolver_block.call(subject)
    end

    def namespace_member(user, subject)
      return @namespace_member if defined?(@namespace_member)

      @namespace_member = namespace(subject).namespace_members.find_by(user: user)
    end

    def user_has_ability?(ability, user, subject)
      return false if namespace_member(user, subject).nil?

      roles = namespace_member(user, subject).roles

      project = project_scope(subject)
      roles = roles.applicable_to_project(project) if project.present?

      roles.joins(:abilities).exists?(namespace_role_abilities: { ability: ability })
    end

    def project_scope(subject)
      return subject if subject.is_a?(NamespaceProject)
      return subject.namespace_project if subject.respond_to?(:namespace_project)

      subject.project if subject.respond_to?(:project)
    end
  end
end
