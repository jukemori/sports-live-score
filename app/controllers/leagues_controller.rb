class LeaguesController < ApplicationController
  before_action :set_league, only: [:show]
  def index
    @leagues = League.all
  end

  def show
  end

  def new
    @league = League.new
  end

  def create
    @league = League.new(league_params)
    if @league.save
      redirect_to leagues_path(@league)
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_league
    @league = League.find(params[:id])
  end

  def league_params
    params.require(:league).permit(:name, :logo)
  end

end
