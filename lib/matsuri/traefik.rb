require 'matsuri'

module Matsuri
  module Traefik
    module K8S
      autoload :IngressRoute, 'matsuri/traefik/k8s/ingress_route'
    end
  end
end

# Register paths
Matsuri::Config.config_context(:traefik) do
  default(:traefik_base_path)   { File.join Matsuri::Config.platform_path, 'traefik' }
  default(:ingress_routes_path) { File.join traefik_base_path, 'ingress_routes' }
end

# Add CRD support to tooling
require 'matsuri/traefik/cmd'

Matsuri::Registry.register_class 'traefik_ingress_route', class: Matsuri::Traefik::K8S::IngressRoute
