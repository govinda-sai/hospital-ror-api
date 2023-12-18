module DoctorAvailabilities

    def get_appointment_time(doctor, errors = []) 
        if doctor
            start_time = DateTime.parse(params[:start_time]).beginning_of_day 
            end_time = DateTime.parse(params[:end_time]).end_of_day

            if start_time && end_time 
                appointments = doctor.appointments.where(appointment_date: start_time..end_time)
                return [appointments, errors]
            else 
                errors << 'Invalid date'
                return [nil, errors]
            end
        else           
           return [nil, ['Doctor not found']]
        end
    end

end 