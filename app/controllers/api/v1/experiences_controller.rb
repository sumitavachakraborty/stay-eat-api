module Api
  module V1
    class ExperiencesController < ApplicationController
      # GET /api/v1/experiences
      def index
        experiences = Experience.all.order(:id)
        render json: {
          experiences: experiences.map { |e|
            {
              id:    e.slug,
              name:  e.name,
              place: e.place,
              host:  e.host_name,
              price: e.price,
              img:   e.img,
            }
          }
        }
      end
    end
  end
end
