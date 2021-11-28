class MembershipsController < ApplicationController

    rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity_response

    def index
        render json: Membership.all, status: :ok
    end

    def create 
        membership = Membership.create!(membership_params)
        if membership.valid?
            render json: membership, status: :created
        else
            render_unprocessable_entity_response
        end
    end


    private

    def membership_params
        params.permit(:gym_id, :client_id, :charge)
    end

    def render_unprocessable_entity_response(invaild)
        render json: {errors: invalid.record.errors.full_messages}, status: :ok
    end


end
