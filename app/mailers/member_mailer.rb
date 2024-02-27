class MemberMailer < ApplicationMailer
    def new_member_email
        @member = params[:member]
        mail(to: @member.email, subject: 'Welcome to ASGSA!')
    end

    def support_email(name, email, issue)
        @name = name
        @email = email
        @issue = issue
    
        mail(to: 'asgsatamu1@gmail.com', subject: 'New Support Request')
    end

    def event_email(event)
        @event = event

        
        @calendar_link = AddToCalendar::URLs.new(
            start_datetime: Time.new(@event.date.year, @event.date.month, @event.date.day, @event.start_time.hour, @event.start_time.min, @event.start_time.sec),
            end_datetime: Time.new(@event.date.year, @event.date.month, @event.date.day, @event.end_time.hour, @event.end_time.min, @event.end_time.sec),
            title: @event.name,
            location: @event.location,
            description: @event.description,
            timezone: 'America/Chicago'
        )

        mail(to: Member.pluck(:email), subject: 'ASGSA: New Upcoming Event!')
    end

end
