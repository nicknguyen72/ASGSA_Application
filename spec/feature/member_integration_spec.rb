require 'rails_helper'

RSpec.feature "MemberFeatures", type: :feature do
  before do
    Rails.application.load_seed

    @member1 = create(:member, :admin)

    # Setup mock OmniAuth user
    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
      provider: 'google_oauth2',
      uid: '123456789',
      info: {
        email: @member1.email,
        first_name: @member1.first_name,
        last_name: @member1.last_name,
        image: @member1.avatar_url
      },
      credentials: {
        token: "token",
        refresh_token: "refresh token",
        expires_at: DateTime.now,
      }
    })

    # Route to trigger the OmniAuth callback directly for testing
    visit member_google_oauth2_omniauth_callback_path

  end

  scenario "List all members" do
    visit members_path

    expect(page).to have_content(@member1.first_name)
    expect(page).to have_content(@member1.last_name)
  end

  scenario "View a member's details" do
    visit member_path(@member1)

    expect(page).to have_content(@member1.first_name)
    expect(page).to have_content(@member1.last_name)
    expect(page).to have_content(@member1.email)
  end

  scenario "Update a member's information" do
    puts "Before update: MemberRoles and their Roles"
    MemberRole.joins(:role).select('member_roles.member_role_id, member_roles.member_id, roles.name as role_name').each do |mr|
      puts "MemberRole ID: #{mr.member_role_id}, Member ID: #{mr.member_id}, Role: #{mr.role_name}"
    end

    # Example query adjusting to use `member_id`
    Member.select(:member_id, :first_name, :last_name).each do |member|
      puts "Member ID: #{member.member_id}, Name: #{member.first_name} #{member.last_name}"
    end
    visit edit_member_path(@member1)

    fill_in "member[res_lab]", with: "Lab A"
    click_button "Update Profile"

    expect(page).to have_content("Member was successfully updated")
    expect(page).to have_content("Lab A")
  end

  scenario "Delete a member" do
    visit delete_confirmation_member_path(@member1)
    expect(page).to have_content(@member1.first_name)

    click_button "Delete this member"

    expect(page).to have_content("You need to sign in or sign up before continuing.")
    expect(page).not_to have_content(@member1.first_name)
  end
end
