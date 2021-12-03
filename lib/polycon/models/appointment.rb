require 'date'

module Polycon
  module Models
    class Appointment < DataManagement::Models::FileModel
      attr_reader :professional
      attr_accessor :date, :name, :surname, :phone, :notes

      def initialize(date, professional, *options)
        super
        @date = date
        @professional = professional
        @name, @surname, @phone, @notes = *options
      end

      def reschedule(new_date)
        raise DataManagement::Exceptions::RecordNotUnique if professional.appointment? new_date

        @date = new_date
        update
      end

      def update(name: nil, surname: nil, phone: nil, notes: nil)
        @name = name || @name
        @surname = surname || @surname
        @phone = phone || @phone
        @notes = notes || @notes

        super
      end

      def self.file_name(date, professional)
        "#{professional.name}/#{date.strftime('%Y-%m-%d_%H-%M')}.paf"
      end

      def self.data_from_file_name(file_name)
        parent_path, date_path = File.split(file_name)
        prof = Polycon::Models::Professional.new(File.basename(parent_path))
        date = DateTime.strptime(File.basename(date_path, '.paf'), '%Y-%m-%d_%H-%M')
        [date, prof]
      end

      def file_name
        self.class.file_name(date, professional)
      end

      def file_contents
        [surname, name, phone, notes]
      end

      def to_s
        "Turno con fecha #{date.strftime('%F')}, a la/s #{date.strftime('%k:%M')} con #{professional.name}"
      end

      def cancel
        destroy
      end
    end
  end
end
