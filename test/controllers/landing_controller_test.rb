require 'test_helper'

class LandingControllerTest < ActionDispatch::IntegrationTest
  def test_home__root_url_is_successful
    get root_url
    assert_response :success
  end
end
