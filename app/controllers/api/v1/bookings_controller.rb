module Api
  module V1
    class BookingsController < ApplicationController
      before_action :authenticate_user!

      # GET /api/v1/bookings
      def index
        bookings = current_user.bookings.includes(:property).order(created_at: :desc)
        render json: { bookings: bookings.map { |b| booking_json(b) } }
      end

      # POST /api/v1/bookings
      def create
        property = Property.find(params[:property_id])
        booking  = current_user.bookings.build(booking_params.merge(property: property))

        unless booking.save
          return render json: { error: booking.errors.full_messages.join(", ") },
                        status: :unprocessable_entity
        end

        render json: { booking: booking_json(booking) }, status: :created
      end

      private

      def booking_params
        params.permit(:check_in, :check_out, :guests)
      end

      def booking_json(b)
        {
          id:          b.id,
          property_id: b.property_id,
          property:    {
            id:    b.property.id,
            name:  b.property.name,
            place: b.property.place,
            photo: b.property.photos&.first,
          },
          check_in:    b.check_in,
          check_out:   b.check_out,
          guests:      b.guests,
          status:      b.status,
          created_at:  b.created_at,
        }
      end
    end
  end
end
