require "test_helper"

class ArchitectsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get architects_index_url
    assert_response :success
  end
end
