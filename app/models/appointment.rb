# frozen_string_literal: true

class Appointment # rubocop:disable Style/Documentation
  include Mongoid::Document
  include Mongoid::Timestamps
  field :appointment_date, type: Time
  field :status, type: String
  # field :doctor_name, type: String
  # field :patient_name, type: String
  # validate :appointment_in_future

  belongs_to :doctor
  belongs_to :patient

  validates :status, inclusion: { in: %w[c o], message: '%<value>s is not a valid status' }

  def appointment_in_future
    return unless appointment_date.present? && Time.parse(appointment_date.to_s) <= Time.now

    errors.add(:appointment_date, 'must be in future')
  end
end
