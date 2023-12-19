# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base # rubocop:disable Style/Documentation
  default from: 'govindasai@example.com'
  layout 'mailer'
end
