module Api
  module V1
    class CategoriesController < ApplicationController
      # GET /api/v1/categories
      def index
        # Category model is lightweight; using a simple AR query
        categories = Category.all.order(:id)
        render json: {
          categories: categories.map { |c| { id: c.slug, label: c.label, icon: c.icon } }
        }
      end
    end
  end
end
