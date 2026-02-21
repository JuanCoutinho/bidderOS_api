class ResumeProcessorService
    def initialize(user, file_path)
        @user = user
        @file_path = file_path
    end

    def call
        text = extract_text_from_file
        raise "Failed to extract text from file" if text.blank?
    
        embedding = generate_embedding(text)   
        
        @user.resumes.create!(
            file_path: @file_path,
            text: text,
            embedding: embedding
        )
    end

    private

    def extract_text_from_file
       reader = PDF::Reader.new(@file_path)
       reader.pages.map(&:text).join("\n")
    rescue => e
        Rails.logger.error("Error extracting text from file: #{e.message}")
        nil
    end

    def generate_embedding(text)
        response = OpenAI::Client.new.embeddings.create(
            model: "text-embedding-ada-002",
            input: text
        )
        response['data'][0]['embedding']
    end
end