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

  url = URI("https://api-football-v1.p.rapidapi.com/v3/teams?league=#{id}&season=#{Date.today.year}")

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

puts "Database cleaned"

fetchleagues(39)
fetchleagues(78)
fetchleagues(140)
fetchleagues(135)
fetchleagues(61)

puts "created #{League.count} leagues!"
puts "created #{Team.count} teams!"
