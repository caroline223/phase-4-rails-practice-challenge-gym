class GymsController < ApplicationController

    rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response 
    rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity_response

    def index
        gyms = Gym.all 
        render json: gyms, status: :ok
    end

    def show 
        gym = find_gym
        if gym
            render json: gym, status: :ok
        else
            render_not_found_response
        end
    end

    def update
        gym = find_gym
        if gym.valid
         gym.update!(gym_params)
         render json: gym, status: :accepted
        else
            render_unprocessable_entity_response
        end
    end



    def destroy 
        gym = find_gym  
        if gym 
            render json: gym, status: :ok
        else
            render_not_found_response
        end
    end

    private 

    def find_gym
        Gym.find_by_id(params[:id])
    end

    def gym_params
        params.permit(:name, :address)
    end

    def render_not_found_response
        render json: {error: "Gym not found"}, status: :not_found
    end

    def render_unprocessable_entity_response(invalid)
        render json: {errors: invalid.record.errors.full_messages}, status: :unprocessable_entity
    end


end
