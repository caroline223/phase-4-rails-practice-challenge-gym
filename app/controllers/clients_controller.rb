class ClientsController < ApplicationController

    rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response
    rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity_response

    def index
        clients = Client.all 
        render json: clients, status: :ok
    end

    def show 
        client = find_client
        if client 
            render json: client, methods: total_membership_amount
        else
            render_not_found_response
        end
    end

    def update
        client = find_client
        if client.valid?
            client.update!(client_params)
            render json: client, status: :accepted
        else
            render_not_found_response
        end
    end


    private

    def find_client
        Client.find_by_id(params[:id])
    end

    def client_params
        params.permit(:name, :age)
    end

    def render_not_found_response
        render json: {error: "Client not found"}, status: :not_found 
    end

    def render_unprocessable_entity_response(invalid)
        render json: {errors: invalid.record.errors.full_messages}, status: :unprocessable_entity
    end

    def total_membership_amount
        find_client.memberships.sum(:charge)
    end

end
