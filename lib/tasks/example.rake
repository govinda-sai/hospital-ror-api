namespace :example do
  desc "this is description"
  task say_hello: :environment do
    puts "inside task at #{Time.now}"
  end
end