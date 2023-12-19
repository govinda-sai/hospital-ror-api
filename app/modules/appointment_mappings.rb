# frozen_string_literal: true

module AppointmentMappings  # rubocop:disable Style/Documentation
  def appointment_mapping(appointments)
    appointments.map do |appointment|
      {
        appointment_id: appointment.id, doctor_name: appointment.doctor.name.upcase,
        patient_name: appointment.patient.name.upcase, appointment_time: appointment.appointment_date
      }
    end
  end
end
