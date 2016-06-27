require 'sequel'

module Database
  class << self
    def connect
      @connection ||= if url.empty? || ENV['RACK_ENV'] == 'test'
                        Sequel.sqlite
                      else
                        Sequel.connect(url)
                      end
    end

    def url
      ENV.fetch('DATABASE_URL')
    end

    def truncate!
      connect.tables.each do |table|
        connect[table].delete
      end
    end

    def migrate!
      Sequel.extension(:migration)
      Sequel::Migrator.apply(self, 'db/migrations')
    end

    def method_missing(method, *args, &block)
      connect.send(method, *args, &block)
    end
  end

  connect
end
