require 'test_helper'

class ImagesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @image = Image.new(url: 'http://image.com/image.gif')
  end

  def test_new
    get new_image_url
    assert_response :success
  end

  def test_create
    assert_difference('Image.count') do
      post images_url, params: { image: { url: @image.url } }
    end

    assert_equal @image.url, Image.last.url

    assert_redirected_to image_url(Image.last)
  end

  def test_show
    @image.save!
    get image_url(@image)

    assert_select 'img', 1 do |elems|
      assert_equal @image.url, elems.first.attributes['src'].value
    end

    assert_response :success
  end
end
