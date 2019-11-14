require 'test_helper'

# rubocop:disable Metrics/ClassLength
class ImagesControllerTest < ActionDispatch::IntegrationTest
  VALID_URL = 'http://example.com/image.gif'.freeze

  setup do
    @image = Image.new(url: 'http://image.com/image.gif', tag_list: 'example_tag')
  end

  def test_index__correct_images_shown_on_index_and_when_filtered_by_tag
    saved_images = [
      { url: 'http://example.com/image1.png', tag_list: %w[cat] },
      { url: 'https://example.com/image2.gif', tag_list: %w[cat dog] },
      { url: 'https://example.com/image3.jpeg', tag_list: %w[rat] },
      { url: 'https://example.com/image3.jpeg', tag_list: %w[dog] }
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

  def test_edit
    @image.save
    get edit_image_url(@image)
    assert_response :success
  end

  def test_edit__starts_with_valid_tag_list
    original_image = Image.create url: VALID_URL, tag_list: 'cat, dog'
    get edit_image_url(original_image)
    assert_response :success

    matching_input_tags = css_select('input#image_tag_list')
    assert_equal 1, matching_input_tags.size
    displayed_tag_list = matching_input_tags.first.attributes['value'].value

    new_image = Image.new url: VALID_URL, tag_list: displayed_tag_list

    assert_equal original_image.tag_list, new_image.tag_list
  end

  def test_edit__image_does_not_exist_raises
    @image.save!
    @image.destroy!

    assert_raise(ActiveRecord::RecordNotFound) { get edit_image_url(@image) }
  end

  def test_create__with_tag_list
    ensure_post_creates_image(image: { url: @image.url, tag_list: 'nice, red, absolute zero' }) do |image|
      assert_equal @image.url, image.url
      assert_equal ['nice', 'red', 'absolute zero'], image.tag_list
    end
  end

  def test_update__with_tag_list
    image = Image.create!(url: VALID_URL, tag_list: 'cool, good')

    assert_no_difference('Image.count') do
      patch image_url(image), params: { image: { tag_list: 'dog, cat' } }
    end

    assert_redirected_to image_url(image)

    image.reload

    assert_equal VALID_URL, image.url
    assert_equal %w[dog cat], image.tag_list
  end

  def test_update__on_destroyed_object
    image = Image.create!(url: VALID_URL, tag_list: 'cool, good')
    image.destroy!

    assert_no_difference('Image.count') do
      assert_raise ActiveRecord::RecordNotFound do
        patch image_url(image), params: { image: { tag_list: 'dog, cat' } }
      end
    end
  end

  def test_update__with_empty_tag_list
    image = Image.create!(url: VALID_URL, tag_list: 'cool, good')

    assert_no_difference('Image.count') do
      patch image_url(image), params: { image: { tag_list: '' } }
    end

    assert_response :unprocessable_entity
    assert_select 'span.error', "can't be blank"

    image.reload

    assert_equal VALID_URL, image.url
    assert_equal %w[cool good], image.tag_list
  end

  def test_update__ignores_url_update
    image = Image.create!(url: 'http://example.com/image.gif', tag_list: 'cool, good')

    assert_no_difference('Image.count') do
      patch image_url(image), params: { image: { url: 'http://example.com/new.png', tag_list: 'dog, cat' } }
    end

    assert_redirected_to image_url(image)

    image.reload

    assert_equal VALID_URL, image.url
    assert_equal %w[dog cat], image.tag_list
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
# rubocop:enable Metrics/ClassLength
