# frozen_string_literal: true

module Sagittarius
  module Graphql
    # rubocop:disable GraphQL/ObjectDescription -- this is a connection implementation, not a GraphQL object
    class StableConnection < GraphQL::Pagination::Connection
      def cursor_for(item)
        encode(item.id.to_s)
      end

      def backward?
        @before_value.present? || @last_value.present?
      end

      def page_size
        if backward?
          [@last_value, max_page_size].compact.min
        else
          [@first_value, max_page_size].compact.min
        end
      end

      def results
        @results ||= begin
          if backward?
            paginate_backward
          elsif @after_value.present?
            paginate_forward
          end

          @items.limit(page_size + 1)
        end
      end

      def paginate_backward
        before_id = Integer(decode(@before_value), exception: false)
        if before_id.nil? && !@before_value.nil?
          raise GraphQL::ExecutionError, "Invalid cursor '#{@before_value}' provided"
        end

        @items = @items.where(id: ...before_id) unless before_id.nil?
        @items = @items.reverse_order
      end

      def paginate_forward
        after_id = Integer(decode(@after_value), exception: false)
        raise GraphQL::ExecutionError, "Invalid cursor '#{@after_value}' provided" if after_id.nil?

        @items = @items.where('id > ?', after_id)
      end

      def nodes
        results.slice(0, page_size)
      end

      # rubocop:disable Naming/PredicateName -- this is required by graphql-ruby
      def has_next_page
        !backward? && results.size > page_size
      end

      def has_previous_page
        backward? && results.size > page_size
      end
      # rubocop:enable Naming/PredicateName
    end
    # rubocop:enable GraphQL/ObjectDescription
  end
end
