# frozen_string_literal: true

class TeamsFinder < ApplicationFinder
  def execute
    teams = base_scope
    teams = by_id(teams)
    teams = by_name(teams)

    super(teams)
  end

  private

  def base_scope
    Team.all
  end

  def by_id(teams)
    return teams unless params[:id]

    teams.where(id: params[:id])
  end

  def by_name(teams)
    return teams unless params[:name]

    teams.where(name: params[:name])
  end
end
