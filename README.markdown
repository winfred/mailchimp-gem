# mailchimp

Mailchimp is a simple API wrapper all public Mailchimp APIs.

Initially, this pulls in https://github.com/amro/uakari/ and https://github.com/amro/gibbon/.

Initially, this doesn't work that well yet!

##Installation

        $ gem install mailchimp

##Requirements

A paid MailChimp account, MailChimp API key, and any extra setup for services that you want to use.

##Usage

        api      = Mailchimp::API.new("your_api_key")
        sts      = Mailchimp::STS.new("your_api_key")
        mandrill = Mailchimp::Mandrill.new("your_api_key")
        
## Examples

Take a look in the examples/ folder for examples using each of the APIs. The only actions these perform 
are either read only or only send emails to you or the address you specify, so it's ok to use your real 
Mailchimp API keys for them. run them like:

        ruby examples/api_example.rb
        ruby examples/sts_example.rb
        ruby examples/mandrill_example.rb

##Development

        $ rake test