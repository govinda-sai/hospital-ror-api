class DoctorsController < ApplicationController
    before_action :set_doctor, 
        only: [:show, :update, :destroy, :patients_by_doctor, :patients_medicine_by_doctor]

    def index 
        # @doctors = Doctor.all
        # @doctors = Doctor.pluck(:name, :email, :specialization)
        @doctors = Doctor.all.map { |doctor| 
            { doctor_id: doctor.id, name: doctor.name, email: doctor.email, specialization: doctor.specialization } }
        render json: { doctors: @doctors }, status: :ok
    end

    def show 
        # render json: { doctor: @doctor }
        render json: { doctor_id: @doctor.id, name: @doctor.name }
    end

    def create 
        @doctor = Doctor.new(doctor_params)
        if @doctor.valid?
            if @doctor.save 
                render json: { doctor: @doctor }, status: :created 
            end
        else 
            render json: @doctor.errors.full_messages 
        end
    end

    def update 
        if @doctor.update(doctor_params)
            render json: { updated_doctor: @doctor }
        else
            render json: { message: "doctor not updated" }
        end
    end

    def destroy 
        if @doctor.destroy 
            render json: { message: "doctor deleted" }
        else 
            render json: { message: "doctor not deleted" }, status: :unprocessable_entity
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

    private 

    def set_doctor 
        begin
            @doctor = Doctor.find(params[:id]) 
        rescue Mongoid::Errors::DocumentNotFound
            render json: { message: "doctor not found" }
        end
    end 

    def doctor_params 
        params.require(:doctor).permit(:name, :email, :specialization)
    end
end
