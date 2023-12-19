# frozen_string_literal: true

namespace :param_namespace do
  desc 'TODO'
  task :param_task, [:name] => :environment do |_task, args|
    name = args[:name]
    puts "hello #{name}"
  end
end
