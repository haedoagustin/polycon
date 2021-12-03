module Polycon
  module Commands
    module Appointments
      class Create < Dry::CLI::Command
        desc 'Create an appointment'

        argument :date, required: true, desc: 'Full date for the appointment'
        option :professional, required: true, desc: 'Full name of the professional'
        option :name, required: true, desc: "Patient's name"
        option :surname, required: true, desc: "Patient's surname"
        option :phone, required: true, desc: "Patient's phone number"
        option :notes, required: false, desc: "Additional notes for appointment"

        example [
          '"2021-09-16 13:00" --professional="Alma Estevez" --name=Carlos --surname=Carlosi --phone=2213334567'
        ]

        def call(date:, **options)
          professional, name, surname, phone, notes = options.values
          prof = Polycon::Models::Professional.find(professional)
          appointment = prof.create_appointment(DateTime.parse(date), prof, name, surname, phone, notes)
          puts "Se ha creado el turno: #{appointment}"
        rescue DataManagement::Exceptions::RecordNotFound
          puts "¡Error! No existe un profesional con ese nombre."
        rescue DataManagement::Exceptions::RecordNotUnique
          puts "¡Error! Ya existe un turno dado para esta fecha y profesional."
        end
      end

      class Show < Dry::CLI::Command
        desc 'Show details for an appointment'

        argument :date, required: true, desc: 'Full date for the appointment'
        option :professional, required: true, desc: 'Full name of the professional'

        example [
          '"2021-09-16 13:00" --professional="Alma Estevez" # Shows information for the appointment with Alma Estevez on
          the specified date and time'
        ]

        def call(date:, professional:)
          prof = Polycon::Models::Professional.find(professional)
        rescue DataManagement::Exceptions::RecordNotFound
          puts "¡Error! No existe un profesional con ese nombre."
        else
          begin
            puts prof.find_appointment(DateTime.parse(date))
          rescue DataManagement::Exceptions::RecordNotFound
            puts "¡Error! No existe un turno para esa fecha."
          end
        end
      end

      class Cancel < Dry::CLI::Command
        desc 'Cancel an appointment'

        argument :date, required: true, desc: 'Full date for the appointment'
        option :professional, required: true, desc: 'Full name of the professional'

        example [
          '"2021-09-16 13:00" --professional="Alma Estevez" # Cancels the appointment with Alma Estevez
          on the specified date and time'
        ]

        def call(date:, professional:)
          prof = Polycon::Models::Professional.find(professional)
        rescue DataManagement::Exceptions::RecordNotFound
          puts "¡Error! No existe un profesional con ese nombre."
        else
          begin
            appointment = prof.find_appointment(DateTime.parse(date))
          rescue DataManagement::Exceptions::RecordNotFound
            puts "¡Error! El turno no existe."
          else
            appointment.cancel
            puts "Se canceló el #{appointment}"
          end
        end
      end

      class CancelAll < Dry::CLI::Command
        desc 'Cancel all appointments for a professional'

        argument :professional, required: true, desc: 'Full name of the professional'

        example [
          '"Alma Estevez" # Cancels all appointments for professional Alma Estevez'
        ]

        def call(professional:)
          prof = Polycon::Models::Professional.find(professional)
        rescue DataManagement::Exceptions::RecordNotFound
          puts "¡Error! No existe un profesional con ese nombre."
        else
          begin
            prof.appointments.each(&:cancel)
            puts "Se cancelaron los turnos de #{prof.name}"
          end
        end

        class List < Dry::CLI::Command
          desc 'List appointments for a professional, optionally filtered by a date'

          argument :professional, required: true, desc: 'Full name of the professional'
          option :date, required: false, desc: 'Date to filter appointments by (should be the day)'

          example [
            '"Alma Estevez" # Lists all appointments for Alma Estevez',
            '"Alma Estevez" --date="2021-09-16" # Lists appointments for Alma Estevez on the specified date'
          ]

          def call(professional:, date: nil)
            prof = Polycon::Models::Professional.find(professional)
            appointments = prof.appointments
            appointments = prof.filter_appointments(DateTime.parse(date)) unless date.nil?
            puts appointments
          rescue DataManagement::Exceptions::RecordNotFound
            puts "¡Error! No existe un profesional con ese nombre."
          end
        end

        class Reschedule < Dry::CLI::Command
          desc 'Reschedule an appointment'

          argument :old_date, required: true, desc: 'Current date of the appointment'
          argument :new_date, required: true, desc: 'New date for the appointment'
          option :professional, required: true, desc: 'Full name of the professional'

          example [
            '"2021-09-16 13:00" "2021-09-16 14:00" --professional="Alma Estevez" # Reschedules appointment on the first
          date for professional Alma Estevez to be now on the second date provided'
          ]

          def call(old_date:, new_date:, professional:)
            prof = Polycon::Models::Professional.find(professional)
          rescue DataManagement::Exceptions::RecordNotFound
            puts "¡Error! No existe un profesional con ese nombre."
          else
            begin
              appointment = prof.find_appointment(DateTime.parse(old_date))
              appointment.reschedule(DateTime.parse(new_date))
              puts "Se reprogramó el turno de #{old_date} a #{new_date}."
            rescue DataManagement::Exceptions::RecordNotFound
              puts "¡Error! No existe el turno que querés reprogramar."
            rescue DataManagement::Exceptions::RecordNotUnique
              puts "¡Error! Ya existe un turno dado para esta fecha y profesional."
            end
          end
        end

        class Edit < Dry::CLI::Command
          desc 'Edit information for an appointments'

          argument :date, required: true, desc: 'Full date for the appointment'
          option :professional, required: true, desc: 'Full name of the professional'
          option :name, required: false, desc: "Patient's name"
          option :surname, required: false, desc: "Patient's surname"
          option :phone, required: false, desc: "Patient's phone number"
          option :notes, required: false, desc: "Additional notes for appointment"

          example [
            '"2021-09-16 13:00" --professional="Alma Estevez" --name="New name" # Only changes the patient\'s name for the
           specified appointment. The rest of the information remains unchanged.',
            '"2021-09-16 13:00" --professional="Alma Estevez" --name="New name" --surname="New surname" # Changes the
           patient\'s name and surname for the specified appointment. The rest of the information remains unchanged.',
            '"2021-09-16 13:00" --professional="Alma Estevez" --notes="Some notes for the appointment" # Only changes the
           notes for the specified appointment. The rest of the information remains unchanged.'
          ]

          def call(date:, professional:, **options)
            prof = Polycon::Models::Professional.find(professional)
          rescue DataManagement::Exceptions::RecordNotFound
            puts "¡Error! No existe un profesional con ese nombre."
          else
            begin
              appointment = prof.find_appointment(DateTime.parse(date))
              appointment.update(options)
              puts "El turno con fecha #{date} del profesional #{prof.name} se actualizó."
            rescue DataManagement::Exceptions::RecordNotFound
              puts "¡Error! No existe un turno para esa fecha."
            end
          end
        end
      end
    end
  end
end
