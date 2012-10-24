module Votes
  class Engine < Rails::Engine
    paths["app/controllers"] << "lib/controllers"
    paths["app/models"] << "lib/models"
  end
end
