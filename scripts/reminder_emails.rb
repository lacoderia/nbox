#!/usr/bin/env ruby
require_relative "../config/environment"

logger = Logger.new('/home/deploy/nbox-backend/log/reminder_emails.log', 5, 1024000)

begin
  User.send_classes_left_reminder
  User.send_expiration_reminder
  logger.info("Successfully completed")
rescue Exception => e
  logger.error("Errored #{e.message}")
end
