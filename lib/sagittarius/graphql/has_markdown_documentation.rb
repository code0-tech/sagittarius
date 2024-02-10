# frozen_string_literal: true

module Sagittarius
  module Graphql
    module HasMarkdownDocumentation
      extend ActiveSupport::Concern

      class_methods do
        def markdown_documentation(documentation = nil)
          raise 'Cannot redefine markdown documentation' if @markdown_documentation && documentation.present?

          @markdown_documentation = documentation if documentation.present?
          @markdown_documentation
        end
      end
    end
  end
end
