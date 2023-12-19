# frozen_string_literal: true

module DoctorAvailabilities # rubocop:disable Style/Documentation
  def get_appointment_time(doctor, errors = [])  # rubocop:disable Metrics/MethodLength
    if doctor
      start_time = DateTime.parse(params[:start_time]).beginning_of_day
      end_time = DateTime.parse(params[:end_time]).end_of_day

      if start_time && end_time
        appointments = doctor.appointments.where(appointment_date: start_time..end_time)
        [appointments, errors]
      else
        errors << 'Invalid date'
        [nil, errors]
      end
    else
      [nil, ['Doctor not found']]
    end
  end
end
