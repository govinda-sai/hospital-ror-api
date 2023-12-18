class AppointmentsController < ApplicationController
    include AppointmentMappings
    before_action :set_appointment, 
    only: [:show, :update, :destroy, :doctor_for_appointment, :appointment_completion_method]
  
    def index
        @appointments = Appointment.all
        @mapped_appointments = appointment_mapping(@appointments)
        render json: { appointments: @mapped_appointments }, status: :ok
        # @appointments = Appointment.all.map { |appointment| {
        #     appointment_id: appointment.id, doctor_name: appointment.doctor.name.upcase(), 
        #     patient_name: appointment.patient.name.upcase(), appointment_time: appointment.appointment_date
        # }}
    end 
  
    def create
        @appointment = Appointment.new(appointment_params)
        if @appointment.valid? 
            if @appointment.save
                puts "sending email now..."
                AppointmentMailer.patient_mail(@appointment).deliver_now
                puts "mail sent"
                # render json: { appointment: @appointment }, status: :created 
                render json: { message: "appointment created" }, status: :created
            else 
                render json: { message: "appointment not created" }, status: :unprocessable_entity
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
            render json: { message: "appointment deleted" }, status: :ok
        else 
            render json: { message: "appointment not deleted" }, status: :unprocessable_entity
        end
    end
    
    def doctor_for_appointment 
        @doctor = @appointment.doctor
        render json: { doctor_for_appointment: @doctor }, status: :ok
    end

    # appointment completion 
    def appointment_completion_method
      if @appointment 
        if (Time.now > @appointment.appointment_date)
            puts "#{Time.now}"
            AppointmentCompletionMailer.appointment_completion(@appointment).deliver_now
            render json: { message: "appointment has been completed and email sent" }
        else
            render json: { message: "appointment has yet to be completed" }
        end
      end
    end

    # all completed appointments 
    def completed_appointments 
        @appointments = Appointment.all 
        @completed_appointments = [] 
        for appointment in @appointments 
            if Time.now > appointment.appointment_date 
                @completed_appointments << appointment
            end
        end
        if !@completed_appointments.empty?
            AppointmentCompletionMailer.completed_appointments(@appointments).deliver_now
            render json: { completed_appointments: @completed_appointments }
        else 
            render json: { message: "no appointments" }
        end
    end
  
    private
  
    def set_appointment
        begin 
            @appointment = Appointment.find(params[:id])
        rescue Mongoid::Errors::DocumentNotFound 
            render json: { message: "appointment not found" }, status: :not_found
        end
    end
  
    def appointment_params
        params.require(:appointment).permit(:appointment_date, :doctor_id, :patient_id, 
                                    :doctor_name, :patient_name)
    end
end
