module DataManagement
  module Mixins
    module FilePersistable

      def save
        file = File.join(self.class::ROOT_DIR, file_name)

        begin
          # Directorios
          (Dir.mkdir(file) && return) unless self.class.file?
          # Archivos
          File.open(file, 'w') { |f| file_contents.each { |line| f.puts line } }
        rescue Errno::EEXIST, Errno::EISDIR
          raise DataManagement::Exceptions::RecordNotUnique
        end
      end

      def update(**kwargs)
        # model = self.class.find(self)
        # kwargs.each | | field, value |
        puts "Se actualiza #{self} con los valores #{kwargs}"
      end

      def delete
        puts "Se elimina #{self}"
      end

      module FilePersistableClassMethods
        def persist_root_dir(dir)
          Dir.mkdir(dir)
        rescue Errno::EEXIST
          nil
        end

        def create_from_file(*args)
          data = []
          File.open(file, 'r') {|f| data < f }
          p data
        end

        def file?
          self::FILE
        end

        def find(*args)
          # file = File.join(self::ROOT_DIR, file_name(*args))
        end
  
        def all
          puts "Se encuentran todos los #{self.class}"
        end
  
        def filter(**kwargs)
          puts "Se encuentran todos los #{self.class} según #{kwargs}"
        end
      end      

      def self.included(mod)
        mod.extend(FilePersistableClassMethods)
      end
    end
  end
end
