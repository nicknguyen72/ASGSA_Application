require 'rails_helper'

RSpec.describe "member_notifications/edit", type: :view do
  let(:valid_event) { Event.create!(
    name: "Test Event",
    location: "College Station",
    start_time: Time.now,
    end_time: Time.current + 2.hour,
    date: Date.today,
    description: "This is a description for test event",
    capacity: 20,
    points: 3
  ) }
  let(:valid_notification){ Notification.create!(
      title: "Test notification",
      description: "A test description",
      date: Date.today,
      event_id: valid_event.id
    )
  }
  let(:valid_member) {Member.create!(
      first_name: "John",
      last_name: "Doe",
      email: "john.doe@tamu.edu",
      points: 100,
      position: "Member",
      date_joined: Date.today,
      degree: "Bachelor",
      res_topic: "Topic",
      res_lab: "Lab",
      res_pioneer: "Pioneer",
      res_description: "Description",
      area_of_study: "Study Area",
      food_allergies: "None"
    )
  }
  let(:member_notification) {
    MemberNotification.create!(
      member_id: valid_member.id,
      notification_id: valid_notification.id,
      seen: false
    )
  }

  before(:each) do
    assign(:member_notification, member_notification)
  end

  it "renders the edit member_notification form" do
    render

    assert_select "form[action=?][method=?]", member_notification_path(member_notification), "post" do

      assert_select "input[name=?]", "member_notification[seen]"
    end
  end
end
