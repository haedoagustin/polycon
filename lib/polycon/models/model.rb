module Polycon
  module Models
    class Model
      include DataManagement::Mixins::FilePersistable

      def initialize(*); end

      def file_name
        to_s
      end
    end
  end
end
