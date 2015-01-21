require 'puppetlabs_spec_helper/rake_tasks'
require 'puppet/vendor/semantic/lib/semantic'
require 'open4'

begin
  require 'puppet_blacksmith/rake_tasks'
rescue LoadError
end

begin
  require 'rubocop/rake_task'
  RuboCop::RakeTask.new
rescue LoadError
end

require 'puppet-lint/tasks/puppet-lint'

ignore_paths = ['contrib/**/*.pp', 'examples/**/*.pp', 'spec/**/*.pp', 'pkg/**/*.pp', 'vendor/**/*']

# necessary to ensure default :lint doesn't exist, else ignore_paths won't work
Rake::Task[:lint].clear

PuppetLint.configuration.relative = true
PuppetLint.configuration.disable_class_inherits_from_params_class
PuppetLint::RakeTask.new :lint do |config|
  config.ignore_paths = ignore_paths
end

PuppetSyntax.exclude_paths = ignore_paths

desc "Run acceptance tests"
task :acceptance do 
  status = Open4.popen4("docker run -v $(pwd):/test void-puppet") do |pid, stdin,stdout,stderr|
    stdin.close
    puts "stdout:"
    stdout.each_line { |line| puts line }
    puts "stderr: #{stderr.inspect}"
    stderr.each_line { |line| puts line }
  end
  abort if status != 0
end

desc "Run acceptance tests in container"
RSpec::Core::RakeTask.new(:dacceptance) do |t|
    t.pattern = 'spec/acceptance'
end

task :metadata do
  sh "bundle exec metadata-json-lint metadata.json"
end

desc "Run lint and spec tests and check metadata format"
task :test => [
  :syntax,
  :lint,
  :spec,
  :metadata,
]
