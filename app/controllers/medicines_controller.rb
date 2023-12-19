# frozen_string_literal: true

class MedicinesController < ApplicationController # rubocop:disable Style/Documentation
  before_action :set_medicine, only: %i[show update destroy]

  def index
    # @medicines = Medicine.all
    @medicines = Medicine.all.map do |medicine|
      {
        medicine_id: medicine.id, medicine_name: medicine.name, price: medicine.price, expiry_date: medicine.expiry_date
      }
    end
    render json: { medicines: @medicines }, status: :ok
  end

  def create
    @medicine = Medicine.new(medicine_params)
    if @medicine.valid?
      if @medicine.save
        render json: { message: 'medicine created' }, status: :ok
        # render json: { medicine: @medicine }
      end
    else
      render json: @medicine.errors.full_messages, status: :unprocessable_entity
    end
  end

  def show
    render json: { medicine_id: medicine.id, medicine_name: medicine.name, price: medicine.price,
                   expiry_date: medicine.expiry_date }
  end

  def update
    if @medicine.update(medicine_params)
      render json: { updated_medicine: @medicine }
    else
      render json: @medicine.errors.full_messages
    end
  end

  def destroy
    if @medicine.destroy
      render json: { message: 'medicine deleted' }, status: :ok
    else
      render json: { message: 'medicine not deleted' }, status: :unprocessable_entity
    end
  end

  private

  def set_medicine
    @medicine = Medicine.find(params[:id])
  rescue Mongoid::Errors::DocumentNotFound
    render json: { message: 'medicine not found' }, status: :not_found
  end

  def medicine_params
    params.require(:medicine).permit(:name, :expiry_date, :price)
  end
end
