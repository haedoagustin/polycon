module DataManagement
  module Exceptions
    class RecordNotUnique < Errno::EEXIST; end

    class RecordNotFound < Errno::ENOENT; end

    class RecordNotDeleted < Errno::EISDIR; end
  end
end
