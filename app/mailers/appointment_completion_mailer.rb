class AppointmentCompletionMailer < ApplicationMailer

  def appointment_completion(appointment)
    @appointment = appointment
    @doctor_name = @appointment.doctor.name
    @patient = @appointment.patient 
    @appointment_date = @appointment.appointment_date
    @patient_medicines = @patient.patient_medicines.map { |patient_medicine| {
      patient_name: patient_medicine.patient.name,
      medicine_name: patient_medicine.medicine.name,
      quantity_of_medicine: patient_medicine.quantity
    }}
    mail(to: "c77023161@gmail.com", subject: "Medicine Details")
  end

  def completed_appointments(appointments) 
    @appointments = appointments
    @completed_appointments = @appointments.map { |appointment| { 
      doctor_name: appointment.doctor.name, 
      patient_name: appointment.patient.name,
      appointment_date: appointment.appointment_date,
      patient_medicines: appointment.patient.patient_medicines.map { |patient_medicine| {
        # patient_name: patient_medicine.patient.name,
        medicine_name: patient_medicine.medicine.name,
        quantity_of_medicine: patient_medicine.quantity
      }}  
    }} 

    mail(to: "c77023161@gmail.com", subject: "Medicine Details")
  end
end