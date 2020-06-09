# requiring this file will automaticaly monkeypatch the matsuri command line tooling
# and support the Traefik CRD
require 'active_support/concern'
require 'matsuri'

module Matsuri
  module Traefik
    module Cmd

      module Create
        extend ActiveSupport::Concern

        desc 'traefik/ingress_route NAME', 'create an ingress_route'
        create_cmd_for 'traefik/ingress_route'
        # map sts: :stateful_set
      end

      module Show
        extend ActiveSupport::Concern

        desc 'traefik/ingress_route NAME', 'show an ingress_route'
        show_cmd_for 'traefik/ingress_route'
      end
    end
  end
end

Matsuri::Cmd::Show.send(:include, Matsuri::Traefik::Cmd::Show)




