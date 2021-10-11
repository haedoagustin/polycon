require 'date'

module Polycon
  module Models
    class Appointment < Polycon::Models::Model

      attr_reader :date
      attr_accessor :professional, :name, :surname, :phone, :notes

      def initialize(date, professional, *patient, notes)
        @date = date
        @professional = professional
        @name, @surname, @phone = *patient
        @notes = notes
      end

      def reschedule(new_date)
        raise "El profesional ya tiene turno para esa fecha" unless professional.hasnt_appointment? new_date

        @date = new_date
      end

      def self.file_name(professional, date)
        "#{professional.name}/#{date.strftime('%F_%H-%I')}.paf"
      end

      def file_name
        self.class.file_name(professional, date)
      end

      def file_contents
        [@surname, @name, @phone, @notes]
      end

      def to_s
        "Fecha: #{@date}, profesional: #{@professional.name}"
      end
    end
  end
end
