require 'sinatra'

# Return a usage page.
get '/' do
  "Index page. This is the only thing that should have HAML."
end

# Characters
get '/character/:id' do |id|
  if id =~ /^\d+$/
    "Get the character with the id #{id}."
  else
    "Search for characters named #{id}."
  end

  # TODO: load the Backbone app, but pushState some stuff
end

get '/character/at/:place' do |location|
  "Search for characters at #{place}"
end

get '/character/from/:place' do |place|
  "Search for characters from #{place}"
end

get '/character/in/:group' do |group|
  "Search characters in #{group}"
end

# Places
get '/place/:id' do |id|
  if id =~ /^\d+$/
    "Get the place with the id #{id}."
  else
    "Search for places named #{id}."
  end
end

# Groups
get '/group/:id' do |id|
  if id =~ /^\d+$/
    "Get the group with the id #{id}."
  else
    "Search for groups named #{id}."
  end
end
