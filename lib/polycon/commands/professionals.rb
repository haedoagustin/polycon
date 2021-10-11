module Polycon
  module Commands
    module Professionals
      class Create < Dry::CLI::Command
        desc 'Create a professional'

        argument :name, required: true, desc: 'Full name of the professional'

        example [
          '"Alma Estevez"      # Creates a new professional named "Alma Estevez"',
          '"Ernesto Fernandez" # Creates a new professional named "Ernesto Fernandez"'
        ]

        def call(name:, **)
          p Polycon::Models::Professional.find(name)
          # professional = Polycon::Models::Professional.new(name)
          # professional.save
          # puts "Profesional #{professional.name} creado con éxito"
        rescue DataManagement::Exceptions::RecordNotUnique
          puts "¡Error! Un profesional con ese nombre ya existe."
        end
      end

      class Delete < Dry::CLI::Command
        desc 'Delete a professional (only if they have no appointments)'

        argument :name, required: true, desc: 'Name of the professional'

        example [
          '"Alma Estevez"      # Deletes a new professional named "Alma Estevez" if they have no appointments',
          '"Ernesto Fernandez" # Deletes a new professional named "Ernesto Fernandez" if they have no appointments'
        ]

        def call(name: nil)
          prof = Polycon::Models::Professional.find(name).delete
          puts "Profesional #{prof.name} eliminado con éxito."
        end
      end

      class List < Dry::CLI::Command
        desc 'List professionals'

        example [
          "          # Lists every professional's name"
        ]

        def call(*)
          Polycon::Models::Professional.only("name").each(&:puts)
        end
      end

      class Rename < Dry::CLI::Command
        desc 'Rename a professional'

        argument :old_name, required: true, desc: 'Current name of the professional'
        argument :new_name, required: true, desc: 'New name for the professional'

        example [
          '"Alna Esevez" "Alma Estevez" # Renames the professional "Alna Esevez" to "Alma Estevez"',
        ]

        def call(old_name:, new_name:, **)
          prof = Polycon::Models::Professional.find(old_name)
          prof.name = new_name
          prof.save
          puts "¡Hecho! Ahora #{old_name} se llama #{prof.name}"
        end
      end
    end
  end
end
