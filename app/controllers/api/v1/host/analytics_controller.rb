module Api
  module V1
    module Host
      class AnalyticsController < ApplicationController
        before_action :authenticate_user!
        before_action :authenticate_host!

        # GET /api/v1/host/analytics
        def show
          listings = Property.where(host: current_user)
          bookings = Booking.where(property: listings)

          stats = {
            confirmed_bookings:     bookings.where(status: "confirmed").count,
            quality_checks_pending: QualityCheck.where(property: listings).where(state: %w[progress scheduled]).count,
            avg_approval_time:      "11 min",
            payout:                 8420,
            points:                 2148,
            points_delta:           328,
          }

          rewards = current_user.rewards.map { |r|
            {
              tier:  r.tier,
              met:   r.met,
              desc:  r.description,
              count: r.count_label,
            }
          }

          render json: { stats: stats, rewards: rewards }
        end
      end
    end
  end
end
