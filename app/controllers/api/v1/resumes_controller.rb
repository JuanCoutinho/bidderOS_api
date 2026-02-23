module Api
  module V1
    class ResumesController < ApplicationController
      def index
        resumes = current_user.resumes.select(:id, :filename, :created_at)
        render json: resumes, status: :ok
      end

      def create
        return render json: { error: 'No files sent or invalid format.' }, status: :bad_request unless params[:files].is_a?(Array)

        processed = []
        errors = []

        params[:files].each do |file|
          begin
            ResumeProcessorService.new(current_user, file.path, file.original_filename).call
            processed << file.original_filename
          rescue => e
            errors << { file: file.original_filename, reason: e.message }
          end
        end

        return render json: { message: 'Processing completed with warnings', processed: processed, errors: errors }, status: :unprocessable_entity unless errors.empty?

        render json: { message: 'Upload completed successfully!', processed: processed }, status: :ok
      end
    end
  end
end