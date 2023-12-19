class PatientMedicine
  include Mongoid::Document
  include Mongoid::Timestamps
  field :quantity, type: Integer
  field :total_amount, type: Float

  belongs_to :patient
  belongs_to :medicine

  # validates_presenece_of :quantity

  before_save :calculate_total_amount

  def calculate_total_amount 
    if quantity.present? && medicine.present? 
      self.total_amount = quantity * medicine.price 
    else
      errors.add("quantity and medicine should be entered")
    end
  end
end