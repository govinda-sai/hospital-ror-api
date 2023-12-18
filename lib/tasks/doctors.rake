namespace :doctors do
  desc "get all doctors list"
  task get_doctors: :environment do
    doctors = Doctor.all

    doctors.each do |doctor| 
      puts "#{doctor.name} - #{doctor.specialization}"
    end
  end

  desc "add doctor" 
  task add_doctor: :environment do 
    doctor = Doctor.new(name: "kendrick lamar", 
                        email: "kendrick@gmail.com", 
                        specialization: "orthopedic") 
    if doctor.save
      puts "doctor has been saved" 
    else 
      puts "failed to create doctor"
    end
  end

  desc "delete doctor" 
  task delete_doctor: :environment do 
    # doctor = Doctor.find("65730f394d6a8435dfbe84df")
    last_doctor = Doctor.last
    last_doctor.destroy 
  end
end