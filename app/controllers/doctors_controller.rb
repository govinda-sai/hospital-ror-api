# frozen_string_literal: true

# require "/home/govindasai/Hospital/app/models/doctor_availability.rb"

class DoctorsController < ApplicationController # rubocop:disable Style/Documentation
  include DoctorAvailabilities
  # extend DoctorAvailabilities

  # before_action :authenticate_user!, only: %i[index show]
  before_action :set_doctor,
                only: %i[show update destroy patients_by_doctor patients_medicine_by_doctor doctor_availabilities]

  def index
    # @doctors = Doctor.all.paginate(page: params[:page], per_page: 2)
    @doctors = Doctor.all.map do |doctor|
      { doctor_id: doctor.id, name: doctor.name, email: doctor.email, specialization: doctor.specialization }
    end
    render json: { doctors: @doctors }, status: :ok
  end

  def show
    render json: { doctor_id: @doctor.id, name: @doctor.name, email: @doctor.email,
                   specialization: @doctor.specialization }
  end

  def create
    @doctor = Doctor.new(doctor_params)
    if @doctor.valid?
      render json: { doctor: @doctor }, status: :created if @doctor.save
    else
      render json: @doctor.errors.full_messages
    end
  end

  def update
    if @doctor.update(doctor_params)
      render json: { updated_doctor: @doctor }
    else
      render json: { message: 'doctor not updated' }
    end
  end

  def destroy
    if @doctor.destroy
      render json: { message: 'doctor deleted' }
    else
      render json: { message: 'doctor not deleted' }, status: :unprocessable_entity
    end
  end

  # patients by a doctor
  def patients_by_doctor
    @patients = @doctor.patients
    render json: { patients_by_a_doctor: @patients }, status: :ok
  end

  def patients_medicine_by_doctor
    @patients = @doctor.patients
    @medicines = @patients.flat_map(&:medicines)
    render json: { patients: @patients, patient_medicines_by_doctor: @medicines }
  end

  # doctor availabilities
  def doctor_availabilities # rubocop:disable Metrics/AbcSize,Metrics/MethodLength
    if @doctor.present?
      errors = []
      availabilities, = get_appointment_time(@doctor, errors)
      render json: { doctor_availabilities: availabilities.map do |available|
                                              {
                                                doctor_id: available.doctor.id, doctor_name: available.doctor.name,
                                                patient_detials: available.doctor.patients.map do |patient|
                                                                   {
                                                                     patient_name: patient.name
                                                                   }
                                                                 end,
                                                appointment_time: available.doctor.appointments.map do |appointment|
                                                                    {
                                                                      appointment_date_time: appointment.appointment_date # rubocop:disable Layout/LineLength
                                                                    }
                                                                  end
                                              }
                                            end }
    else
      render json: @doctor.errors.full_messages
    end
  end

  private

  def set_doctor
    @doctor = Doctor.find(params[:id])
  rescue Mongoid::Errors::DocumentNotFound
    render json: { message: 'doctor not found' }, status: :not_found
  end

  def doctor_params
    params.require(:doctor).permit(:name, :email, :specialization)
  end
end
