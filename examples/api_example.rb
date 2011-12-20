if ENV['MAILCHIMP_API_KEY'] == nil
  puts 'Set ENV["MAILCHIMP_API_KEY"] to use this example'
  exit
end

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'mailchimp' # Use the 'mailchimp' gem instead

# Set MAILCHIMP_API_KEY in your environment to use this.
api = Mailchimp::API.new(ENV['MAILCHIMP_API_KEY'])

puts "Your lists:"

api.lists['data'].each do |list|
  puts "\t #{list['name']}"
end