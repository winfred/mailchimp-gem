module Mailchimp
  def self.valid_api_key?(api_key)
    Base.new(api_key).valid_api_key?
  end

  #Mailchimp::Base encapsulates the commonalities between the APIs 
  #   as well as the useage options for this wrapper and valid_api_key util
  #
  # Global Settings
  #   Name                     | Default   
  #   --------------------------------------
  #   @api_key                 | ""
  #   @timeout                 | 30 (seconds)
  #   TODO: @throws_exceptions | false
  #   TODO: @user_agent        | ""
  #
  #Subclass Contract:
  #  "Take what is useful, override what isnt"
  #  
  #  You can use whatever process you like to build request URL and params for your API
  #  then pass the URL and params to Base#call through <Sublcass>#call: 
  #  to get a standard JSON/psuedoJSON response as expected by that API's docs
  #
  #  Unless of course you (like the Export API) have unique request or response
  #  requirements. In which case, override whatever you need to.
  #  

  class Base
    include HTTParty
    default_timeout 30
    format :json
    parser MailchimpPsuedoJSONParser
    attr_accessor :api_key, :timeout, :throws_exceptions, :user_agent

    def initialize(api_key = nil, default_parameters = {})
      @api_key = api_key || ENV['MAILCHIMP_API_KEY'] || nil
      @timeout = default_parameters.delete(:timeout) 
      @default_params = default_parameters
    end

    def dc_from_api_key
      (@api_key.nil? || @api_key.length == 0 || @api_key !~ /-/) ? '' : "#{@api_key.split("-").last}."
    end
    
    def valid_api_key?
      %q{"Everything's Chimpy!"} == self.class.post(_base_api_url+"ping", :body => {apikey: @api_key}, :timeout => 30).body
    end
    
    protected
    
      def call(url, params = {})
        params = @default_params.merge(params)
        timeout = params.delete(:timeout) || @timeout
        response = self.class.post(url, :body => params, :timeout => timeout)
        begin; response = JSON.parse(response.body); rescue; response = response.body ;end
        if @throws_exceptions && response.is_a?(Hash) && response["error"]
          raise "Error from MailChimp API: #{response["error"]} (code #{response["code"]})"
        end
        response
      end
      
    private
    
      def _base_api_url
        "https://#{dc_from_api_key}api.mailchimp.com/1.3/?method="
      end
  end
end

  
