# Simplistic rakefile which simply sets environment variables to switch the
# chosen database before running scripts.

task :default => [:run]

task :run do
  ENV['RACK_ENV'] = "dev"
  system "shotgun -Iapp app/knowledge_base.rb"
end

task :test do
  ENV["RACK_ENV"] = "test"
  system "ruby -Iapp test/knowledge_base_test.rb"
end
