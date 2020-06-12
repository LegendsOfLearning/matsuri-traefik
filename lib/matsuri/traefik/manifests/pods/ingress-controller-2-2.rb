require 'active_support/concern'

# Include this module in the Matsuri pod definition with this:
#
# Matsuri.define :pod, 'traefik-ingress-controller' do
#   include Matsuri::Traefik::Manifests::Pods::IngressController_2_2
# end
module Matsuri
  module Traefik
    module Manifests
      module Pods
        module IngressController_2_2
          extend ActiveSupport::Concern

          included do
            let(:version)       { '2.2' }

            let(:namespace)     { 'kube-system' }
            let(:labels)        { { 'ingress-controller' => 'traefik2' } }
            let(:volumes)       { [] }
            #let(:volumes)       { [maybe(use_https?) { letsencrypt_volume }].compact }
            # Admin port 8080 is open. However, GCP does not forward anything by default
            # so we are still good here.
            # Open up https port only if we are using https
            let(:ports)         { [http_port, (use_https? ? https_port : nil), admin_port].compact }

            let(:http_port)     { port(80, name: :http, host_port: 80) }
            let(:https_port)    { port(443, name: :https, host_port: 443) }
            let(:admin_port)    { port(8080, name: :admin, host_port: 8080) }

            let(:image)         { "docker.io/library/traefik:#{version}" }

            let(:log_level)     { 'warn' }

            let(:service_account_name) { 'traefik-ingress-controller' }

            # Set this to an array of namespaces
            let(:watch_namespaces) { nil }

            # let(:termination_grace_period_seconds) { 60 }
            let(:termination_grace_period_seconds) { 12 }
            let(:default_connection_grace_period)  { termination_grace_period_seconds - 2 }

            let(:cpu_request)   { '50m' } # Burstable
            #let(:cpu_request)   { '250m' }
            #let(:cpu_limit)     { '1000m' }
            let(:cpu_limit)     { nil }
            let(:mem_request)   { '20Mi' }
            let(:mem_limit)     { '150Mi' }

            let(:use_https?)    { false }

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

            let(:args) do
              [
                all_entrypoints_args,
                default_args,
                namespace_arg
              ].compact.flatten
            end

            let(:all_entrypoints_args) { use_https? ? https_entrypoints : http_entrypoints }

            let(:http_entrypoints) { entrypoint_args('http', ':80', http_entrypoints_opts) }
            let(:http_entrypoints_opts) do
              {
                forwarded_headers: http_forwarded_headers,
                proxy_protocol:    http_proxy_protocol,
                read_timeout:      http_read_timeout,
                write_timeout:     http_write_timeout,
                idle_timeout:      http_idle_timeout,

                grace_timeout:                http_grace_timeout,
                request_accept_grace_timeout: http_request_accept_grace_timeout
              }
            end

            let(:http_forwarded_headers) { nil }
            let(:http_proxy_protocol)    { nil }
            let(:http_read_timeout)      { nil }
            let(:http_write_timeout)     { nil }
            let(:http_idle_timeout)      { nil }

            let(:http_grace_timeout)                { default_connection_grace_period }
            let(:http_request_accept_grace_timeout) { nil }


            let(:https_entrypoints)     { entrypoint_arg('https', ":443", https_entrypoint_opts) }
            let(:https_entrypoints_opts) { { } }

            let(:default_args) do
              %W[
                --log=true
                --log.level=#{log_level}
                --accesslog
                --api
                --providers.kubernetescrd
                --ping
                ]
            end

            let(:namespace_arg) do
              maybe(watch_namespaces.present?) do
                  "--providers.kubernetescrd.namespaces=#{watch_namespaces.join(',')}"
              end
            end

            let(:capabilities) { { drop: %w[ALL], add: %w[NET_BIND_SERVICE] } }
          end

          def entrypoint_args(name, addr, opts = {})
            [
              entrypoint_arg(name, "address", addr),
              trusted_ips_arg(name, "forwardedHeaders", opts[:forwarded_headers]),
              trusted_ips_arg(name, "proxyProtocol", opts[:proxy_protocol]),
              maybe(opts[:read_timeout]) { entrypoint_arg(name, "transport.respondingTimeouts.readTimeout", opts[:read_timeout]) },
              maybe(opts[:write_timeout]) { entrypoint_arg(name, "transport.respondingTimeouts.writeTimeout", opts[:write_timeout]) },
              maybe(opts[:idle_timeout]) { entrypoint_arg(name, "transport.respondingTimeouts.idleTimeout", opts[:idle_timeout]) },
              maybe(opts[:request_accept_grace_timeout]) { entrypoint_arg(name, "transport.lifeCycle.requestAcceptGraceTimeout", opts[:request_accept_grace_timeout]) },
              maybe(opts[:grace_timeout]) { entrypoint_arg(name, "transport.lifeCycle.graceTimeOut", opts[:grace_timeout]) }
            ].compact
          end

          def entrypoint_arg(name, key, value)
            "--entryPoints.#{name}.#{key}=#{value}"
          end

          def trusted_ips_arg(name, key, opt)
            case opt
            when :insecure
              entrypoint_arg(name, "#{key}.insecure", "true")
            when nil
              nil
            else
              entrypoint_arg(name, "#{key}.trustedIPs", opt)
            end
          end

          def maybe(cond)
            yield if cond
          end
        end
      end
    end
  end
end
