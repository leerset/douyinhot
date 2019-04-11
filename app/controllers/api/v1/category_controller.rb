# Define a namespace for the Categories API.
module Api
  # Define a namespace for version 1.
  module V1
    # Define actions for categorys.
    class CategoryController < ParentController
      before_action :check_request

      # GET api/v1/download.
      # Get the download url for the file and redirect to it.
      def download
        if can_download_category? &&
           app_valid? &&
           app_can_use? &&
           is_newest?
          categories = Category.all
          render json: { success: true, categories: CategorySerializer.build_array(categories) }
        else
          render json: { success: false, reason: @reason }
        end
      end

      # def upload
      #   if user_authenticated? &&
      #      can_upload_category?
      #     upload_and_create_category
      #   else
      #     render json: { success: false, reason: @reason }
      #   end
      # end

      private

      def check_request
        @app.present? && @app.status
      end

      def app_use?
        @app.present? && @app.status
      end

      def category_exists?
        return true if @category.present?
        @reason = Messages::FILE_RESOURCE_NOT_FOUND
        false
      end

      def can_download_category?
        return true if @app.present?
        @reason = Messages::UNAUTHORIZED
        false
      end

    end
  end
end
