namespace :assets do
  desc "Bypass asset precompilation on Railway for API-only apps"
  task precompile: :environment do
    puts "Skipping asset precompilation..."
  end
end
