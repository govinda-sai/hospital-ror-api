# frozen_string_literal: true

namespace :patients do # rubocop:disable Metrics/BlockLength
  desc 'get all patients'

  task get_patients: :environment do
    patients = Patient.all

    patients.each do |patient|
      puts "#{patient.name} - #{patient.gender} - #{patient.phone}"
    end
  end

  desc 'update patient'
  task update_patient: :environment do
    patient = Patient.where(name: 'carti')

    if patient.present?
      patient.update(name: 'playboi carti')
      puts 'patient updated'
    else
      puts 'patient not found'
    end
  end

  desc 'add patient'
  task add_patient: :environment do
    patient = Patient.new(name: 'dummy',
                          gender: 'm',
                          phone: '222222222222',
                          email: 'dummy@gmail.com')
    if patient.save
      puts "#{patient.name} has been saved"
    else
      puts 'failed to create patient'
    end
  end

  desc 'delete patient'
  task delete_patient: :environment do
    patient = Patient.where(name: 'dummy')
    if patient.present?
      patient.destroy
      puts "#{patient.name} has been deleted"
    else
      puts 'failed to delete patient'
    end
  end
end
