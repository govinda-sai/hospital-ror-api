require "test_helper"

class AppointmentCompletionMailerTest < ActionMailer::TestCase
  test "appointment_completion" do
    mail = AppointmentCompletionMailer.appointment_completion
    assert_equal "Appointment completion", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
