# Description
An example of super light weight API, rack application based on Grape
# Instructions
First of all you need to create a PostgreSQL database
and then
```
export DATABASE_URL=postgreql://username@localhost/databasename`
rake db:migrate
rake db:seeds
rackup config.ru
```
# Specs
```
rspec spec
```
