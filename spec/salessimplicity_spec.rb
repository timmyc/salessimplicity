
require File.join(File.dirname(__FILE__), %w[spec_helper])

describe Salessimplicity::Client do
  describe "required options" do
    it "should require a guid to be passed in" do
      expect{ Salessimplicity::Client.new }.to raise_error(ArgumentError)
    end
  end

  describe "creation and configuration options" do
    before do
      @guid = 'foobar'
      @endpoint_url = "http://mylamesoapservice.local/service"
      @mock_soap_driver = mock(EleadsSoap)
      @client = Salessimplicity::Client.new(:guid => @guid, :endpoint_url => @endpoint_url)
    end

    it "should set the endpoint url on creation" do
      @client.endpoint_url.should == @endpoint_url
    end

    it "should set the guid on creation" do
      @client.guid.should == @guid
    end

    it "should use the default endpoint url" do
      @client = Salessimplicity::Client.new(:guid => @guid)
      @client.endpoint_url.should == Salessimplicity::Client::DEFAULT_ENDPOINT_URL
    end

    describe 'lead methods' do
      before do
        @email = 'foo@bar.com'
        @builder_name = 'HighGate'
        @address1 = '555 Some Road'
        @city = 'Our Town'
        @state = 'MO'
        @zip = 12345
        @phone = '555-2345'
        @valid_attributes = {
          :email => @email,
          :builder_name => @builder_name
        }
        @contact = { 'Contact' => { 'Email' => @email, 'BuilderName' => @builder_name, 'Demos' => nil }, 'sGUID' => @guid}
      end
      [:email,:builder_name].each do |v|
        it "should require #{v.to_s}" do
          bad_attributes = @valid_attributes
          bad_attributes.delete(v)
          expect{ @client.submit_lead(@mock_soap_driver,bad_attributes) }.to raise_error(ArgumentError)
        end
      end
      it "should build the contact hash properly" do
        @mock_soap_driver.should_receive(:submitLead).with(@contact).and_return(true)
        @client.submit_lead(@mock_soap_driver,@valid_attributes)
      end
      it "should support an address properly" do
        a = @valid_attributes.merge(:address1 => @address1, :city => @city, :state => @state, :zip => @zip, :phone => @phone)
        h = { 'Contact' => { 'Demos' => nil, 'Email' => @email, 'BuilderName' => @builder_name, 'Address1' => @address1, 'City' => @city, 'State' => @state, 'Zip' => @zip, 'Phone' => @phone }, 'sGUID' => @guid}
        @mock_soap_driver.should_receive(:submitLead).with(h).and_return(true)
        @client.submit_lead(@mock_soap_driver,a)
      end
      it "should ignore invalid attributes" do
        a = @valid_attributes.merge(:foo => false, :bar => 1)
        @mock_soap_driver.should_receive(:submitLead).with(@contact).and_return(true)
        @client.submit_lead(@mock_soap_driver,a)
      end
    end

  end
end

