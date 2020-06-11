require 'active_support/concern'

# Include this module in the Matsuri daemon_set definition with this:
#
# Matsuri.define :daemon_set, 'traefik-ingress-controller' do
#   include Matsuri::Traefik::Manifests::DaemonSets::IngressController
# end
module Matsuri
  module Traefik
    module Manifests
      module DaemonSets
        module IngressController
          extend ActiveSupport::Concern

          included do
            let(:namespace)    { 'kube-system' }
            let(:pod_name)     { 'traefik-ingress-controller' }
            let(:match_labels) { pod_def.labels }
            let(:revision_history_limit)  { 10 }
          end
        end
      end
    end
  end
end
