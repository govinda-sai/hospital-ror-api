class Appointment
  include Mongoid::Document
  include Mongoid::Timestamps
  field :appointment_date, type: Time
  
  belongs_to :doctor
  belongs_to :patient
end
