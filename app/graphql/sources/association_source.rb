# frozen_string_literal: true

module Sources
  # Batch-preloads an ActiveRecord association across a GraphQL execution to avoid
  # N+1 queries. Accepts any Preloader shape, e.g. :user or { namespace: :namespace_members }.
  class AssociationSource < GraphQL::Dataloader::Source
    def initialize(association)
      super()
      @association = association
    end

    def fetch(records)
      ActiveRecord::Associations::Preloader.new(records: records, associations: @association).call

      key = @association.is_a?(Hash) ? @association.keys.first : @association
      records.map { |record| record.public_send(key) }
    end
  end
end
