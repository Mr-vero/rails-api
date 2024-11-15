namespace :db do
    desc "Reset database and load seed data"
    task reset_with_seeds: :environment do
      return unless Rails.env.development? || Rails.env.test?

      puts "Dropping database..."
      Rake::Task["db:drop"].execute

      puts "Creating database..."
      Rake::Task["db:create"].execute

      puts "Running migrations..."
      Rake::Task["db:migrate"].execute

      puts "Loading seed data..."
      Rake::Task["db:seed"].execute

      puts "Done!"
    end
  end
