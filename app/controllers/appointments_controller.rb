class AppointmentsController < ApplicationController
    before_action :set_appointment, only: [:show, :update, :destroy, :doctor_for_appointment]
  
    def index
        @appointments = Appointment.all
        render json: { appointments: @appointments }, status: :ok
    end
  
    def create
        @appointment = Appointment.new(appointment_params)
        if @appointment.valid? 
            if @appointment.save
                render json: { appointment: @appointment }, status: :created 
            end
        else 
            render json: @appointment.errors.full_messages
        end
    end
  
    def show
        render json: @appointment
    end
  
    def update
        if @appointment.update(appointment_params)
            render json: { updated_appointment: @appointment }
        else
            render json: @appointment.errors.full_messages, status: :unprocessable_entity
        end
    end
    
    def doctor_for_appointment 
        @doctor = @appointment.doctor
        render json: { doctor_for_appointment: @doctor }, status: :ok
    end

    def destroy
        if @appointment.destroy
            render json: { message: "appointment deleted" }, status: :ok
        else 
            render json: { message: "appointment not deleted" }, status: :unprocessable_entity
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
        params.require(:appointment).permit(:appointment_date, :doctor_id, :patient_id)
    end
end
