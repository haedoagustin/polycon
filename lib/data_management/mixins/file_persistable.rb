module DataManagement
  module Mixins
    module FilePersistable
      DB_MANAGER = DataManagement::Managers::FileManager.new

      def save
        DB_MANAGER.save(self)
      end

      module FilePersistableClassMethods
        def create(*args, **kwargs)
          new(*args, **kwargs).save
        end
      end

      def self.included(mod)
        mod.extend(FilePersistableClassMethods)
      end
    end
  end
end
