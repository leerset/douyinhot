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
        if authorized? && use_status? && has_category? && has_category_formula? &&
           mobile_has_gps? && mobile_has_id_code? &&
           has_sample? && valid_sample? && valid_sample_length? &&
           has_hardware_id? && can_use? && valid_result?
          render json: {
            success: true,
            code: @code,
            result: @resolution_result
          }
        else
          render json: { success: false, code: @code, reason: ResolutionRequest.exceptions.invert[@code] }
        end
      end

      private

      def set_params
        @hardware_id = params[:sn]
        @gps = params[:gps]
        @id_code = params[:ic]
        @sample = params[:x]
        @category_number = params[:cn]
        @category = Category.find_by(category_number: @category_number)
        @category_formula = @category.try(:category_formula)
        @formula_version = @category_formula.try(:version)
        @hardware_version = params[:hv]
        @software_version = params[:sv]
        @firm_name = params[:fn]
        @model_number = params[:mn]
      end

      def save_request
        @resolution_request = ResolutionRequest.create(
          app_id: @app_id,
          user_id: @user.try(:id),
          appuser_id: @appuser_id,
          request_ip: request.remote_ip,
          sample_value: @sample,
          category_number: @category_number,
          hardware_id: @hardware_id,
          formula_version: @formula_version,
          gps: @gps,
          id_code: @id_code,
          hardware_version: @hardware_version,
          software_version: @software_version,
          firm_name: @firm_name,
          model_number: @model_number
        )
      end

      def update_request
        @resolution_request.update(
          resolution_result: @resolution_result,
          return_status: @code
        )
      end

      def can_use?
        resolution = ApiManage.find_by(api_name: 'resolution')
        return true if resolution.present? && resolution.manage == 0
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

      def has_category?
        return true if @category.present?
        @code = 4
        false
      end

      def mobile_has_gps?
        return true unless @user_agent.present? && @user_agent.match(/Android|iPhone|iPad/)
        return true if @gps.present?
        @code = 5
        false
      end

      def has_hardware_id?
        return true if @hardware_id.present?
        @code = 6
        false
      end

      def mobile_has_id_code?
        return true unless @user_agent.present? && @user_agent.match(/Android|iPhone|iPad/i)
        return true if @id_code.present?
        @code = 7
        false
      end

      def valid_sample?
        return true if @sample.present? && @sample =~ /^[0-9A-F]+$/i
        @code = 8
        false
      end

      def has_sample?
        return true if @sample.present? && @sample != '00000000'
        @code = 9
        false
      end

      def has_category_formula?
        return true if @category_formula.present?
        @code = 10
        false
      end

      def valid_result?
        begin
          @resolution_result = @category_formula.calculate(@sample)
          return true
        rescue
          @code = 10
          false
        end
      end

      def valid_sample_length?
        return true if @sample.size == 8
        @code = 11
        false
      end

    end
  end
end
