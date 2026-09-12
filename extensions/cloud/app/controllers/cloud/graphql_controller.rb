# frozen_string_literal: true

module CLOUD
  module GraphqlController
    include Sagittarius::Override

    override :anonymous_mutation?
    def anonymous_mutation?
      selections = query.selected_operation.selections

      (selections.length == 1 && selections.first.name == 'usersCompleteGuestProfile') || super
    end
  end
end
