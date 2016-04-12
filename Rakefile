require 'html-proofer'
require 'rspec/core/rake_task'

desc 'Run specs'
RSpec::Core::RakeTask.new do |t|
  t.pattern = 'spec/**/*_spec.rb'
  t.rspec_opts = ['--order', 'rand', '--color']
end

task :test do
  sh 'bundle exec jekyll build'
  Rake::Task['spec'].invoke
  HTMLProofer.check_directory('./_site',
                              check_html: true,
                              validation: { ignore_script_embeds: true },
                              url_swap: { %r{http://chooseaproduct.com} => '' }).run
end

task :approved_products do
  require './spec/spec_helper'
  approved = approved_products
  approved.select! { |l| spdx_ids.include?(l) }
  puts "#{approved.count} approved products:"
  puts approved.join(', ')
  puts "\n"

  potential = approved - products.map { |l| l['id'] }
  puts "#{potential.count} potential additions:"
  puts potential.join(', ')
end
