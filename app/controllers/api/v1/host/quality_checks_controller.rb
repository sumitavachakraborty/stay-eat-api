module Api
  module V1
    module Host
      class QualityChecksController < ApplicationController
        before_action :authenticate_user!
        before_action :authenticate_host!

        # GET /api/v1/host/quality_checks
        def index
          checks = QualityCheck
                     .joins(:property)
                     .where(properties: { host_id: current_user.id })
                     .includes(:property)
                     .order(:check_in)

          render json: { quality_checks: checks.map { |qc| quality_check_summary_json(qc) } }
        end

        # GET /api/v1/host/quality_checks/:id
        def show
          check = QualityCheck
                    .joins(:property)
                    .where(properties: { host_id: current_user.id })
                    .find(params[:id])

          render json: { quality_check: quality_check_detail_json(check) }
        end

        private

        def quality_check_summary_json(qc)
          {
            id:       qc.id,
            property: {
              name:  qc.property.name,
              photo: qc.property.photos&.first,
            },
            guest:    qc.guest_name,
            check_in: qc.check_in,
            note:     qc.note,
            state:    qc.state,
            pct:      qc.pct,
          }
        end

        def quality_check_detail_json(qc)
          quality_check_summary_json(qc).merge(
            rooms: (qc.rooms || []).map { |r|
              {
                id:       r["id"],
                name:     r["name"],
                count:    r["count"],
                required: r["required"],
                status:   r["status"],
                img:      r["img"],
              }
            }
          )
        end
      end
    end
  end
end
