require 'test_helper'

class LandingControllerTest < ActionDispatch::IntegrationTest
  def test_home__root_url_is_successful
    get root_url
    assert_response :success
  end

  def test_home__root_url_shows_images
    saved_urls = %w[http://example.com/image1.png https://example.com/image2.gif]

    save_images_in_order saved_urls

    get root_url

    # The images should appear in the reverse order that they were added (newest appear first)
    assert_contains_image_urls_in_order saved_urls

    assert_response :success
  end

  private

  def save_images_in_order(urls)
    test_time = Time.parse('12/1/2009')
    urls.each_with_index { |url, i| Image.create!(url: url, created_at: test_time - i.hours) }
  end

  # Asserts that the set of images on the page contain (but are not limited to) the images with the provided
  # sources in the order given
  def assert_contains_image_urls_in_order(urls)
    assert_select 'img.js-image-stream' do |elems|
      img_urls = elems.map { |elem| elem.attributes['src'].value }
      assert_equal urls, img_urls
    end
  end
end
