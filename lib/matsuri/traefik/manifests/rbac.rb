require 'active_support/concern'

# RBAC file for Traefix Ingress controller
# This should be applicable in all clusters
#
# In a rbac file, add:
#
# import_class Matsuri::Traefik::Manifests::RBAC
#
module Matsuri
  module Traefik
    module Manifests
      module RBAC

        def self.scope_manifest(parent_scope)

          # From: https://docs.traefik.io/user-guide/kubernetes/#role-based-access-control-configuration-kubernetes-16-only
          # From: https://docs.traefik.io/v1.7/user-guide/kubernetes/#prerequisites
          parent_scope.cluster_role 'traefik-ingress-controller' do
            label 'matsuri/addon', 'traefik'

            resources %w[services endpoints secrets], verbs: %w[get list watch]
            resources :ingresses,                     verbs: %w[get list watch], api_groups: :extensions
            resources 'ingresses/status',             verbs: %w[update],         api_groups: :extensions

            # CRD for Traefik 2.x
            resources %w[middlewares
              ingressroutes
              traefikservices
              ingressroutetcps
              ingressrouteudps
              tlsoptions
              tlsstores
            ],
              verbs: %w[get list watch],
              api_groups: 'traefik.containo.us'


            bind_to 'traefik-ingress-controller', kind: :service_account, namespace: 'kube-system'
          end

          parent_scope.service_account 'traefik-ingress-controller', namespace: 'kube-system'
        end
      end
    end
  end
end


