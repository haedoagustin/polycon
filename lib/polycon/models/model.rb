module Polycon
  module Models
    class Model
      include DataManagement::Mixins::FilePersistable

      ROOT_DIR = File.join(Dir.home, ".polycon")
      FILE = true

      persist_root_dir self::ROOT_DIR

      def file_name
        to_s
      end
    end
  end
end
