require 'active_support/core_ext/hash/compact'

# rubocop:disable Lint/MissingCopEnableDirective
# rubocop:disable Style/Alias
module Matsuri
  module Traefik
    module K8S
      class Middleware < Matsuri::Kubernetes::Base
        let(:api_version) { 'traefik.containo.us/v1alpha1' }
        let(:kind)        { 'Middleware' }

        let(:spec) { { } }


        class << self
          def load_path
            Matsuri::Config.traefik.middlewares_path
          end

          def definition_module_name
            'TraefikMiddleware'
          end
        end
      end
    end
  end
end
