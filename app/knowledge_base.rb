require "sinatra"
require "data_mapper"

require "models/models"

require "haml"
require "rdiscount"

require "andand"

require "pry"
require "pry-nav"
require "pry-stack_explorer"


configure :production do
  DataMapper.setup :default, ENV["DATABASE_URL"] # set by Heroku
  DataMapper.finalize
  DataMapper.auto_upgrade!
end

configure :dev do
  puts "Configuring for dev environment."
  DataMapper::Logger.new $stdout, :debug
  DataMapper::Model.raise_on_save_failure = true
  DataMapper.setup :default, "postgres://dragonhunt:darketernal@localhost/dh-kb"
  DataMapper.finalize
  DataMapper.auto_upgrade! # attempts not to lose data
end

configure :test do
  puts "Configuring for test environment."
  DataMapper::Model.raise_on_save_failure = true
  DataMapper.setup :default, "postgres://dragonhunt:darketernal@localhost/dh-kb-test"
  DataMapper.finalize
  DataMapper.auto_migrate! # destroys all data
end

# this file is in ${SITE_ROOT}/app, serve static files from ${SITE_ROOT}/public
set :public_folder, File.join(File.dirname(__FILE__), "/../public")

# Return bootstrap page for knowledge base.
# TODO: load from external file
get "/" do
  haml :index
end

# Characters
get "/character/:id" do |id|
  content_type :json
  if id =~ /^\d+$/
    character = Character.get id
  else
    # replace underscores in search URL with spaces
    character = Character.first :name.like => "%#{id.gsub "_", " "}%"
  end

  character.andand.to_json :methods => Character::EXPOSED
end

post "/character" do
  content_type :json

  character = Character.new
  character.name = params["name"]
  character.description = params["description"]
  # TODO: associations?
  character.save

  # TODO: find out how places/groups get encoded and handle creating them ...is
  # creating a character along with groups (or groups along with members) a
  # reasonable thing to do in one REST request? Doubtful. Figure out the
  # relationship among these things and come up with an answer.
end

put "/character/:id" do |id|
  content_type :json

  character = Character.get id
  character.name = params["name"]
  character.description = params["description"]

  # handle city association
  if params["city"]
    character.city = City.get params["city"]["id"]
  else
    character.city = nil
  end

  if params["region"]
    character.region = Region.get params["region"]["id"]
  else
    character.region = nil
  end

  # handle group association
  existing = character.groups.map {|g| g.id}
  incoming = params["groups"].map {|g| g["id"].to_i}
  to_remove = existing - incoming
  to_add = incoming - existing

  to_remove.each do |id|
    character.groups.delete Group.get(id)
  end

  to_add.each do |id|
    character.groups << Group.get(id)
  end

  character.save
end

delete "/character/:id" do |id|
  character = Character.get id
  character.destroy
end

# TODO: character search URLs

# Cities
get "/city/:id" do |id|
  content_type :json
  if id =~ /^\d+$/
    city = City.get id
  else
    # replace underscores in search URL with spaces
    city = City.first :name.like => "%#{id.gsub "_", " "}%"
  end

  city.andand.to_json :methods => City::EXPOSED
end

post "/city" do
  content_type :json

  city = City.new
  city.name = params["name"]
  city.description = params["description"]
  # TODO: associations?
  city.save

  # TODO: find out how places/groups get encoded and handle creating them ...is
  # creating a city along with groups (or groups along with members) a
  # reasonable thing to do in one REST request? Doubtful. Figure out the
  # relationship among these things and come up with an answer.
end

put "/city/:id" do |id|
  content_type :json

  city = City.get id
  city.name = params["name"]
  city.description = params["description"]
  # TODO: associations?
  city.save
end

delete "/city/:id" do |id|
  city = City.get id
  city.destroy
end

# Regions
get "/region/:id" do |id|
  content_type :json
  if id =~ /^\d+$/
    region = Region.get id
  else
    # replace underscores in search URL with spaces
    region = Region.first :name.like => "%#{id.gsub "_", " "}%"
  end

  region.andand.to_json :methods => Region::EXPOSED
end

post "/region" do
  content_type :json

  region = Region.new
  region.name = params["name"]
  region.description = params["description"]
  # TODO: associations?
  region.save

  # TODO: find out how places/groups get encoded and handle creating them ...is
  # creating a region along with groups (or groups along with members) a
  # reasonable thing to do in one REST request? Doubtful. Figure out the
  # relationship among these things and come up with an answer.
end

put "/region/:id" do |id|
  content_type :json

  region = Region.get id
  region.name = params["name"]
  region.description = params["description"]
  # TODO: associations?
  region.save
end

delete "/region/:id" do |id|
  region = Region.get id
  region.destroy
end

# Groups
get "/group/:id" do |id|
  content_type :json
  if id =~ /^\d+$/
    group = Group.get id
  else
    # replace underscores in search URL with spaces
    group = Group.first :name.like => "%#{id.gsub "_", " "}%"
  end

  group.andand.to_json :methods => Group::EXPOSED
end

post "/group" do
  content_type :json

  group = Group.new
  group.name = params["name"]
  group.description = params["description"]
  # TODO: associations?
  group.save

  # TODO: find out how places/groups get encoded and handle creating them ...is
  # creating a group along with groups (or groups along with members) a
  # reasonable thing to do in one REST request? Doubtful. Figure out the
  # relationship among these things and come up with an answer.
end

put "/group/:id" do |id|
  content_type :json

  group = Group.get id
  group.name = params["name"]
  group.description = params["description"]
  # TODO: associations?
  group.save
end

delete "/group/:id" do |id|
  group = Group.get id
  group.destroy
end
