class SendReminderJob < ActiveJob::Base
  queue_as :reminders

  def perform(email_name, user, data)
    begin
      mail = NboxMailer.send(email_name.to_sym, user, data)
      mail.deliver_later
      Email.create(user: user, email_status: "sent", email_type: email_name.to_s)
    rescue Exception => e
      Email.create(user: user, email_status: e.message, email_type: email_name.to_s)
    end
  end
end
