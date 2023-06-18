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

 def fetchleagues
    #premier_league_id = 39
    #bundesliga_id = 78
    #seriea_id = 135
    #ligue1_id = 61
    #laliga_id = 140

    league_ids = [39, 78, 135, 61, 140] # IDs of the leagues you want to fetch data for
    leagues_data = []

    league_ids.each do |league_id|
      url = URI("https://api-football-v1.p.rapidapi.com/v3/leagues?id=#{league_id}")

      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true

      request = Net::HTTP::Get.new(url)
      request["X-RapidAPI-Key"] = '8957a47bfbmsh7ed6ded12eeef56p1ac9eajsn1e20ea768f8b'
      request["X-RapidAPI-Host"] = 'api-football-v1.p.rapidapi.com'

      response = http.request(request)
      lol = response.read_body
      data = JSON.parse(lol)
      league = data['response'][0]['league']
      league_name = league['name']
      league_logo = league['logo']

      leagues_data << { name: league_name, logo: league_logo }
    end

    leagues_data
  end

  puts "Cleaning up database..."
  League.destroy_all
  puts "Database cleaned"

  leagues = fetchleagues

    leagues.each do |league|
      League.create(league)
    end
    puts "created #{League.count} leagues!"
