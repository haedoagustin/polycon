module Polycon
  module Models
    class Professional < Polycon::Models::Model
      include Comparable

      attr_accessor :name

      def initialize(name:)
        super
        @name = name
      end

      def self.file_name(arg)
        arg
      end

      def file_name
        self.class.file_name(name)
      end

      def <=>(other)
        name <=> other.name
      end

      def to_s
        "Profesional: #{name}"
      end

      def appointments?
        Appointment.filter(professional: self).not_empty?
      end

      def delete
        super.delete unless appointments?
      end
    end
  end
end
