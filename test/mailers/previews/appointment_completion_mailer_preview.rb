# Preview all emails at http://localhost:3000/rails/mailers/appointment_completion_mailer
class AppointmentCompletionMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/appointment_completion_mailer/appointment_completion
  def appointment_completion
    AppointmentCompletionMailer.appointment_completion
  end

end
