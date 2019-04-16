# Define a namespace for Api.
module Api
  # Define a namespace for version 1.
  module V1
    # Define parent class for all API v1 controllers.
    class ParentController < ApplicationController
      skip_before_action :authenticate_user!
      before_action :set_credentials
      before_action :set_app

      # Set credentials variables.
      def set_credentials
        @appuser_id = request.headers["Green-Userid"]
        @app_id = request.headers["Green-Appid"]
        @user_agent = request.headers["User-Agent"]
      end

      # Find the user by the provided username or ith_user_id.
      def set_app
        @app = App.find_by(app_id: @app_id)
      end

    end
  end
end
