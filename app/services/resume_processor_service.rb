class ResumeProcessorService
  def initialize(user, file_path)
    @user = user
    @file_path = file_path
    @embedding_service = EmbeddingService.new
  end

  def call
    text = extract_text_from_file
    embedding = generate_embedding(text)

    @user.resumes.create!(
      filename: File.basename(@file_path),
      content_text: text,
      embedding: embedding
    )
  end

  private

  def extract_text_from_file
    reader = PDF::Reader.new(@file_path)
    reader.pages.map(&:text).join("\n")
  rescue => e
    Rails.logger.error("[ResumeProcessorService] Error extracting text: #{e.message}")
    ""
  end

  def generate_embedding(text)
    return nil if text.blank?

    @embedding_service.generate(text)
  rescue => e
    Rails.logger.error("[ResumeProcessorService] Error generating embedding: #{e.message}")
    nil
  end
end