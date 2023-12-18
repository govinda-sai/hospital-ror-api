namespace :appointments do

  desc "get all appointments"
  task get_appointments: :environment do
    appointments = Appointment.all 
    appointments.each do |appointment| 
      puts "#{appointment.id} - #{appointment.doctor_name}"
    end
  end

  # desc "delete last 20 records" 
  # task delete_last_20: :environment do 
  #   for i in 1..20 
  #     last_appointment = Appointment.last 
  #     last_appointment.destroy 
  #   end
  # end

end
