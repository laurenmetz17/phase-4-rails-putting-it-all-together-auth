class RecipesController < ApplicationController
    def index
        user = session[:user_id]
        if user
            recipes = Recipe.all
            render json: recipes, include: :user
        else
            render json: {errors: ["no user logged in"]}, status: :unauthorized
        end
    end

    def create
        user = User.find_by(id: session[:user_id])
        if user
            recipe = user.recipes.new(recipe_params)
            if recipe.valid?
                recipe.save
                render json: recipe, include: :user, status: :created
            else
                render json: {errors: recipe.errors.full_messages}, status: :unprocessable_entity
            end
        else
            render json: {errors: ["no user logged in"]}, status: :unauthorized
        end           
    end

    private

    def recipe_params
        params.permit(:title, :instructions, :minutes_to_complete)
    end
end
