dekar = Character.new
dekar.name = "Dekar Raviede"
dekar.description = "First Lune Knight of Heaven."
dekar.save

danae = Character.new
danae.name = "Danae Sparrling"
danae.description = "Second Lune Knight of Heaven."
danae.save

gereval = City.new
gereval.name = "Gereval"
gereval.description = "Capital city of Andragar."
gereval.characters << dekar
gereval.characters << danae
gereval.save

andragar = Region.new
andragar.name = "Andragar"
andragar.description = "Dominant nation in Northrock."
andragar.cities << gereval
andragar.save
