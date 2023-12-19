# frozen_string_literal: true

class AppointmentsController < ApplicationController # rubocop:disable Style/Documentation,Metrics/ClassLength
  include AppointmentMappings
  before_action :set_appointment,
                only: %i[show update destroy doctor_for_appointment appointment_completion_method]

  def index
    @appointments = Appointment.all
    @mapped_appointments = appointment_mapping(@appointments)
    render json: { appointments: @mapped_appointments }, status: :ok
  end

  def create # rubocop:disable Metrics/MethodLength
    @appointment = Appointment.new(appointment_params)
    if @appointment.valid?
      if @appointment.save
        puts 'sending email now...'
        puts "---------------------Time now-------------------- #{Time.now}"
        AppointmentMailer.patient_mail(@appointment).deliver_now
        puts 'mail sent'
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
  def appointment_completion_method # rubocop:disable Metrics/MethodLength,Metrics/AbcSize,Metrics/PerceivedComplexity
    return unless @appointment

    if Time.now > @appointment.appointment_date
      puts Time.now
      if @appointment.status == 'o' || @appointment.status.nil?
        if AppointmentCompletionMailer.appointment_completion(@appointment).deliver_now
          @appointment.update(status: 'c')
          render json: { message: 'appointment has been completed and email sent' }
        else
          @appointment.update(status: 'o')
          render json: { message: 'could not send mail' }
        end
      else
        render json: { message: 'appointment mail has been sent and is closed' }
      end
    else
      render json: { message: 'appointment has yet to be completed' }
    end
  end

  def completed_appointments # rubocop:disable Metrics/MethodLength,Metrics/AbcSize
    @appointments = Appointment.all
    @completed_appointments = @appointments.select do |appointment|
      Time.now > appointment.appointment_date && appointment.status == 'o'
    end

    if @completed_appointments.present?
      AppointmentCompletionMailer.completed_appointments(@completed_appointments).deliver_now
      @completed_appointments.each do |appointment|
        appointment.update(status: 'c')
      end

      render json: {
        completed_appointments: @completed_appointments.map do |appointment|
          {
            doctor_name: appointment.doctor.name,
            patient_name: appointment.patient.name,
            appointment_date: appointment.appointment_date,
            medicine_details: appointment.patient.patient_medicines.map do |patient_medicine|
              {
                medicine_name: patient_medicine.medicine.name,
                quantity_of_medicine: patient_medicine.quantity
              }
            end,
            appointment_status: appointment.status
          }
        end
      }
    else
      render json: { message: 'no completed appointments' }
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
