require "test_helper"

class InquiresControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get inquires_create_url
    assert_response :success
  end

  test "should get index" do
    get inquires_index_url
    assert_response :success
  end
end
