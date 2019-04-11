# Define a namespace for Api.
module Api
  # Define a namespace for version 1.
  module V1
    # Define parent class for all API v1 controllers.
    class ParentController < ApplicationController
      skip_before_action :authenticate_user!
      before_action :set_credentials
      before_action :set_app
      before_action :set_user

      # Set credentials variables.
      def set_credentials
        @username = request.headers["Green-Username"]
        @app_id = request.headers["Green-Appid"]
      end

      # Find the user by the provided username or ith_user_id.
      def set_user
        @user = User.find_by(user_name: @username)
      end

      # Find the user by the provided username or ith_user_id.
      def set_app
        @app = App.find_by(app_id: @app_id)
      end

    end
  end
end
