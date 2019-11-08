require 'test_helper'

class ImagesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @image = Image.new(url: 'http://image.com/image.gif')
  end

  def test_new
    get new_image_url
    assert_response :success
  end

  def test_create__without_tag_list
    ensure_post_creates_image(image: { url: @image.url }) do |image|
      assert_equal @image.url, image.url
    end
  end

  def test_create__with_tag_list
    ensure_post_creates_image(image: { url: @image.url, tag_list: 'nice, red, absolute zero' }) do |image|
      assert_equal @image.url, image.url
      assert_equal ['nice', 'red', 'absolute zero'], image.tag_list
    end
  end

  def test_show
    @image.save!
    get image_url(@image)

    assert_select 'img', 1 do |elems|
      assert_equal @image.url, elems.first.attributes['src'].value
    end

    assert_response :success
  end

  private

  def ensure_post_creates_image(params)
    assert_difference('Image.count') do
      post images_url, params: params
    end

    created_image = Image.last

    yield created_image

    assert_redirected_to image_url(created_image)
  end
end
