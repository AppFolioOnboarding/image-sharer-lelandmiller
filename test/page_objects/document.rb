module PageObjects
  class Document < AePageObjects::Document
    def flash_message
      node.find('#notice').text
    end
  end
end
