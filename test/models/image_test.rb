require 'test_helper'

class ImageTest < ActiveSupport::TestCase
  VALID_HTTP_URL = 'http://example.com/cool.gif'.freeze
  VALID_TAG_LIST = 'cat, dog'.freeze

  BLANK_MESSAGE = "can't be blank".freeze
  INVALID_MESSAGE = 'is invalid'.freeze

  def test_new__image_is_invalid_with_no_attributes
    image = Image.new
    refute image.valid?
    assert_equal [BLANK_MESSAGE, INVALID_MESSAGE], image.errors[:url]
    assert_equal [BLANK_MESSAGE], image.errors[:tag_list]
  end

  def test_new__image_is_valid_with_http_url
    valid_with_url(VALID_HTTP_URL)
  end

  def test_new__image_is_valid_with_https_url
    valid_with_url('https://example.com/cool.gif')
  end

  def test_new__image_is_invalid_with_javascript_url
    invalid_with_url("javascript:alert('hello')")
  end

  def test_new__image_is_invalid_with_ftp_url
    invalid_with_url('ftp://example.com/cool.gif')
  end

  def test_new__image_is_invalid_with_empty_url_string
    image = Image.new(url: '', tag_list: VALID_TAG_LIST)
    refute image.valid?
    assert_equal [BLANK_MESSAGE, INVALID_MESSAGE], image.errors[:url]
  end

  def test_new__image_accepts_tag_list
    image = Image.new(url: VALID_HTTP_URL, tag_list: 'one, two, three')
    assert image.valid?
    assert_equal %w[one two three], image.tag_list
  end

  def test_new__tag_list_must_not_be_nil
    assert_blank_error_with_tag_list nil
  end

  def test_new__tag_list_must_not_be_empty_string
    assert_blank_error_with_tag_list ''
  end

  def test_new__tag_list_must_not_be_empty_array
    assert_blank_error_with_tag_list []
  end

  private

  def valid_with_url(url)
    image = Image.new(url: url, tag_list: VALID_TAG_LIST)
    assert image.valid?
  end

  def assert_blank_error_with_tag_list(tag_list)
    image = Image.new(url: VALID_HTTP_URL, tag_list: tag_list)
    refute image.valid?
    assert_equal [BLANK_MESSAGE], image.errors[:tag_list]
  end

  def invalid_with_url(url)
    image = Image.new(url: url, tag_list: VALID_TAG_LIST)
    refute image.valid?
    assert_equal [INVALID_MESSAGE], image.errors.messages[:url]
  end
end
