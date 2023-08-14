require "test_helper"

class InquiresControllerTest < ActionDispatch::IntegrationTest
  test "should create a new question" do
    params = { inquire: {question: 'What is your age?'}}
    post document_chat_session_inquires_url(documents(:one), chat_sessions(:one)), params: params, as: :turbo_stream
    assert_response :success
  end

  test "should get index" do
    get document_chat_session_inquires_url(documents(:one), chat_sessions(:one))
    assert_response :success
  end
end
