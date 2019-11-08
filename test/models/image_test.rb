require 'test_helper'

class ImageTest < ActiveSupport::TestCase
  VALID_HTTP_URL = 'http://example.com/cool.gif'.freeze

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

  def test_new__image_is_invalid_with_no_url
    refute Image.new.valid?
  end

  def test_new__image_is_invalid_with_empty_string
    refute Image.new(url: '').valid?
  end

  def test_new__image_accepts_tag_list
    image = Image.new(url: VALID_HTTP_URL, tag_list: 'one, two, three')
    assert image.valid?
    assert_equal %w[one two three], image.tag_list
  end

  private

  def valid_with_url(url)
    image = Image.new(url: url)
    assert image.valid?
  end

  def invalid_with_url(url)
    image = Image.new(url: url)
    refute image.valid?
  end
end
