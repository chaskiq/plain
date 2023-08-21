require "test_helper"

class UsersTest < ActionDispatch::SystemTestCase
  driven_by :selenium, using: :headless_chrome

  test "visiting docs" do
    visit "/plain/docs"
    click_link('intro')
    assert page.has_content?("This is a test page")
  end

  #test "opening chat" do
  #  visit "/plain/docs"
  #  click_link('chat')
  #  assert page.has_content?("Continue conversations")
  #end


end