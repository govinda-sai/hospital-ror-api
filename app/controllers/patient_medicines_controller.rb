class PatientMedicinesController < ApplicationController
    before_action :set_patient_medicine, only: [:show, :update, :destroy]
  
    def index
        # @patient_medicines = PatientMedicine.all
        @patient_medicines = PatientMedicine.all.map do |patient_medicine| {
            patient_medicine_id: patient_medicine.id, patient_name: patient_medicine.patient.name, 
            medicine_name: patient_medicine.medicine.name, quantity: patient_medicine.quantity,
            total_amount: patient_medicine.total_amount
        }
        end
        render json: { patient_medicines: @patient_medicines }, status: :ok
    end
  
    def create 
        @patient_medicine = PatientMedicine.new(patient_medicine_params)
        if @patient_medicine.valid? 
            if @patient_medicine.save 
                render json: { message: "patient medicine details added" }
                # render json: { medicine: @patient_medicine }
            end
        else 
            render json: @patient_medicine.errors.full_messages 
        end
    end
  
    def show 
        render json: { 
            patient_medicine_id: @patient_medicine.id, patient_name: @patient_medicine.patient.name, 
            medicine_name: @patient_medicine.medicine.name, quantity: @patient_medicine.quantity,
            total_amount: @patient_medicine.total_amount } 
    end 
  
    def update 
        if @patient_medicine.update(patient_medicine_params)
            render json: { updated_patient_medicine: @patient_medicine }
        else
            render json: @patient_medicine.errors.full_messages 
        end
    end
  
    def destroy 
        if @patient_medicine.destroy 
            render json: { message: "patient's medicine deleted" }, status: :ok
        else 
            render json: { message: "patient's medicine id not found" }, status: :unprocessable_entity
        end
    end

    # patient medicine details along with patient details
    def medicine_details_by_patient 
        @patient_medicine = PatientMedicine.find_by(patient_id: params[:id]) 
        render json: { patient_details: @patient_medicine.patient, patient_medicine_details: @patient_medicine }
    end
  
    private 
  
    def set_patient_medicine 
        begin 
            @patient_medicine = PatientMedicine.find(params[:id])
        rescue Mongoid::Errors::DocumentNotFound 
            render json: { message: "patient medicine id not found" }, status: :not_found
        end
    end
  
    def patient_medicine_params 
        params.require(:patient_medicine).permit(:patient_id, :medicine_id, :quantity)
    end
end