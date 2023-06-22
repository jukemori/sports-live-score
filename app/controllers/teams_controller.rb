class TeamsController < ApplicationController
  require 'uri'
  require 'net/http'

  def show
    @league = League.find(params[:league_id])
    @team = @league.teams.find(params[:id])
    @fixtures = fetchfixtures(@team.number)
  end

  private

  def fetchfixtures(team_id)
    url = URI("https://api-football-v1.p.rapidapi.com/v3/fixtures?season=2022&team=#{team_id}")

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true

    request = Net::HTTP::Get.new(url)
    request["X-RapidAPI-Key"] = ENV['RAPID_API_KEY']
    request["X-RapidAPI-Host"] = 'api-football-v1.p.rapidapi.com'

    response = http.request(request)
    data = JSON.parse(response.read_body)

    fixtures = []

    data['response'].each do |result|
      home = Team.find_by(name: result["teams"]["home"]["name"])
      away = Team.find_by(name: result["teams"]["away"]["name"])
      home_score = result["goals"]["home"]
      away_score = result["goals"]["away"]
      result_date = DateTime.parse(result["fixture"]["date"])

      fixture = Result.create(
        home_team_id: home,
        away_team_id: away,
        home_score: home_score,
        away_score: away_score,
        date: result_date
      )
      fixtures << fixture
    end
    fixtures
  end
end
