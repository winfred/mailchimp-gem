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

##Development

  $ rake test