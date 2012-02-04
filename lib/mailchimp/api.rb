module Mailchimp
  class API < Base


    def initialize(api_key = nil, extra_params = {})
      @api_key = api_key || ENV['MAILCHIMP_API_KEY'] || self.class.api_key
      @default_params = {:apikey => @api_key}.merge(extra_params)
      @throws_exceptions = false
    end

    def api_key=(value)
      @api_key = value
      @default_params = @default_params.merge({:apikey => @api_key})
    end

    def base_api_url
      "https://#{dc_from_api_key}api.mailchimp.com/1.3/?method="
    end
    
    def call(method, params = {})
      super("#{base_api_url}#{method}",params.merge({:apikey => @api_key}))
    end

    def method_missing(method, *args)
      method = method.to_s.gsub(/\/(.?)/) { "::#{$1.upcase}" }.gsub(/(?:^|_)(.)/) { $1.upcase } #Thanks for the gsub, Rails
      method = method[0].chr.downcase + method[1..-1].gsub(/aim$/i, 'AIM')
      call(method, *args)
    end


    protected

    class << self
      attr_accessor :api_key

      def method_missing(sym, *args, &block)
        new(self.api_key).send(sym, *args, &block)
      end
    end

  end
end
