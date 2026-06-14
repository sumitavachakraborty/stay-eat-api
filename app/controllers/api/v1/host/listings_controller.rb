module Api
  module V1
    module Host
      class ListingsController < ApplicationController
        before_action :authenticate_user!
        before_action :authenticate_host!

        # GET /api/v1/host/listings
        def index
          listings = Property.where(host: current_user).order(:id)
          render json: { listings: listings.map { |p| listing_json(p) } }
        end

        # POST /api/v1/host/listings
        def create
          property = Property.new(listing_params.merge(host: current_user))

          unless property.save
            return render json: { error: property.errors.full_messages.join(", ") },
                          status: :unprocessable_entity
          end

          render json: { property: listing_json(property) }, status: :created
        end

        private

        def listing_params
          params.permit(
            :name, :place, :sub, :dates, :price, :rating, :reviews,
            :favorite, :badge, :host_name, :host_initial,
            :guests, :bedrooms, :beds, :baths, :description,
            photos: [], amenities: [], quality_rooms: []
          )
        end

        def listing_json(p)
          {
            id:       p.id,
            name:     p.name,
            place:    p.place,
            sub:      p.sub,
            dates:    p.dates,
            price:    p.price,
            rating:   p.rating.to_f,
            reviews:  p.reviews,
            favorite: p.favorite,
            badge:    p.badge,
            photos:   p.photos || [],
          }
        end
      end
    end
  end
end
