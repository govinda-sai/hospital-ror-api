namespace :param_namespace do
  desc "TODO"
  task :param_task, [:name] => :environment do |task, args| 
    name = args[:name] 
    puts "hello #{name}"
  end

end