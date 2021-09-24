require 'matsuri'

module Matsuri
  module Traefik
    module K8S
      autoload :IngressRoute, 'matsuri/traefik/k8s/ingress_route'
      autoload :Middleware,   'matsuri/traefik/k8s/middleware'
    end

    module Manifests
      module DaemonSets
        # autoload :IngressController_1_7, 'matsuri/traefik/manifests/pods/ingress-controller-1-7'
        autoload :IngressController, 'matsuri/traefik/manifests/daemon_sets/ingress-controller'
      end

      module Pods
        # autoload :IngressController_1_7, 'matsuri/traefik/manifests/pods/ingress-controller-1-7'
        autoload :IngressController_2_2, 'matsuri/traefik/manifests/pods/ingress-controller-2-2'
        autoload :IngressController_2_3, 'matsuri/traefik/manifests/pods/ingress-controller-2-3'
        autoload :IngressController_2_5, 'matsuri/traefik/manifests/pods/ingress-controller-2-5'
      end

      autoload :RBAC, 'matsuri/traefik/manifests/rbac'
    end
  end
end

# Register paths
Matsuri::Config.config_context(:traefik) do
  default(:traefik_base_path)   { File.join Matsuri::Config.platform_path, 'traefik' }
  default(:ingress_routes_path) { File.join traefik_base_path, 'ingress_routes' }
  default(:middlewares_path)    { File.join traefik_base_path, 'middlewares' }
end

# Add CRD support to tooling
require 'matsuri/traefik/cmd'

Matsuri::Registry.register_class 'traefik_ingress_route', class: Matsuri::Traefik::K8S::IngressRoute
Matsuri::Registry.register_class 'traefik_middleware',    class: Matsuri::Traefik::K8S::Middleware
