class AppointmentMailer < ApplicationMailer
    def patient_mail(appointment)
        @appointment = appointment
        @patient = appointment.patient 
        mail(to: "c77023161@gmail.com", subject: "Appointment Confirmation")
    end

    def update_appointment(appointment) 
        @appointment = appointment 
        attachments['cheers.webp'] = File.read("/home/govindasai/Downloads/memer.webp")
        mail(to: "lohit9390@gmail.com", subject: "Appointment date updated")
    end
end