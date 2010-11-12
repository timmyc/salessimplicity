require 'soap/rpc/driver'

  class EleadsSoap < ::SOAP::RPC::Driver
    DefaultEndpointUrl = "http://www.salessimplicity.net/ssnet2/svceleads/eleads.asmx"
    MappingRegistry = ::SOAP::Mapping::Registry.new

    Methods = [
      [ "http://SalesSimplicity.net/GetDemos",
        "getDemos",
        [ ["in", "parameters", ["::SOAP::SOAPElement", "http://SalesSimplicity.net", "GetDemos"], true],
          ["out", "parameters", ["::SOAP::SOAPElement", "http://SalesSimplicity.net", "GetDemosResponse"], true] ],
        { :request_style =>  :document, :request_use =>  :literal,
          :response_style => :document, :response_use => :literal }
      ],
      [ "http://SalesSimplicity.net/GetDemosXML",
        "getDemosXML",
        [ ["in", "parameters", ["::SOAP::SOAPElement", "http://SalesSimplicity.net", "GetDemosXML"], true],
          ["out", "parameters", ["::SOAP::SOAPElement", "http://SalesSimplicity.net", "GetDemosXMLResponse"], true] ],
        { :request_style =>  :document, :request_use =>  :literal,
          :response_style => :document, :response_use => :literal }
      ],
      [ "http://SalesSimplicity.net/SubmitLead",
        "submitLead",
        [ ["in", "parameters", ["::SOAP::SOAPElement", "http://SalesSimplicity.net", "SubmitLead"], true],
          ["out", "parameters", ["::SOAP::SOAPElement", "http://SalesSimplicity.net", "SubmitLeadResponse"], true] ],
        { :request_style =>  :document, :request_use =>  :literal,
          :response_style => :document, :response_use => :literal }
      ],
      [ "http://SalesSimplicity.net/GetSpecLotInfoStyle1",
        "getSpecLotInfoStyle1",
        [ ["in", "parameters", ["::SOAP::SOAPElement", "http://SalesSimplicity.net", "GetSpecLotInfoStyle1"], true],
          ["out", "parameters", ["::SOAP::SOAPElement", "http://SalesSimplicity.net", "GetSpecLotInfoStyle1Response"], true] ],
        { :request_style =>  :document, :request_use =>  :literal,
          :response_style => :document, :response_use => :literal }
      ],
      [ "http://SalesSimplicity.net/GetSubdivInfoStyle1",
        "getSubdivInfoStyle1",
        [ ["in", "parameters", ["::SOAP::SOAPElement", "http://SalesSimplicity.net", "GetSubdivInfoStyle1"], true],
          ["out", "parameters", ["::SOAP::SOAPElement", "http://SalesSimplicity.net", "GetSubdivInfoStyle1Response"], true] ],
        { :request_style =>  :document, :request_use =>  :literal,
          :response_style => :document, :response_use => :literal }
      ],
      [ "http://SalesSimplicity.net/GetPlanInfoStyle1",
        "getPlanInfoStyle1",
        [ ["in", "parameters", ["::SOAP::SOAPElement", "http://SalesSimplicity.net", "GetPlanInfoStyle1"], true],
          ["out", "parameters", ["::SOAP::SOAPElement", "http://SalesSimplicity.net", "GetPlanInfoStyle1Response"], true] ],
        { :request_style =>  :document, :request_use =>  :literal,
          :response_style => :document, :response_use => :literal }
      ]
    ]

    def initialize(endpoint_url = nil)
      endpoint_url ||= DefaultEndpointUrl
      super(endpoint_url, nil)
      self.mapping_registry = MappingRegistry
      init_methods
    end

  private

    def init_methods
      Methods.each do |definitions|
        opt = definitions.last
        if opt[:request_style] == :document
          add_document_operation(*definitions)
        else
          add_rpc_operation(*definitions)
          qname = definitions[0]
          name = definitions[2]
          if qname.name != name and qname.name.capitalize == name.capitalize
            ::SOAP::Mapping.define_singleton_method(self, qname.name) do |*arg|
              __send__(name, *arg)
            end
          end
        end
      end
    end
  end
