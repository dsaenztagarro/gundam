module Gundam
	class RepoServiceFactory
		class << self
			attr_reader :platform_constant_name

			def with_platform(platform_constant_name)
				@platform_constant_name = platform_constant_name
				self
			end

			def build
        require_relative "../#{platform_constant_name.downcase}/gateway"
				klass_name = "Gundam::#{platform_constant_name}::Gateway"
				service_klass = Kernel.const_get(klass_name)
				service_klass.new
			end
		end
	end
end
