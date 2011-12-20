if ENV['MAILCHIMP_API_KEY'] == nil
  puts 'Set ENV["MAILCHIMP_API_KEY"] to use this example'
  exit
end

if ENV['TEST_EMAIL_ADDRESS'] == nil
  puts 'Set ENV["TEST_EMAIL_ADDRESS"] to use this example'
  exit
end


$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'mailchimp' # Use the 'mailchimp' gem instead

# Set MAILCHIMP_API_KEY in your environment to use this. set TEST_EMAIL_ADDRESS to use this.
sts = Mailchimp::STS.new(ENV['MAILCHIMP_API_KEY'])

puts "valid senders:"

puts sts.list_verified_email_addresses['email_addresses'].map { |address| puts "\t#{address}" }

puts "sending a validation request for your user..."

sts.verify_email_address(email: ENV['TEST_EMAIL_ADDRESS'])
