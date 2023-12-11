class Doctor
  include Mongoid::Document
  include Mongoid::Timestamps
  field :name, type: String
  field :email, type: String
  field :specialization, type: String

  has_many :appointments

  def patients 
    Patient.in(id: appointments.pluck(:patient_id))
  end
end