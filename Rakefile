# Rakefile

require 'rake/testtask'

Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.libs << 'test'
  t.test_files = FileList['test/**/*_test.rb']
  t.warning = true
end

task default: :test

desc "Regenerate lib/Bitget/ERROR_CODES.rb from the lists Bitget publishes"
task :error_codes do
  ruby 'bin/generate_error_codes'
end
