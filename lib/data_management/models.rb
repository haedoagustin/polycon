require 'fileutils'

module DataManagement
  module Models
    class Model
      def initialize(*); end

      def self.find(*args)
        raise DataManagement::Exceptions::RecordNotFound unless File.exist?(file_path(*args))

        new(*args)
      end

      def self.create(*args, **kwargs)
        instance = new(*args, **kwargs)
        instance.save
      end

      def self.file_path(*args)
        File.join(Configuration::DB_DIR, file_name(*args))
      end

      def file_path
        File.join(Configuration::DB_DIR, file_name)
      end

      def destroy
        instance = dup
        FileUtils.rm_rf(file_path)
        instance
    end

    class FileModel < Model
      def self.new_from_file(file)
        args = File.readlines(file)
        new(*data_from_file_name(file), *args)
      end

      def save
        File.open(file_path, File::WRONLY | File::CREAT | File::EXCL) do |f|
          file_contents.each do |line|
            f.puts line
          end
        end
        self
      rescue Errno::EEXIST, Errno::EISDIR
        raise DataManagement::Exceptions::RecordNotUnique
      end

      def update(*)
        File.open(file_path, File::WRONLY | File::TRUNC) do |f|
          file_contents.each do |line|
            f.puts line
          end
        end
        self
      end
    end

    class DirectoryModel < Model
      def self.all
        Dir["#{Configuration::DB_DIR}/**"].map { |dir| new(File.basename(dir)) }
      end

      def children
        Dir["#{file_path}/*"].map { |x| child_class.new_from_file(x) }
      end

      def self.only(*args)
        all.map { |obj| args.flat_map { |arg| obj.send arg.to_sym } }
      end

      def save
        Dir.mkdir(file_path)
        self
      rescue Errno::EEXIST, Errno::EISDIR
        raise DataManagement::Exceptions::RecordNotUnique
      end

      def update(*args)
        FileUtils.mv file_path, self.class.file_path(*args)
      end
    end
  end
end
