module DataManagement
  module Exceptions
    class RecordNotUnique < Errno::EEXIST; end
    # class RecordNotFound < Errno::EEXIST; end
  end
end
