module Salessimplicity
  module LeadMethods
    def submit_lead(soap_driver, guid, contact)
      soap_driver.submitLead({ 'Contact' => contact, 'sGUID' => guid })
      return true
    end

    def prepare_contact(lead)
      r = {}
      valid_attr = [:first_name,:last_name,:address1,:address2,:city,:state,:zip,:phone,:email,:note,:country,:model_type,:floor_plan,:home_use,:price_range,:community,:community_number,:master_community,:builder_name,:spec_number,:spec_address,:demos]
      valid_attr.each do |a|
        next unless a == :demos || lead[a]
        r[camelize(a)] = lead[a] ? lead[a] : nil
      end
      return r
    end

    def camelize(sym)
      sym.to_s.downcase.gsub(/_/,' ').gsub(/\b[a-z]/) { |a| a.upcase }.gsub(/\s/,'') 
    end
  end
end
