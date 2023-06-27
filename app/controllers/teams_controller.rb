class TeamsController < ApplicationController

  def show
    @league = League.find(params[:league_id])
    @team = @league.teams.find(params[:id])
    @fixtures = fetchfixtures(@team.number)
  end
end
