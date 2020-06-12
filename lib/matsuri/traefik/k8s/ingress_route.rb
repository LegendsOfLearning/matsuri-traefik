require 'active_support/core_ext/hash/compact'

# rubocop:disable Lint/MissingCopEnableDirective
# rubocop:disable Style/Alias
module Matsuri
  module Traefik
    module K8S
      class IngressRoute < Matsuri::Kubernetes::Base
        let(:api_version) { 'traefik.containo.us/v1alpha1' }
        let(:kind)        { 'IngressRoute' }

        let(:spec) do
          {
            entry_points: entry_points,
            routes:       routes,
            tls:          tls
          }.compact
        end

        let(:entry_points) { fail NotImplemented, 'Must define let(:entry_points) <Array>' }

        ### routes

        let(:routes) { [default_route] }

        let(:default_route) do
          rule "Host('test.example.com')",
            priority: 10,
            middleware: [ middleware('middleware1', namespace: 'default') ],
            services: [foo_service]
        end

        def rule(match, priority: nil, middlewares: [], services:)
          {
            match: match,
            kind: 'Rule',
            priority: priority,
            middlewares: middlewares,
            services: services
          }.compact
        end

        def middleware(name, namespace: 'default')
          {
            name: name,
            namespace: namespace
          }
        end

        def k8s_service(name, opts = {})
          {
            kind: 'Service',
            name: name,
            passHostHeader: opts.key?(:pass_host_header) ? opts[:pass_host_header] : true,
            responseForwarding: opts[:response_forwarding],
            scheme: opts[:scheme] || 'https',
            sticky: opts[:sticky]
          }.compact
        end

        def cookie(name, http_only: nil, secure: nil, same_site: nil)
          {
            cookie: {
              name: name,
              http_only: http_only,
              secure: secure,
              same_site: same_site
            }.compact
          }
        end

        ### tls
        let(:tls) { no_tls } # default
        let(:no_tls) { nil }

        # For now, you can override the tls by adding in your own hash
        # TLS to be implemented in the future

        class << self
          def load_path
            Matsuri::Config.traefik.ingress_routes_path
          end

          def definition_module_name
            'TraefikIngressRoutes'
          end
        end
      end
    end
  end
end
