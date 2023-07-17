class UsersController < ApplicationController

    def create
        user = User.new(user_params)
        if params[:password] == params[:password_confirmation]
            if user.valid?
                user.save
                session[:user_id] = user.id 
                render json: user, status: :created
            else
                render json: {error: "Invalid user"}, status: :unprocessable_entity
            end
        else 
            render json: {errors: user.errors.full_messages}, status: :unprocessable_entity
        end
    end

    def show
        user = User.find_by(id: session[:user_id])
        if user
            render json: user
        else 
            render json: {error: "Unauthorized"}, status: :unauthorized
        end
    end

    private

    def user_params
        params.permit(:username, :password, :password_digest, :image_url, :bio)
    end
end
