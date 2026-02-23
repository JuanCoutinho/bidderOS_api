class EmbeddingService
  MODEL = "text-embedding-3-small"
  DIMENSIONS = 1536

  def initialize
    @client = OpenAI::Client.new
  end

  def generate(text)
    raise ArgumentError, "Text cannot be blank" if text.blank?

    truncated = truncate_text(text)

    response = @client.embeddings(
      parameters: {
        model: MODEL,
        input: truncated
      }
    )

    embedding = response.dig("data", 0, "embedding")
    raise "OpenAI returned no embedding data" if embedding.nil?

    embedding
  rescue OpenAI::Error => e
    Rails.logger.error("[EmbeddingService] OpenAI error: #{e.message}")
    raise
  end

  private

  def truncate_text(text, max_tokens: 8000)
    words = text.split
    words.first(max_tokens).join(" ")
  end
end
