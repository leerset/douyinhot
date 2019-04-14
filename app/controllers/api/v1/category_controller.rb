# Define a namespace for the Categories API.
module Api
  # Define a namespace for version 1.
  module V1
    # Define actions for categorys.
    class CategoryController < ParentController
      before_action :save_request

      # GET api/v1/download.
      # Get the download url for the file and redirect to it.
      def download
        if authorized? && use_status? && need_renew? && can_use?
          @category_request.update(release_status: 2)
          categories = Category.all.order(:category_number)
          render json: { success: true, categories: CategorySerializer.build_array(categories) }
        else
          @category_request.update(release_status: 0)
          render json: { success: false, reason: @reason }
        end
      end

      private

      def save_request
        @category_request = CategoryRequest.create(
          app_id: @app_id,
          user_id: @user.try(:id),
          request_status: -1,
          release_status: 1,
          request_ip: request.remote_ip
        )
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
        last_request_time = @app.category_requests.where.not(id: @category_request.id).map(&:request_time).max
        return true if last_request_time < Category.last_updated_at
        @reason = '已是最新'
        false
      end

      def can_use?
        return true if @app.present?
        @reason = '接口禁用'
        false
      end

    end
  end
end
