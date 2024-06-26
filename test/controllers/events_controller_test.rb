# frozen_string_literal: true

require 'test_helper'

class EventsControllerTest < ActionDispatch::IntegrationTest
  test 'should get index' do
    get events_index_url
    assert_response :success
  end

  test 'should get new' do
    get events_new_url
    assert_response :success
  end

  test 'should get edit' do
    get events_edit_url
    assert_response :success
  end
end
