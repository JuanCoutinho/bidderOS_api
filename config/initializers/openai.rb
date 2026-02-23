OpenAI.configure do |config|
  config.access_token = ENV.fetch("OPENAI_API_KEY", nil)
  config.request_timeout = 30
  config.log_errors = Rails.env.development?
end
