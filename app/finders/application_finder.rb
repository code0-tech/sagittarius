# frozen_string_literal: true

class ApplicationFinder
  attr_reader :params

  def initialize(params)
    @params = params
  end

  def execute(relation)
    relation = apply_limit(relation)
    apply_single(relation)
  end

  private

  def apply_limit(relation)
    return relation unless params[:limit]

    relation.limit(params[:limit])
  end

  def apply_single(relation)
    return relation unless params[:single]

    return relation.last if params[:single] == :last

    relation.first
  end
end
