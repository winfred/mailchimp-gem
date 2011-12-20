if ENV['MAILCHIMP_MANDRILL_API_KEY'] == nil
  puts 'Set ENV["MAILCHIMP_MANDRILL_API_KEY"] to use this example'
  exit
end

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'mailchimp' # Use the 'mailchimp' gem instead

# Set MAILCHIMP_MANDRILL_API_KEY in your environment to use this.
mandrill = Mailchimp::Mandrill.new(ENV['MAILCHIMP_MANDRILL_API_KEY'])

puts "Your username is #{mandrill.users_info['username']}. lets email that person as that person to that person!"

response = mandrill.messages_send(
  message: {
    html: "<html><body><h1>Test</h1></body></html>",
    text: "Test",
    subject: "Test Message From Mandrill",
    from_email: mandrill.users_info['username'],
    from_name: 'Mandrill User',
    to: [mandrill.users_info['username']]
  }
)

puts "valid senders:"

mandrill.users_senders.map { |sender| puts "\t#{sender['address']}" }

puts "sending a validation request for your user..."

mandrill.users_verify_sender(email: mandrill.users_info['username'])

puts "Sent! Status: #{response['status']}"

