require 'test_helper'

class Api::PhoneCallsControllerTest < ActionController::TestCase
  test "response is Not Acceptable when missing phone number" do
    get :call
    assert_response 406
  end

  test "should respond a proper code" do
    get :call, { phone_number: '1'}
    assert [200, 300, 400, 500, 501].include? @response.code.to_i
  end

end
