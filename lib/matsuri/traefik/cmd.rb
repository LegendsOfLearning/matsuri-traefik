# requiring this file will automaticaly monkeypatch the matsuri command line tooling
# and support the Traefik CRD
require 'active_support/concern'
require 'matsuri'

module Matsuri
  module Traefik
    module Cmd

      module Create
        extend ActiveSupport::Concern

        included do
          desc 'traefik/ingress_route NAME', 'create an ingress_route'
          create_cmd_for 'traefik_ingress_route'
          map "traefik/ingress-route" => :traefik_ingress_route
          # map sts: :stateful_set
        end
      end

      module Show
        extend ActiveSupport::Concern

        included do
          desc 'traefik/ingress_route NAME', 'show an ingress_route'
          show_cmd_for 'traefik_ingress_route'
          map "traefik/ingress-route" => :traefik_ingress_route
        end
      end
    end
  end
end

Matsuri::Cmds::Show.send(:include, Matsuri::Traefik::Cmd::Show)




