require_relative 'db/database'
require_relative 'db/seeds'

namespace :db do
  task :migrate do
    Database.migrate!
  end

  task :seeds do
    Seeds.run!
  end

  task :truncate do
    Database.truncate!
  end
end
