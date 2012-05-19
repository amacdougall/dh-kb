require "knowledge_base"
require "rack/test"
require "json"
require "yaml"

require "minitest/autorun"

# enable runtime debugging with pry
require "pry"
require "pry-nav"
require "pry-stack_explorer"


class TestKnowledgeBase < MiniTest::Unit::TestCase
  include Rack::Test::Methods

  # Required by rack/test.
  def app
    Sinatra::Application
  end

  def setup
    @prefab = YAML.load(File.open("test/test_data.yml"))

    @dekar = Character.create @prefab["characters"]["dekar"] # implies save()

    @gereval = City.create @prefab["cities"]["gereval"]
    @gereval.characters << @dekar
    @gereval.save

    @andragar = Region.create @prefab["regions"]["andragar"]
    @andragar.characters << @dekar
    @andragar.cities << @gereval
    @andragar.save

    @heaven = Group.create @prefab["groups"]["heaven"]
    @heaven.characters << @dekar
    @heaven.save
  end

  def teardown
    @dekar.groups.clear # must clear, since it's many-to-many
    @dekar.save
    @dekar.destroy

    @gereval.characters.clear
    @gereval.save
    @gereval.destroy

    @andragar.cities.clear
    @andragar.characters.clear
    @andragar.save
    @andragar.destroy

    @heaven.reload # to reflect change wrought by clearing Dekar's groups
    @heaven.characters.clear
    @heaven.save
    @heaven.destroy
  end

  def test_get_character_by_id
    get "/character/#{@dekar.id}"

    assert last_response.ok?
    character_data = JSON.parse last_response.body
    assert_equal @dekar.id, character_data["id"]
    assert_equal "Dekar Raviede", character_data["name"]
    assert_match /Lune Knights of Heaven/, character_data["description"]
  end

  def test_get_character_by_name
    api_name = @dekar.name.gsub " ", "_"

    get "/character/#{api_name}"

    assert last_response.ok?
    character_data = JSON.parse last_response.body
    assert_equal "Dekar Raviede", character_data["name"]
    assert_match /Lune Knights of Heaven/, character_data["description"]

    get "/character/#{@dekar.name.split[0]}" # just "Dekar"

    assert last_response.ok?
    character_data = JSON.parse last_response.body
    assert_equal "Dekar Raviede", character_data["name"]
    assert_match /Lune Knights of Heaven/, character_data["description"]
  end

  def test_create_character
    post "/character", @prefab["characters"]["poya"]

    assert last_response.ok?
    character = Character.first :name.like => "Poya Kern"
    assert_equal "Poya Kern", character.andand.name
    assert_match /Knight Blade of Heaven/, character.andand.description
    character.destroy
  end

  def test_put_character
    dekar_data = @dekar.to_json :methods => Character::EXPOSED
    dekar_data = JSON.parse(dekar_data)

    # test properties
    dekar_data["name"] = "Aaron Wrenfall"
    put "/character/#{@dekar.id}", dekar_data
    @dekar.reload # make sure the update is reflected in this instance variable
    assert_equal "Aaron Wrenfall", @dekar.name

    # test association change
    ilium = City.create @prefab["cities"]["ilium"]
    ilium_data = ilium.to_json :methods => City::EXPOSED
    ilium_data = JSON.parse(ilium_data)
    dekar_data["city"] = ilium_data
    put "/character/#{@dekar.id}", dekar_data
    @dekar.reload
    assert_equal ilium, @dekar.city

    church = Group.create @prefab["groups"]["church_of_michael"]
    church_data = church.to_json :methods => Group::EXPOSED
    church_data = JSON.parse(church_data)
    dekar_data["groups"] << church_data
    put "/character/#{@dekar.id}", dekar_data
    @dekar.reload
    assert_includes @dekar.groups, church

    # test association remove
    dekar_data["city"] = nil
    put "/character/#{@dekar.id}", dekar_data
    @dekar.reload
    assert_nil @dekar.city

    dekar_data["groups"].reject! {|g| g["id"].to_i == @heaven.id}
    put "/character/#{@dekar.id}", dekar_data
    @dekar.reload
    refute_includes @dekar.groups, @heaven

    church.reload
    church.characters.clear
    church.save
    church.destroy
    assert church.destroyed?, "Failed to clean up temporary church record."
  end

  def test_delete_character
    poya = Character.create @prefab["characters"]["poya"]
    id = poya.id
    delete "/character/#{poya.id}"
    assert_nil Character.get id
  end

  # TODO: test character associations

  # City tests
  def test_get_city_by_id
    get "/city/#{@gereval.id}"
    assert last_response.ok?
    city_data = JSON.parse last_response.body
    assert_equal "Gereval", city_data["name"]
    assert_match /Capital city of Andragar/, city_data["description"]
  end

  def test_get_city_by_name
    get "/city/Gereval"
    assert last_response.ok?
    city_data = JSON.parse last_response.body
    assert_equal "Gereval", city_data["name"]
    assert_match /Capital city of Andragar/, city_data["description"]
  end

  def test_create_city
    post "/city", @prefab["cities"]["ilium"]

    assert last_response.ok?
    city = City.first :name.like => "Ilium"
    assert_equal "Ilium", city.andand.name
    assert_match /A city of the Silver Coast/, city.andand.description
    city.destroy
  end

  def test_put_city
    gereval_data = @gereval.to_json :methods => City::EXPOSED
    gereval_data = JSON.parse(gereval_data)
    gereval_data["name"] = "Rivalon"

    put "/city/#{@gereval.id}", gereval_data
    @gereval.reload # make sure the update is reflected in this instance variable

    assert_equal "Rivalon", @gereval.name
  end

  def test_delete_city
    ilium = City.create @prefab["cities"]["ilium"]
    id = ilium.id
    delete "/city/#{ilium.id}"

    assert_nil City.get id
  end

  # Region tests
  def test_get_region_by_id
    get "/region/#{@andragar.id}"
    assert last_response.ok?
    region_data = JSON.parse last_response.body
    assert_equal "Andragar", region_data["name"]
    assert_match /Ruled by the great dragon Dark Eternal/, region_data["description"]
  end

  def test_get_region_by_name
    get "/region/Andragar"
    assert last_response.ok?
    region_data = JSON.parse last_response.body
    assert_equal "Andragar", region_data["name"]
    assert_match /Ruled by the great dragon Dark Eternal/, region_data["description"]

    silver_coast = Region.create @prefab["regions"]["silver_coast"]
    get "/region/Silver_Coast"
    assert last_response.ok?
    region_data = JSON.parse last_response.body
    assert_equal "The Silver Coast", region_data["name"]
  end

  def test_create_region
    post "/region", @prefab["regions"]["silver_coast"]

    assert last_response.ok?
    region = Region.first :name.like => "%Silver Coast%"
    assert_equal "The Silver Coast", region.andand.name
    region.destroy
  end

  def test_put_region
    andragar_data = @andragar.to_json :methods => Region::EXPOSED
    andragar_data = JSON.parse(andragar_data)
    andragar_data["name"] = "Karth"

    put "/region/#{@andragar.id}", andragar_data
    @andragar.reload # make sure the update is reflected in this instance variable

    assert_equal "Karth", @andragar.name
  end

  def test_delete_region
    silver_coast = Region.create @prefab["regions"]["silver_coast"]
    id = silver_coast.id
    delete "/region/#{silver_coast.id}"

    assert_nil Region.get id
  end

  # Group tests
  def test_get_group_by_id
    get "/group/#{@heaven.id}"
    assert last_response.ok?
    group_data = JSON.parse last_response.body
    assert_equal "Heaven", group_data["name"]
    assert_match /Elite military force of Andragar/, group_data["description"]
  end

  def test_get_group_by_name
    get "/group/Heaven"
    assert last_response.ok?
    group_data = JSON.parse last_response.body
    assert_equal "Heaven", group_data["name"]
    assert_match /Elite military force of Andragar/, group_data["description"]

    church_of_michael = Group.create @prefab["groups"]["church_of_michael"]
    get "/group/Church_of_Michael"
    assert last_response.ok?
    group_data = JSON.parse last_response.body
    assert_equal "The Church of Michael", group_data["name"]
  end

  def test_create_group
    post "/group", @prefab["groups"]["church_of_michael"]

    assert last_response.ok?
    group = Group.first :name.like => "%Church of Michael%"
    assert_equal "The Church of Michael", group.andand.name
    group.destroy
  end

  def test_put_group
    heaven_data = @heaven.to_json :methods => Group::EXPOSED
    heaven_data = JSON.parse(heaven_data)
    heaven_data["name"] = "Hell"

    put "/group/#{@heaven.id}", heaven_data
    @heaven.reload # make sure the update is reflected in this instance variable

    assert_equal "Hell", @heaven.name
  end

  def test_delete_group
    church_of_michael = Group.create @prefab["groups"]["church_of_michael"]
    id = church_of_michael.id
    delete "/group/#{church_of_michael.id}"

    assert_nil Group.get id
  end
end
