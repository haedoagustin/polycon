module DataManagement
  module Managers
    class FileManager
      def initialize(*)
        @file_classes = Configuration::FILE_CLASSES
      end

      def self.use!(db_name: Configuration::DEFAULT_DB_NAME, is_testing: false)
        @db_dir = File.join(Dir.home, db_name)
        is_testing && clean_db
        persist_root_dir(@db_dir)
      end

      def self.clean_db
        Dir["#{@db_dir}/**/*"]                                  \
          .select { |d| File.directory? d }                     \
          .select { |d| (Dir.entries(d) - %w[. ..]).empty? }    \
          .each   { |d| Dir.rmdir d }
      end

      def self.persist_root_dir(dir)
        Dir.mkdir(dir)
      rescue Errno::EEXIST
        nil
      end

      def file_path(instance)
        File.join(@db_dir, instance.file_name)
      end

      def file?(instance)
        @file_classes.include? instance.class
      end

      def save(instance)
        # Directorios
        Dir.mkdir(file_path(instance)) unless file?(instance)
        # Archivos
        file?(instance) && File.open(file_path(instance), 'w') do |f|
          instance.file_contents.each do |line|
            f.puts line
          end
        end

        instance
      rescue Errno::EEXIST, Errno::EISDIR
        raise DataManagement::Exceptions::RecordNotUnique
      end

      # def get_data_from_file(*_args)
      #   data = []
      #   File.open(file, 'r') { |f| data < f }
      #   p data
      # end

      # def update(instance, **kwargs)
      #   # model = self.class.find(self)
      #   # kwargs.each | | field, value |
      #   puts "Se actualiza #{self} con los valores #{kwargs}"
      # end

      # def delete(instance)
      #   puts "Se elimina #{self}"
      # end

      # def find(*args)
      #   # file = File.join(self::ROOT_DIR, file_name(*args))
      # end

      # def all
      #   puts "Se encuentran todos los #{self.class}"
      # end

      # def filter(**kwargs)
      #   puts "Se encuentran todos los #{self.class} según #{kwargs}"
      # end
    end
  end
end
