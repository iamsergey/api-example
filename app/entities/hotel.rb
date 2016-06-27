module Entities
  class Hotel < Grape::Entity
    expose :id
    expose :name
    expose :address
    expose :accommodation_type
  end
end
