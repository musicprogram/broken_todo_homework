namespace :projects do
  task(:all).clear
  task :all => :environment do
    Project.all.each do |project|
      puts project.title
      project.items.all.each do |item|
        puts item.discarded? ? "X #{item.action}" : "- #{item.action}"
      end
    end
  end
end