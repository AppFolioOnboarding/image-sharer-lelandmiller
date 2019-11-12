module PageObjects
  module Images
    class IndexPage < PageObjects::Document
      path :root

      collection :images, locator: 'ul', item_locator: 'li', contains: ImageCard do
        def view!
          # TODO
        end
      end

      def add_new_image!
        node.click_on('Add Cool Image')
        window.change_to(NewPage)
      end

      def showing_image?(url:, tags: nil)
        images.any? do |image|
          tags_match = tags ? image.tags == tags : true
          image.url == url && tags_match
        end
      end

      def clear_tag_filter!
        node.click_on('Home')
        window.change_to(IndexPage)
      end
    end
  end
end
