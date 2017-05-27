class PlatformServiceFactory
  attr_reader :platform_constant_name

  DEFAULT_API_VERSION = {
    'Github' => 'V3'
  }

  def with_platform(platform_constant_name)
    @platform_constant_name = platform_constant_name
    self
  end

  def with_api_version(api_version)
    @api_version = api_version.to_s
    self
  end

  def build
    service_klass_name = "Platforms::#{platform_constant_name}::Service"
    service_klass = Kernel.const_get(service_klass_name)
    service_klass.new(create_connector)
  end

  def api_version
    @api_version || DEFAULT_API_VERSION[platform_constant_name]
  end

  private

  def create_connector
    service_klass = Kernel.const_get(
      "Platforms::#{platform_constant_name}::API::#{api_version}::Connector")
    service_klass.new
  end
end
