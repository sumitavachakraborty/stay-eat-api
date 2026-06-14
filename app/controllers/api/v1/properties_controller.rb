module Api
  module V1
    class PropertiesController < ApplicationController
      # GET /api/v1/properties
      def index
        properties = Property.all.order(:id)
        render json: { properties: properties.map { |p| property_summary_json(p) } }
      end

      # GET /api/v1/properties/:id
      def show
        property = Property.find(params[:id])
        render json: { property: property_detail_json(property) }
      end

      private

      def property_summary_json(p)
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

      def property_detail_json(p)
        property_summary_json(p).merge(
          host_name:    p.host_name,
          host_initial: p.host_initial,
          guests:       p.guests,
          bedrooms:     p.bedrooms,
          beds:         p.beds,
          baths:        p.baths,
          description:  p.description,
          amenities:    p.amenities || [],
          quality_rooms: p.quality_rooms || [],
          price_breakdown: {
            nightly:  p.price,
            nights:   5,
            cleaning: 80,
            total:    (p.price * 5) + 80,
          },
        )
      end
    end
  end
end
