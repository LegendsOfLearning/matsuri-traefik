require 'active_support/core_ext/hash/compact'

# rubocop:disable Lint/MissingCopEnableDirective
# rubocop:disable Style/Alias
module Matsuri
  module Traefik
    module K8S
      class TLSOption < Matsuri::Kubernetes::Base
        let(:api_version) { 'traefik.containo.us/v1alpha1' }
        let(:kind)        { 'TLSOption' }

        let(:spec) do
          {
            alpnProtocols: alpn_protocols,
            cipherSuites: cipher_suites,
            clientAuth: client_auth,
            curvePreferences: curve_preferences,
            maxVersion: max_version,
            minVersion: min_version,
            preferServerCipherSuites: prefer_server_cipher_suites,
            sniStrict: sni_strict,
          }.compact
        end

        let(:cipher_suites) do
          %W[
            TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
            TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
            TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305
          ]
        end

        let(:alpn_protocols) { nil }
        let(:client_auth) { nil }
        let(:curve_preferences) { nil }
        let(:max_version) { nil }
        let(:min_version) { "VersionTLS12" }
        let(:prefer_server_cipher_suites) { nil }
        let(:sni_strict) { nil }


        def client_auth_config(type, secret_names: nil, ca_files: nil)
          secret_names = secret_names.nil?? nil : Array(config[:secret_names])
          ca_files     = ca_files.nil?? nil : Array(config[:ca_files])

          {
            clientAuthType: type.to_s,
            secretNames: secret_names,
            ca_files: ca_files,
          }.compact
        end


        class << self
          def load_path
            Matsuri::Config.traefik.tls_options_path
          end

          def definition_module_name
            'TLSOptions'
          end
        end
      end
    end
  end
end
