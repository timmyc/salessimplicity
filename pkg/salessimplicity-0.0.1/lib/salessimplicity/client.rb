require File.expand_path(File.join(File.dirname(__FILE__), 'lead_methods'))
module Salessimplicity
  class Client
    extend Salessimplicity::LeadMethods
    DEFAULT_ENDPOINT_URL = 'http://www.salessimplicity.net/ssnet2/svceleads/eleads.asmx?wsdl'
    attr_accessor :guid
    attr_reader :endpoint_url, :soap_driver

    def initialize(options={})
      raise(ArgumentError, 'guid required!') if !options[:guid]
      [:endpoint_url, :guid].each do |property|
        value = options[property].nil? ? options[property.to_s] : options[property]
        self.send("#{property}=", value)
      end
    end

    def endpoint_url=(new_endpoint_url)
      new_endpoint_url ||= DEFAULT_ENDPOINT_URL
      @endpoint_url = new_endpoint_url
      @soap_driver = Client.initialize_soap_driver(new_endpoint_url)   
      new_endpoint_url
    end

    ##
    # Submits a lead ot the Eleads system
    #
    # Accepts a hash of attributes for lead
    # +attributes[:email]+ is required
    # +attributes[:builder_name] is required too
    #

    def submit_lead(soap_driver,attributes={})
      [:email,:builder_name].each do |v|
        raise(ArgumentError, "attribute #{v.to_s} is required!") if !attributes[v]
      end
      contact = Client.prepare_contact(attributes)
      Client.submit_lead(soap_driver,@guid,contact)
    end

    protected
    def self.initialize_soap_driver(endpoint_url)
      EleadsSoap.new(endpoint_url)
    end
  end
end
