# frozen_string_literal: true

require 'application_system_test_case'

class MembersTest < ApplicationSystemTestCase
  setup do
    @member = members(:one)
  end

  test 'visiting the index' do
    visit members_url
    assert_selector 'h1', text: 'Members'
  end

  test 'should create member' do
    visit members_url
    click_on 'New member'

    fill_in 'Email', with: @member.email
    fill_in 'First name', with: @member.first_name
    fill_in 'Last name', with: @member.last_name
    fill_in 'Points', with: @member.points
    fill_in 'Position', with: @member.position
    fill_in 'Role', with: @member.role
    click_on 'Create Member'

    assert_text 'Member was successfully created'
    click_on 'Back'
  end

  test 'should update Member' do
    visit member_url(@member)
    click_on 'Edit this member', match: :first

    fill_in 'Email', with: @member.email
    fill_in 'First name', with: @member.first_name
    fill_in 'Last name', with: @member.last_name
    fill_in 'Points', with: @member.points
    fill_in 'Position', with: @member.position
    fill_in 'Role', with: @member.role
    click_on 'Update Member'

    assert_text 'Member was successfully updated'
    click_on 'Back'
  end

  test 'should destroy Member' do
    visit member_url(@member)
    click_on 'Destroy this member', match: :first

    assert_text 'Member was successfully destroyed'
  end
end
