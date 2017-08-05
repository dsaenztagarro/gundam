module Gundam
	class RepoServiceFactory
		class << self
			attr_reader :platform_constant_name

			DEFAULT_API_VERSION = {
				'Github' => 'V3'
			}.freeze

			def with_platform(platform_constant_name)
				@platform_constant_name = platform_constant_name
				self
			end

			def build
				klass_name = "Gundam::#{platform_constant_name}::API::#{api_version}::Gateway"
				service_klass = Kernel.const_get(klass_name)
				service_klass.new
			end

			def api_version
				@api_version || DEFAULT_API_VERSION[platform_constant_name]
			end
		end
	end
end
