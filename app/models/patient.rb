class Patient
  include Mongoid::Document
  include Mongoid::Timestamps
  field :name, type: String
  field :gender, type: String
  field :phone, type: String
  field :email, type: String

  # validates_presenece_of :name, :gender, :phone, :email

  # has_and_belongs_to_many :doctors
  has_many :appointments
  has_many :patient_medicines
  # has_many :medicines, through: :patient_medicines
  
  def doctors 
    Doctor.in(id: appointments.pluck(:doctor_id))
  end

  def medicines 
    Medicine.in(id: patient_medicines.pluck(:medicine_id))
  end
end