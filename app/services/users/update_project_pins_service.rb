# frozen_string_literal: true

module Users
  class UpdateProjectPinsService
    include Sagittarius::Database::Transactional

    attr_reader :current_authentication, :user, :project_ids

    def initialize(current_authentication, project_ids)
      @current_authentication = current_authentication
      @user = current_authentication&.user
      @project_ids = project_ids.uniq
    end

    def execute
      unless Ability.allowed?(current_authentication, :update_user_project_pin, user)
        return ServiceResponse.error(message: 'Missing permission', error_code: :missing_permission)
      end

      projects = ProjectsFinder.new(id: project_ids, namespace_member_user: user).execute
      if projects.count != project_ids.count
        return ServiceResponse.error(message: 'Project not found', error_code: :project_not_found)
      end

      transactional do |t|
        UserProjectPin.where(user: user).delete_all

        project_ids.each_with_index do |project_id, priority|
          pin = user.user_project_pins.create(project_id: project_id, priority: priority)
          next if pin.persisted?

          t.rollback_and_return! ServiceResponse.error(
            message: 'Failed to update user project pins',
            error_code: :invalid_user_project_pin,
            details: pin.errors
          )
        end

        AuditService.audit(
          :user_project_pins_updated,
          author_id: user.id,
          entity: user,
          target: user,
          details: { project_ids: project_ids }
        )

        ServiceResponse.success(message: 'Updated user project pins', payload: user)
      end
    end
  end
end
