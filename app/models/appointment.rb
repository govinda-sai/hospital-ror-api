class Appointment
  include Mongoid::Document
  include Mongoid::Timestamps
  field :appointment_date, type: Time
  # field :doctor_name, type: String
  # field :patient_name, type: String
  
  belongs_to :doctor
  belongs_to :patient
end
