if defined?(ActionMailer)
  require File.join(File.dirname(__FILE__), 'handlers', 'mandrill_delivery_handler')
end

module Mailchimp
  class Mandrill
    include HTTParty
    default_timeout 30

    attr_accessor :api_key, :timeout, :options

    def initialize(api_key = nil, extra_params = {})
      @api_key = api_key || ENV['MAILCHIMP_API_KEY'] || self.class.api_key
      @default_params = {
        :key => @api_key,
        :options => {
          :track_opens => true,
          :track_clicks => true
        }
      }.merge(extra_params)
    end

    def api_key=(value)
      @api_key = value
      @default_params = @default_params.merge({:key => @api_key})
    end

    def base_api_url
      "http://mandrillapp.com/api/1.0/"
    end

    def call(method, params = {})
      url = "#{base_api_url}#{method}"
      params = @default_params.merge(params)
      response = self.class.post(url, :body => params, :timeout => @timeout)

      begin
        response = JSON.parse(response.body)
      rescue
        response = response.body
      end
      response
    end

    def method_missing(method, *args)
      match = method.to_s.match(/([a-z]*)_([a-z]*)_?([a-z]*)/)
      method = "#{match[1]}/#{match[2]}#{match[3] == '' ? "" : "-"+match[3]}"
      args = {} unless args.length > 0
      args = args[0] if (args.class.to_s == "Array")
      call(method, args)
    end
    
    def valid_api_key?(*args)
      'PONG!' == self.users_ping
    end
    
    class << self
      attr_accessor :api_key
      
      def method_missing(sym, *args, &block)
        new(self.api_key).send(sym, *args, &block)
      end
    end
  end
end
