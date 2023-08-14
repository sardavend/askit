require "test_helper"

class ChatSessionsControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get document_chat_session_url(documents(:one), chat_sessions(:one))
    assert_response :success
  end

  test "should get index" do
    get document_chat_sessions_url(documents(:one))
    assert_response :success
  end
end
