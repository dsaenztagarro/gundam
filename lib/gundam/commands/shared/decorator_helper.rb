module Gundam
  module Commands
    module Shared
      module DecoratorHelper
        def decorate(obj)
          Kernel.const_get("#{obj.class.name}Decorator").new(obj)
        end
      end
    end
  end
end
