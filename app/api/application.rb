module Api
  class Application < Grape::API
    version 'v1', using: :path
    format :json
    prefix :api

    helpers do
      def not_found!
        error!(:not_found, 404)
      end
    end

    resource :hotels do
      get :search do
        query = "%#{params[:q].to_s.downcase}%"

        condition = <<~SQL
          LOWER(name) like ? ESCAPE ?
          OR LOWER(address) like ? ESCAPE ?
        SQL

        hotels = Hotel.where(condition, query, '\\', query, '\\').all

        present hotels, with: Entities::Hotel
      end

      params do
        optional :limit, type: Integer
        optional :offset, type: Integer
      end

      get do
        limit = params[:limit].to_i
        limit = 100 if limit == 0 || limit > 100
        hotels = Hotel.order(:id).reverse
                      .limit(limit)
                      .offset(params[:offset])
                      .all

        present hotels, with: Entities::Hotel
      end

      params do
        requires :name, type: String
        requires :address, type: String
        requires :accommodation_type, type: String
      end

      post do
        hotel = Hotel.create name: params[:name],
                             address: params[:address],
                             accommodation_type: params[:accommodation_type]

        present hotel, with: Entities::Hotel
      end

      route_param :id do
        get do
          hotel = Hotel[params[:id]] || not_found!
          present hotel, with: Entities::Hotel
        end

        put do
          hotel = Hotel[params[:id]] || not_found!
          hotel.update name: params[:name],
                       address: params[:address],
                       accommodation_type: params[:accommodation_type]

          present hotel, with: Entities::Hotel
        end

        delete do
          hotel = Hotel[params[:id]] || not_found!
          hotel.destroy
          present hotel, with: Entities::Hotel
        end
      end
    end
  end
end
