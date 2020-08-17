require "visualize_ruby"
require 'date'

source = File.read('/Users/devtemp/workspace/kmsat/app/workers/crons/phishing/run_upcoming_campaigns_worker.rb')
file_name = "ast_graph_vruby_#{DateTime.now.strftime('%Y_%m_%d_%H_%M_%S')}.png"

calling_code = <<~RUBY
  Crons::Phishing::RunUpcomingCampaignsWorker.new.perform
RUBY

VisualizeRuby.new do |vb|
  vb.ruby_code = source # String, File, Pathname
  vb.trace(calling_code)  # String, File, Pathname, Proc - optional
  vb.output_path = file_name # file name with media extension.
end
