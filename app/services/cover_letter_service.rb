class CoverLetterService
  MODEL = "gpt-3.5-turbo"

  def initialize(resume_text, job_description)
    @resume_text = resume_text
    @job_description = job_description
    @client = OpenAI::Client.new
  end

  def generate
    return nil if @resume_text.blank? || @job_description.blank?

    prompt = <<~PROMPT
      You are an expert career coach and cover letter writer.
      I will provide you with a candidate's resume and a job description.
      Your task is to write a highly persuasive, professional, and tailored cover letter
      that highlights the candidate's most relevant skills and experiences for this specific role.

      Tone: Professional, confident, and engaging.
      Format: Clean text, paragraph format. Do not include placeholder names or addresses at the top (like [Your Name]), jump straight into the greeting like "Dear Hiring Manager,".
      Language: Match the language of the job description. If the job description is in Portuguese, write in Portuguese.

      ### JOB DESCRIPTION:
      #{@job_description}

      ### CANDIDATE RESUME:
      #{@resume_text}
    PROMPT

    response = @client.chat(
      parameters: {
        model: MODEL,
        messages: [{ role: "user", content: prompt }],
        temperature: 0.7,
        max_tokens: 800
      }
    )

    letter = response.dig("choices", 0, "message", "content")
    raise "OpenAI returned no text" if letter.nil?

    letter
  rescue OpenAI::Error => e
    Rails.logger.error("[CoverLetterService] OpenAI error: #{e.message}")
    raise
  rescue => e
    Rails.logger.error("[CoverLetterService] Error: #{e.message}")
    raise
  end
end
