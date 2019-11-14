require 'test_helper'

class ImagesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @image = Image.new(url: 'http://image.com/image.gif')
  end

  def test_index__correct_images_shown_with_and_without_tag
    saved_images = [
      { url: 'http://example.com/image1.png', tag_list: %w[cat] },
      { url: 'https://example.com/image2.gif', tag_list: %w[cat dog] },
      { url: 'https://example.com/image3.jpeg', tag_list: %w[rat] },
      { url: 'https://example.com/image3.jpeg', tag_list: [] }
    ]

    cat_images = saved_images.filter { |image| image[:tag_list].include? 'cat' }

    save_images_in_order saved_images

    get root_url
    assert_response :success
    assert_contains_image_stream_in_order saved_images

    get images_url(tag: 'cat')
    assert_response :success
    assert_contains_image_stream_in_order cat_images
  end

  def test_show
    @image.save!
    get image_url(@image)

    assert_select 'img', 1 do |elems|
      assert_equal @image.url, elems.first.attributes['src'].value
    end

    assert_response :success
  end

  def test_show__image_does_not_exist_raises
    @image.save!
    @image.destroy!

    assert_raise(ActiveRecord::RecordNotFound) { get image_url(@image) }
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

  def test_delete
    @image.save

    assert_difference('Image.count', -1) do
      delete image_url(@image)
    end

    assert_redirected_to root_url
  end

  def test_delete__deleting_an_image_that_has_already_been_destroyed_raises
    @image.save!
    @image.destroy!

    assert_difference('Image.count', 0) do
      assert_raise(ActiveRecord::RecordNotFound) do
        delete image_url(@image)
      end
    end
  end

  private

  # @param [Array] image_descriptions An array of hashes containing attributes for image creation which will be
  #                                   augmented with a generated created_at.
  def save_images_in_order(image_descriptions)
    test_time = Time.parse('12/1/2009')
    image_descriptions.each_with_index { |desc, i| Image.create!(**desc, created_at: test_time - i.hours) }
  end

  # Asserts that the set of images on the page contain (but are not limited to) the images with the provided
  # sources in the order given
  def assert_contains_image_stream_in_order(expected_descriptions)
    actual_descriptions = css_select('li').map do |elem|
      url = elem.search('img').first.attributes['src'].value
      tag_list = elem.search('.js-tag').map(&:text)
      { url: url, tag_list: tag_list }
    end
    assert_equal expected_descriptions, actual_descriptions
  end

  def ensure_post_creates_image(params)
    assert_difference('Image.count') do
      post images_url, params: params
    end

    created_image = Image.last

    yield created_image

    assert_redirected_to image_url(created_image)
  end
end
