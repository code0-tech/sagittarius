# frozen_string_literal: true

class OrganizationsFinder < ApplicationFinder
  def execute
    organizations = base_scope
    organizations = by_id(organizations)
    organizations = by_name(organizations)

    super(organizations)
  end

  private

  def base_scope
    Organization.all
  end

  def by_id(organizations)
    return organizations unless params[:id]

    organizations.where(id: params[:id])
  end

  def by_name(organizations)
    return organizations unless params[:name]

    organizations.where(name: params[:name])
  end
end
