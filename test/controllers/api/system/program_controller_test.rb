require 'test_helper'

class Api::System::ProgramControllerTest < ActionController::TestCase

  test "should get info about two programs" do
    json = (get "listPrograms").parsed_body.deep_symbolize_keys

    assert_equal 2, json[:data].count
    assert_equal "appOne", json[:data][0][:name]
    assert_equal "appTwo", json[:data][1][:name]
  end

  test "should get info about appOne" do
    json = (get "getProgramInfo", params: {id: 1}).parsed_body.deep_symbolize_keys
    assert_equal "appOne", json[:data][:name]
  end

  test "should get info about appTwo" do
    json = (get "getProgramInfo", params: {id: 2}).parsed_body.deep_symbolize_keys
    assert_equal "appTwo", json[:data][:name]
  end
end
