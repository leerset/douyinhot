# Define a namespace for the Categories API.
module Api
  # Define a namespace for version 1.
  module V1
    # Define actions for categorys.
    class CategoryController < ParentController
      before_action :set_params
      before_action :save_request

      # GET api/v1/download.
      # Get the download url for the file and redirect to it.
      def download
        @code = 0
        if authorized? && use_status? && need_renew? && can_use? && mobile_has_idcode?
          @category_request.update(release_status: 2)
          categories = Category.all.order(:category_number)
          render json: { success: true, code: @code, categories: CategorySerializer.build_array(categories) }
        else
          @category_request.update(release_status: 0)
          render json: { success: false, code: @code, reason: CategoryRequest.exceptions.invert[@code] }
        end
      end

      private

      def set_params
        @idcode = params[:idcode]
      end

      def save_request
        @category_request = CategoryRequest.create(
          app_id: @app_id,
          user_id: @user.try(:id),
          request_status: -1,
          release_status: 1,
          request_ip: request.remote_ip,
          id_code: @idcode,
        )
      end

      def can_use?
        return true if @app.present?
        @code = 1
        false
      end

      def use_status?
        return true if @app.status == 0
        @code = 2
        false
      end

      def authorized?
        return true if @app.present?
        @code = 3
        false
      end

      def need_renew?
        last_request_time = @app.category_requests.where.not(id: @category_request.id).map(&:request_time).max
        return true if last_request_time < Category.last_updated_at
        @code = 4
        false
      end

      def mobile_has_idcode?
        return true unless @user_agent.present? && @user_agent.match(/Android|iPhone|iPad/i)
        return true if @idcode.present?
        @code = 7
        false
      end

    end
  end
end
