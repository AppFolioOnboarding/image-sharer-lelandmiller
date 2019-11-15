require 'test_helper'

class ImagesControllerTest < ActionDispatch::IntegrationTest
  def test_create__returns_ok
    post api_feedbacks_url, params: { name: 'Great Name', comments: 'Great app!' }, as: :json
    assert_response :ok
  end
end
