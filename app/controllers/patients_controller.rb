class PatientsController < ApplicationController
    before_action :set_patient, only: [:show, :update, :destroy, :patients_medicines]

    def index
        # @patients = Patient.all
        @patients = Patient.all.map { |patient| 
        { patient_id: patient.id, patient_name: patient.name, gender: patient.gender, patient_phone: patient.phone } }
        render json: { patients: @patients }
    end

    def show
        render json: { patient_id: @patient.id, name: @patient.name, gender: @patient.gender, patient_phone: @patient.phone }
    end

    def create
        @patient = Patient.new(patient_params)
        if @patient.valid?
            if @patient.save
                render json: { message: "patient created" }, status: :created
            end
        else 
            render json: @patient.errors.full_messages, status: :unprocessable_entity
        end
    end

    def update
        if @patient.update(patient_params)
            render json: { updated_patient: @patient }
        else 
            render json: @patient.errors.full_messages
        end
    end    

    def destroy 
        if @patient.destroy 
            render json: { message: "patient deleted" }
        else 
            render json: { message: "patient not deleted" }, status: :unprocessable_entity
        end
    end

    def patients_doctor 
        @patient = Patient.find(params[:id])
        @doctors = @patient.doctors 
        render json: { patients_doctor: @doctors }, status: :ok
    end

    # patient's medicines
    def patients_medicines 
        @medicines = @patient.medicines 
        render json: { patients_medicines: @medicines }
    end

    private

    def set_patient
        begin
            @patient = Patient.find(params[:id])
        rescue Mongoid::Errors::DocumentNotFound => e 
            render json: { message: "patient not found" }, status: :not_found 
        end
    end

    def patient_params
        params.require(:patient).permit(:name, :gender, :phone, :email)
    end
end
