# frozen_string_literal: true

class AppointmentCompletionMailer < ApplicationMailer # rubocop:disable Style/Documentation
  def appointment_completion(appointment) # rubocop:disable Metrics/MethodLength
    @appointment = appointment
    @doctor_name = @appointment.doctor.name
    @patient = @appointment.patient
    @appointment_date = @appointment.appointment_date
    @patient_medicines = @patient.patient_medicines.map do |patient_medicine|
      {
        patient_name: patient_medicine.patient.name,
        medicine_name: patient_medicine.medicine.name,
        quantity_of_medicine: patient_medicine.quantity
      }
    end
    mail(to: 'c77023161@gmail.com', subject: 'Medicine Details')
  end

  def completed_appointments(appointments) # rubocop:disable Metrics/MethodLength
    @appointments = appointments
    @completed_appointments = @appointments.map do |appointment|
      {
        doctor_name: appointment.doctor.name,
        patient_name: appointment.patient.name,
        appointment_date: appointment.appointment_date,
        patient_medicines: appointment.patient.patient_medicines.map do |patient_medicine|
                             {
                               medicine_name: patient_medicine.medicine.name,
                               quantity_of_medicine: patient_medicine.quantity
                             }
                           end
      }
    end

    mail(to: 'c77023161@gmail.com', subject: 'Medicine Details')
  end
end
