require "bundler/gem_tasks"
require "rspec/core/rake_task"

task default: "test:unit"

namespace :test do
  RSpec::Core::RakeTask.new(:unit)
end
