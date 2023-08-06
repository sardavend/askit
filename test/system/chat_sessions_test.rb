require "application_system_test_case"

class ChatSEssionsTest < ApplicationSystemTestCase
  def setup
    @document = documents(:askit_demo_14041983)
  end
  test "Demo version" do
    visit demo_path
    assert_selector "h1#filename", text: 'picozine_1_1.pdf'
    assert_selector ".rpv-core__inner-page"
  end

  test "Chat sessions creation" do
    visit document_chat_sessions_path(@document)

    # Create new session
    open_new_chat_session_form
    fill_in "Title", with: "Pico editor"
    click_on "Save", match: :first
    assert_text "Pico editor"

    # Canceling creation
    #
    open_new_chat_session_form
    click_on "cancel"
    assert_no_selector "#chat_session_title"
  end

  test "Chat session edition" do
    visit document_chat_sessions_path(@document)
    click_link "Edit chat session icon"
    assert_field "Title", with: "Demo Session"
    assert_selector 'input[type="submit"][value="Save"]'
    assert_selector 'a', text: 'cancel'
    fill_in "Title", with: "Pico kinesis"
    click_on "Save"

    assert_no_selector 'input[type="submit"][value="Save"]'
    assert_no_selector 'a', text: 'cancel'

    assert_text "Pico kinesis"
  end

  test "Chat session deletion" do
    visit document_chat_sessions_path(@document)
    click_link "Remove chat session icon"

    assert_text "Are you sure? (all the questions on this sessions will be deleted)"
    click_on "Confirm"
    assert_no_text "Demo Session"
  end

  test "Chat session's show" do
    visit document_chat_sessions_path(@document)
    click_on "Demo Session"
    assert_text "Back to sessions"
  end

  private

  def open_new_chat_session_form
    click_on "New session", match: :first
    assert_selector "#chat_session_title"
  end
end
