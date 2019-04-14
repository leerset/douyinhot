# Define a namespace for the Categories API.
module Api
  # Define a namespace for version 1.
  module V1
    # Define actions for resolutions.
    class ResolutionController < ParentController
      before_action :set_params
      before_action :save_request
      after_action :update_request

      # GET api/v1/download.
      # Get the download url for the file and redirect to it.
      def calculate
        @code = 0
        if authorized? && use_status? && has_category? && has_category_formula? && has_sample? && valid_sample? && has_hardware_id? && can_use? && valid_result?
          render json: {
            success: true,
            code: @code,
            result: @resolution_result
          }
        else
          render json: { success: false, code: @code, reason: @reason }
        end
      end

      private

      def set_params
        @sample = params[:x]
        @category_number = params[:cn]
        @category = Category.find_by(category_number: @category_number)
        @category_formula = @category.try(:category_formula)
        @formula_version = @category_formula.try(:version)
        @hardware_id = params[:sn]
      end

      def save_request
        @resolution_request = ResolutionRequest.create(
          app_id: @app_id,
          user_id: @user.try(:id),
          request_ip: request.remote_ip,
          sample_value: @sample,
          category_number: @category_number,
          hardware_id: @hardware_id,
          formula_version: @formula_version,
        )
      end

      def update_request
        @resolution_request.update(
          resolution_result: @resolution_result,
          return_status: @code
        )
      end

      def authorized?
        return true if @app.present?
        @code = 3
        @reason = '用户无效'
        false
      end

      def use_status?
        return true if @app.status == 0
        @code = 2
        @reason = '用户停止服务'
        false
      end

      def has_category?
        return true if @category.present?
        @code = 4
        @reason = '品类无效'
        false
      end

      def has_category_formula?
        return true if @category_formula.present?
        @code = 10
        @reason = '公式异常1'
        false
      end

      def has_sample?
        return true if @sample.present?
        @code = 9
        @reason = '缺少采集值'
        false
      end

      def has_hardware_id?
        return true if @hardware_id.present?
        @code = 6
        @reason = '硬件编号无效'
        false
      end

      def valid_sample?
        return true if @sample != '0' && @sample.strip =~ /^\d+(\.\d*)?$/ && @sample.size == 8 && @sample.to_f > 0
        @code = 8
        @reason = '采集值无效'
        false
      end

      def valid_result?
        begin
          x = @sample.to_f
          @resolution_result = @category_formula.calculate(x)
          return true
        rescue
          @code = 10
          @reason = '公式异常2'
          false
        end
      end

      def can_use?
        return true if @app.present?
        @code = 1
        @reason = '接口关闭'
        false
      end

    end
  end
end
