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
        if authorized? && use_status? && need_renew? && can_download?
          categories = Category.all
          render json: { success: true, categories: CategorySerializer.build_array(categories) }
        else
          render json: { success: false, reason: @reason }
        end
      end

      private

      def check_request
      end

      def authorized?
        return true if @app.present?
        @reason = Messages::UNAUTHORIZED
        false
      end

      def use_status?
        return true if @app.status == 0
        @reason = 'APP禁用'
        false
      end

      def need_renew?
        return true if @app.present?
        @reason = '已经是最新'
        false
      end

      def can_download?
        return true if @app.present?
        @reason = '接口禁用'
        false
      end

    end
  end
end
