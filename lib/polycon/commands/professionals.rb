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
          professional = Polycon::Models::Professional.create(name)
          puts "Profesional #{professional.name} creado con éxito"
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
          prof = Polycon::Models::Professional.find(name)
          prof.destroy
          puts "Profesional #{prof.name} eliminado con éxito."
        rescue DataManagement::Exceptions::RecordNotFound
          puts "¡Error! No existe un profesional con ese nombre."
        rescue DataManagement::Exceptions::RecordNotDeleted => e
          puts "¡Error! No se pudo eliminar el profesional:  #{e.message}"
        end
      end

      class List < Dry::CLI::Command
        desc 'List professionals'

        example [
          "          # Lists every professional's name"
        ]

        def call(*)
          puts Polycon::Models::Professional.only("name")
        end
      end

      class Rename < Dry::CLI::Command
        desc 'Rename a professional'

        argument :old_name, required: true, desc: 'Current name of the professional'
        argument :new_name, required: true, desc: 'New name for the professional'

        example [
          '"Alna Esevez" "Alma Estevez" # Renames the professional "Alna Esevez" to "Alma Estevez"'
        ]

        def call(old_name:, new_name:, **)
          prof = Polycon::Models::Professional.find(old_name)
          prof.name = new_name
          puts "¡Hecho! Ahora #{old_name} se llama #{prof.name}"
        rescue DataManagement::Exceptions::RecordNotFound
          puts "¡Error! No existe un profesional con ese nombre."
        end
      end
    end
  end
end
