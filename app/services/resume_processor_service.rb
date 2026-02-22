class ResumeProcessorService
    def initialize(user, file_path)
        @user = user
        @file_path = file_path
    end

    def call
        text = extract_text_from_file

        @user.resumes.create!(
            filename: File.basename(@file_path),
            content_text: text,
            embedding: nil
        )
    end

    private

    def extract_text_from_file
        reader = PDF::Reader.new(@file_path)
        reader.pages.map(&:text).join("\n")
    rescue => e
        Rails.logger.error("Error extracting text: #{e.message}")
        ""
    end
end