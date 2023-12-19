class Medicine
  include Mongoid::Document
  include Mongoid::Timestamps
  field :name, type: String
  field :expiry_date, type: Date
  field :price, type: Float

  has_many :patient_medicines

  # validates_presenece_of :name, :expiry_date, :price

  def patients 
    Patient.in(id: patient_medicine.pluck(:patient_id))
  end
end