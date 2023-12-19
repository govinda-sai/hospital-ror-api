# frozen_string_literal: true

Rails.application.routes.draw do # rubocop:disable Metrics/BlockLength
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check

  # resources :doctors
  # resources :patients
  # resources :appointments
  resources :medicines
  # resources :patient_medicines

  resources :doctors do
    member do
      get '/patients-by-a-doctor', to: 'doctors#patients_by_doctor'
      get '/patients-medicine-by-doctor', to: 'doctors#patients_medicine_by_doctor'
      get '/doctor-availabilities', to: 'doctors#doctor_availabilities'
    end
  end

  resources :patients do
    member do
      get '/patients-doctor', to: 'patients#patients_doctor'
      get '/patients-medicines', to: 'patients#patients_medicines'
    end
  end

  resources :appointments do
    member do
      get '/doctor-for-appointment', to: 'appointments#doctor_for_appointment'
      get '/appointment-completion-method', to: 'appointments#appointment_completion_method'
    end
  end
  get '/completed-appointments', to: 'appointments#completed_appointments'

  resources :patient_medicines do
    member do
      get '/patient-medicine-details', to: 'patient_medicines#medicine_details_by_patient'
    end
  end

  # Defines the root path route ("/")
  # root "posts#index"
end
