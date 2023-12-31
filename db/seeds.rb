require 'uri'
require 'net/http'
require 'json'

# premier_league_id = 39
# bundesliga_id = 78
# seriea_id = 135
# ligue1_id = 61
# laliga_id = 140

def fetchleagues(id)
  url = URI("https://api-football-v1.p.rapidapi.com/v3/leagues?id=#{id}")

  http = Net::HTTP.new(url.host, url.port)
  http.use_ssl = true
  api_key = ENV['RAPID_API_KEY']

  request = Net::HTTP::Get.new(url)
  request["X-RapidAPI-Key"] = api_key
  request["X-RapidAPI-Host"] = 'api-football-v1.p.rapidapi.com'

  response = http.request(request)
  data = JSON.parse(response.read_body)
  league = data['response'][0]['league']

  new_league = League.create(name: league['name'])

  file = URI.open(league['logo'])
  new_league.photo.attach(io: file, filename: 'user.png', content_type: 'image/png')
  new_league.save

  puts "Created #{league['name']}"

  url = URI("https://api-football-v1.p.rapidapi.com/v3/teams?league=#{id}&season=2022")

  http = Net::HTTP.new(url.host, url.port)
  http.use_ssl = true

  request = Net::HTTP::Get.new(url)
  request["X-RapidAPI-Key"] = ENV['RAPID_API_KEY']
  request["X-RapidAPI-Host"] = 'api-football-v1.p.rapidapi.com'

  response = http.request(request)
  data = JSON.parse(response.read_body)

  data['response'].each do |team|
    new_team = Team.create(
      name: team['team']['name'],
      number: team['team']['id'],
      league_id: new_league.id
    )
    file = URI.open(team['team']['logo'])
    new_team.photo.attach(io: file, filename: 'user.png', content_type: 'image/png')
    new_team.save
  end
  puts "created #{Team.count} teams!"
end

puts "Cleaning up database..."
League.destroy_all
Team.destroy_all
Result.destroy_all

puts "Database cleaned"

fetchleagues(39)
fetchleagues(78)
fetchleagues(140)
fetchleagues(135)
fetchleagues(61)

puts "created #{League.count} leagues!"
puts "created #{Team.count} teams!"

Team.all.each do |team|
  url = URI("https://api-football-v1.p.rapidapi.com/v3/fixtures?season=2022&team=#{team.number}")

  http = Net::HTTP.new(url.host, url.port)
  http.use_ssl = true

  request = Net::HTTP::Get.new(url)
  request["X-RapidAPI-Key"] = ENV['RAPID_API_KEY']
  request["X-RapidAPI-Host"] = 'api-football-v1.p.rapidapi.com'

  response = http.request(request)
  data = JSON.parse(response.read_body)

  if data['response'].present?
    data['response'].each do |result|
      home = Team.find_by(name: result["teams"]["home"]["name"])
      away = Team.find_by(name: result["teams"]["away"]["name"])
      home_score = result["goals"]["home"]
      away_score = result["goals"]["away"]
      league = result["league"]["name"]
      result_date = DateTime.parse(result["fixture"]["date"])
      game = Result.create(
        home_team_id: home,
        away_team_id: away,
        home_score: home_score,
        away_score: away_score,
        league: league,
        date: result_date
      )
      p game
    end
  end
end

puts "created #{Result.count} games!"

# def fetchteams(league)
#   case league.name
#   when "Premier League"
#     id = 39
#   when "Bundesliga"
#     id = 78
#   when "La Liga"
#     id = 140
#   when "Serie A"
#     id = 135
#   when "Ligue 1"
#     id = 61
#   end

# league_id = league.id

# url = URI("https://api-football-v1.p.rapidapi.com/v3/teams?league=#{id}&season=#{Date.today.year}")

# http = Net::HTTP.new(url.host, url.port)
# http.use_ssl = true

# request = Net::HTTP::Get.new(url)
# request["X-RapidAPI-Key"] = ENV['RAPID_API_KEY']
# request["X-RapidAPI-Host"] = 'api-football-v1.p.rapidapi.com'

# response = http.request(request)
# data = JSON.parse(response.read_body)

# teams = []

# data['response'].each do|team_data|
#   team_name = team_data['team']['name']
#   team_logo = team_data['team']['logo']
# end
# end
