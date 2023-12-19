# frozen_string_literal: true

class AppointmentsController < ApplicationController # rubocop:disable Style/Documentation
  include AppointmentMappings
  before_action :set_appointment,
                only: %i[show update destroy doctor_for_appointment appointment_completion_method]

  def index
    @appointments = Appointment.all
    @mapped_appointments = appointment_mapping(@appointments)
    render json: { appointments: @mapped_appointments }, status: :ok
    # @appointments = Appointment.all.map { |appointment| {
    #     appointment_id: appointment.id, doctor_name: appointment.doctor.name.upcase(),
    #     patient_name: appointment.patient.name.upcase(), appointment_time: appointment.appointment_date
    # }}
  end

  def create # rubocop:disable Metrics/MethodLength
    @appointment = Appointment.new(appointment_params)
    if @appointment.valid?
      if @appointment.save
        puts 'sending email now...'
        puts "---------------------Time now-------------------- #{Time.now}"
        AppointmentMailer.patient_mail(@appointment).deliver_now
        puts 'mail sent'
        # render json: { appointment: @appointment }, status: :created
        render json: { message: 'appointment added' }, status: :created
      else
        render json: { message: 'appointment not created' }, status: :unprocessable_entity
      end
    else
      render json: @appointment.errors.full_messages
    end
  end

  def show
    render json: { appointment_id: @appointment.id, doctor_name: @appointment.doctor.name,
                   patient_name: @appointment.patient.name, appointment_date: @appointment.appointment_date }
  end

  def update
    previous_date = @appointment.appointment_date
    if @appointment.update(appointment_params)
      AppointmentMailer.update_appointment(@appointment).deliver_now
      #  AppointmentMailWorker.perform_async('update_appointment', @appointment.id)
      render json: { previous_appointment_date: previous_date, updated_appointment: @appointment }
    else
      render json: @appointment.errors.full_messages, status: :unprocessable_entity
    end
  end

  def destroy
    if @appointment.destroy
      render json: { message: 'appointment deleted' }, status: :ok
    else
      render json: { message: 'appointment not deleted' }, status: :unprocessable_entity
    end
  end

  def doctor_for_appointment
    @doctor = @appointment.doctor
    render json: { doctor_for_appointment: @doctor }, status: :ok
  end

  # appointment completion
  def appointment_completion_method
    return unless @appointment

    if Time.now > @appointment.appointment_date
      puts Time.now
      AppointmentCompletionMailer.appointment_completion(@appointment).deliver_now
      render json: { message: 'appointment has been completed and email sent' }
    else
      render json: { message: 'appointment has yet to be completed' }
    end
  end

  # all completed appointments
  def completed_appointments # rubocop:disable Metrics/MethodLength,Metrics/AbcSize
    @appointments = Appointment.all
    @completed_appointments = []
    @appointments.each do |appointment|
      @completed_appointments << appointment if Time.now > appointment.appointment_date
    end
    if !@completed_appointments.empty?
      AppointmentCompletionMailer.completed_appointments(@appointments).deliver_now
      render json: { completed_appointments: @completed_appointments.map do |appointment|
        {
          doctor_name: appointment.doctor.name, patient_name: appointment.patient.name,
          appointment_date: appointment.appointment_date,
          medicine_details: appointment.patient.patient_medicines.map do |patient_medicine|
                              {
                                medicine_name: patient_medicine.medicine.name,
                                quantity_of_medicine: patient_medicine.quantity
                              }
                            end
        }
      end }
    else
      render json: { message: 'no appointments' }
    end
  end

  private

  def set_appointment
    @appointment = Appointment.find(params[:id])
  rescue Mongoid::Errors::DocumentNotFound
    render json: { message: 'appointment not found' }, status: :not_found
  end

  def appointment_params
    params.require(:appointment).permit(:appointment_date, :status, :doctor_id, :patient_id)
  end
end
