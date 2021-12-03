module Polycon
  module Models
    class Professional < DataManagement::Models::DirectoryModel
      include Comparable
      attr_reader :name

      def initialize(name)
        super
        @name = name
      end

      def self.file_name(name)
        name
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

      def destroy
        (super && return) if appointments.empty?
        raise DataManagement::Exceptions::RecordNotDeleted,
              "El profesional tiene turnos dados."
      end

      def child_class
        Polycon::Models::Appointment
      end

      def appointments
        children
      end

      def create_appointment(*args, **kwargs)
        child_class.create(*args, **kwargs)
      end

      def find_appointment(date)
        appointment = appointments.find { |x| x.date === date }
        raise DataManagement::Exceptions::RecordNotFound unless appointment

        appointment
      end

      def filter_appointments(date)
        appointments.select { |x| x.date.strftime("%Y-%m-%d") === date.strftime("%Y-%m-%d") }
      end

      def appointment?(date)
        find_appointment(date).nil?
      rescue DataManagement::Exceptions::RecordNotFound
        false
      end

      def name=(name)
        update(name)
        @name = name
      end
    end
  end
end
