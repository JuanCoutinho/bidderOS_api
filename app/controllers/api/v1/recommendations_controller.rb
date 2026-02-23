module Api
  module V1
    class RecommendationsController < ApplicationController
      def index
        job_description = params[:job_description].to_s.strip

        return render json: { error: 'job_description is required.' }, status: :bad_request if job_description.blank?

        embedding = EmbeddingService.new.generate(job_description)

        results = current_user.resumes
          .nearest_neighbors(:embedding, embedding, distance: 'cosine')
          .limit(5)

        render json: results.map { |r|
          {
            id: r.id,
            filename: r.filename,
            created_at: r.created_at,
            score: ((1 - r.neighbor_distance) * 100).round(1)
          }
        }, status: :ok
      rescue => e
        Rails.logger.error("[RecommendationsController] #{e.message}")
        render json: { error: 'Failed to process recommendation.' }, status: :internal_server_error
      end

      def generate_cover_letter
        resume_id = params[:resume_id]
        job_description = params[:job_description].to_s.strip

        return render json: { error: 'resume_id and job_description are required.' }, status: :bad_request if resume_id.blank? || job_description.blank?

        resume = current_user.resumes.find_by(id: resume_id)
        return render json: { error: 'Resume not found.' }, status: :not_found if resume.nil?
        return render json: { error: 'This resume has no extracted text.' }, status: :unprocessable_entity if resume.content_text.blank?

        letter = CoverLetterService.new(resume.content_text, job_description).generate

        render json: { cover_letter: letter }, status: :ok
      rescue => e
        Rails.logger.error("[RecommendationsController] Cover Letter Error: #{e.message}")
        render json: { error: 'Failed to generate cover letter.' }, status: :internal_server_error
      end
    end
  end
end
