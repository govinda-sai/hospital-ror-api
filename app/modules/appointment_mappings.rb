module AppointmentMappings 
  def appointment_mapping(appointments) 
    appointments.map { |appointment| {
        appointment_id: appointment.id, doctor_name: appointment.doctor.name.upcase(), 
        patient_name: appointment.patient.name.upcase(), appointment_time: appointment.appointment_date
    }}
  end
end