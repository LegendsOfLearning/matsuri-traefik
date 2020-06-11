require 'active_support/concern'

module Matsuri
  module Traefik
    module Manifests
      module Pods
        module IngressController_1_7
          extend ActiveSupport::Concern

          included do
            let(:version)       { '1.7.8-alpine' }

            let(:namespace)     { 'kube-system' }
            let(:labels)        { { 'ingress-controller' => 'traefik' } }
            let(:volumes)       { [maybe(use_https?) { letsencrypt_volume }].compact }
            # Admin port 8080 is open. However, GCP does not forward anything by default
            # so we are still good here.
            # Open up https port only if we are using https
            let(:ports)         { [http_port, (platform.dev.use_https ? https_port : nil), admin_port].compact }

            let(:http_port)     { port(80, name: :http, host_port: 80) }
            let(:https_port)    { port(443, name: :https, host_port: 443) }
            let(:admin_port)    { port(8080, name: :admin, host_port: 8080) }

            let(:image)         { "docker.io/library/traefik:#{version}" }

            # let(:termination_grace_period_seconds) { 60 }
            let(:termination_grace_period_seconds) { 10 }

            let(:cpu_request)   { '50m' } # Burstable
            #let(:cpu_request)   { '250m' }
            #let(:cpu_limit)     { '1000m' }
            let(:cpu_limit)     { nil }
            let(:mem_request)   { '20Mi' }
            let(:mem_limit)     { '150Mi' }

            let(:use_https?)    { platform.dev.use_https }

            let(:container) do
              {
                name:            'traefik-ingress-lb',
                image:           image,
                ports:           ports,
                resources:       resources,
                args:            args,
                securityContext: security_context,
                volumeMounts:    [maybe(use_https?) { letsencrypt_mount }].compact
              }
            end

            let(:args)             { entry_point_args + default_args + (use_https? ? acme_args : []) }
            let(:entry_point_args) { use_https? ? https_entry_points : http_entry_points }

            let(:http_entry_points) do
              %W[
                --entrypoints=#{http_entrypoint}
                --defaultentrypoints=http
                ]
            end

            let(:https_entry_points) do
              %W[
                --entrypoints=#{redirect_http_entrypoint}
                --entrypoints=#{https_entrypoint}
                --defaultentrypoints=https,http
                ]
            end

            let(:default_args) do
              %W[
                --logLevel=#{platform.dev.traefik_log_level}
                --accesslog
                --api
                --kubernetes
                --ping
                ]
            end

            let(:acme_args) do
              %W[
                --acme
                --acme.entrypoint=https
                --acme.email=#{platform.dev.email}
                --acme.tlschallenge
                --acme.acmelogging
                --acme.storage=/etc/letsencrypt/traefik.json
                --acme.onhostrule
                ]
            end

            let(:main_domains) { tokens.map { |x| "#{x}.#{platform.dev.platform_domain}" }.join(',') }

            let(:http_entrypoint)           { 'Name:http Address::80 Compress:true' }
            let(:redirect_http_entrypoint)  { 'Name:http Address::80 TLS Compress:true Redirect.EntryPoint:https' }
            let(:https_entrypoint)          { 'Name:https Address::443 TLS Compress:true' }

            let(:capabilities) { { drop: %w[ALL], add: %w[NET_BIND_SERVICE] } }

            let(:letsencrypt_mount)  { mount('letsencrypt-data', '/etc/letsencrypt') }
            let(:letsencrypt_volume) { host_path_volume 'letsencrypt-data', config_file('secrets/letsencrypt') }
            #let(:letsencrypt_volume) { empty_dir_volume 'letsencrypt-data' }
          end

          def maybe(cond)
            yield if cond
          end
        end
      end
    end
  end
end
