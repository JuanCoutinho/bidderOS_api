class Api::ResumesController < ApplicationController
  def index
    user = User.first
    resumes = user.resumes.select(:id, :file_path, :created_at)
    render json: resumes, status: :ok
  end
  
  def create
    user = User.first || User.create!(email: "teste@teste.com", password: "password")
    
    unless params[:files].is_a?(Array)
      return render json: { error: "Nenhum arquivo enviado ou formato inválido." }, status: :bad_request
    end

    processed = []
    errors = []
    params[:files].each do |file|
      begin
        ResumeProcessorService.new(user, file.path).call
        processed << file.original_filename 
      rescue => e
        errors << { file: file.original_filename, reason: e.message }
      end
    end

    if errors.empty?
      render json: { message: "Upload concluído com sucesso!", processed: processed }, status: :ok
    else
      render json: { message: "Processamento concluído com ressalvas", processed: processed, errors: errors }, status: :unprocessable_entity
    end
  end
end