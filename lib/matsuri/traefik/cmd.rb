# requiring this file will automaticaly monkeypatch the matsuri command line tooling
# and support the Traefik CRD
require 'active_support/concern'
require 'matsuri'

module Matsuri
  module Traefik
    module Cmd
      module Apply
        extend ActiveSupport::Concern

        included do
          desc 'traefik/ingress_route NAME', 'appy an ingress_route'
          apply_cmd_for 'traefik_ingress_route'
          map "traefik/ingress-route" => :traefik_ingress_route
        end
      end

      module Create
        extend ActiveSupport::Concern

        included do
          desc 'traefik/ingress_route NAME', 'create an ingress_route'
          create_cmd_for 'traefik_ingress_route'
          map "traefik/ingress-route" => :traefik_ingress_route
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

      module Delete
        extend ActiveSupport::Concern

        included do
          desc 'traefik/ingress_route NAME', 'delete an ingress_route'
          delete_cmd_for 'traefik_ingress_route'
          map "traefik/ingress-route" => :traefik_ingress_route
        end
      end

      module Diff
        extend ActiveSupport::Concern

        included do
          desc 'traefik/ingress_route NAME', 'diff an ingress_route'
          diff_cmd_for 'traefik_ingress_route'
          map "traefik/ingress-route" => :traefik_ingress_route
        end
      end

      module Recreate
        extend ActiveSupport::Concern

        included do
          desc 'traefik/ingress_route NAME', 'recreate an ingress_route'
          recreate_cmd_for 'traefik_ingress_route'
          map "traefik/ingress-route" => :traefik_ingress_route
        end
      end
    end
  end
end

Matsuri::Cmds::Apply.send(:include, Matsuri::Traefik::Cmd::Apply)
Matsuri::Cmds::Create.send(:include, Matsuri::Traefik::Cmd::Create)
Matsuri::Cmds::Delete.send(:include, Matsuri::Traefik::Cmd::Delete)
Matsuri::Cmds::Recreate.send(:include, Matsuri::Traefik::Cmd::Recreate)
Matsuri::Cmds::Show.send(:include, Matsuri::Traefik::Cmd::Show)
Matsuri::Cmds::Diff.send(:include, Matsuri::Traefik::Cmd::Diff)




