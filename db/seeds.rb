# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

require 'uri'
require 'net/http'
require 'json'

 def fetchleagues(league_id)
    #premier_league_id = 39
    #bundesliga_id = 78
    #seriea_id = 135
    #ligue1_id = 61
    #laliga_id = 140

    # league_ids = [39, 78, 135, 61, 140] # IDs of the leagues you want to fetch data for
    # leagues_data = []

    # league_ids.each do |league_id|
      url = URI("https://api-football-v1.p.rapidapi.com/v3/leagues?id=#{league_id}")

      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true
      api_key = ENV['RAPID_API_KEY']

      request = Net::HTTP::Get.new(url)
      request["X-RapidAPI-Key"] = api_key
      request["X-RapidAPI-Host"] = 'api-football-v1.p.rapidapi.com'

      response = http.request(request)
      lol = response.read_body
      data = JSON.parse(lol)
      league = data['response'][0]['league']
      league_data = { name: league['name'], logo: league['logo'] }

      new_league = League.create(league_data)
      new_league_id = new_league.id

      puts "Created #{league['name']}"

    url = URI("https://api-football-v1.p.rapidapi.com/v3/fixtures?league=#{league_id}&season=2022")

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true

    request = Net::HTTP::Get.new(url)
    request["X-RapidAPI-Key"] = '8957a47bfbmsh7ed6ded12eeef56p1ac9eajsn1e20ea768f8b'
    request["X-RapidAPI-Host"] = 'api-football-v1.p.rapidapi.com'

    response = http.request(request)
    lol = response.read_body
    data = JSON.parse(lol)
    fixtures = data['response']
    fixtures

    fixtures.each do |fixture|
      fixture
      game_data = fixture['fixture']
      home_team = fixture['teams']['home']
      away_team = fixture['teams']['away']
      goals = fixture['goals']

      # Extract the relevant game information
      date = game_data['date']
      home = home_team['name']
      away = away_team['name']
      home_score = goals['home']
      away_score = goals['away']
      home_pic = home_team['logo']
      away_pic = away_team['logo']
      # Create the game associated with the league
      Game.create(
        date: date,
        home: home,
        away: away,
        home_score: home_score,
        away_score: away_score,
        home_pic: home_pic,
        away_pic: away_pic,
        league_id: new_league_id
      )
    end
  end

  puts "Cleaning up database..."
  League.destroy_all
  puts "Database cleaned"

  premier_league = fetchleagues(39)
  bundes_liga = fetchleagues(78)
  la_liga = fetchleagues(140)
  serie_a = fetchleagues(135)
  league_1 = fetchleagues(61)



    puts "created #{League.count} leagues!"
    puts "created #{Game.count} games!"
