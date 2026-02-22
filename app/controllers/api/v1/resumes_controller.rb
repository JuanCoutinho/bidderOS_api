module Api
  module V1
    class ResumesController < ApplicationController
      def index
        resumes = current_user.resumes.select(:id, :filename, :created_at)
        render json: resumes, status: :ok
      end

      def create
        unless params[:files].is_a?(Array)
          return render json: { error: 'No files sent or invalid format.' }, status: :bad_request
        end

        processed = []
        errors = []

        params[:files].each do |file|
          begin
            ResumeProcessorService.new(current_user, file.path).call
            processed << file.original_filename
          rescue => e
            errors << { file: file.original_filename, reason: e.message }
          end
        end

        if errors.empty?
          render json: { message: 'Upload completed successfully!', processed: processed }, status: :ok
        else
          render json: { message: 'Processing completed with warnings', processed: processed, errors: errors }, status: :unprocessable_entity
        end
      end
    end
  end
end