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
          desc 'traefik/ingress_route NAME', 'apply an ingress_route'
          apply_cmd_for 'traefik_ingress_route'
          map "traefik/ingress_route" => :traefik_ingress_route
          map "traefik/ingress-route" => :traefik_ingress_route

          desc 'traefik/middleware NAME', 'apply a middleware'
          apply_cmd_for 'traefik_middleware'
          map "traefik/middleware" => :traefik_middleware

          desc 'traefik/tls_option NAME', 'apply a tls_option'
          apply_cmd_for 'traefik_tls_option'
          map "traefik/tls_option" => :traefik_tls_option
          map "traefik/tls-option" => :traefik_tls_option
        end
      end

      module Create
        extend ActiveSupport::Concern

        included do
          desc 'traefik/ingress_route NAME', 'create an ingress_route'
          create_cmd_for 'traefik_ingress_route'
          map "traefik/ingress_route" => :traefik_ingress_route
          map "traefik/ingress-route" => :traefik_ingress_route

          desc 'traefik/middleware NAME', 'create a middleware'
          create_cmd_for 'traefik_middleware'
          map "traefik/middleware" => :traefik_middleware

          desc 'traefik/tls_option NAME', 'create a tls_option'
          create_cmd_for 'traefik_tls_option'
          map "traefik/tls_option" => :traefik_tls_option
          map "traefik/tls-option" => :traefik_tls_option
        end
      end

      module Show
        extend ActiveSupport::Concern

        included do
          desc 'traefik/ingress_route NAME', 'show an ingress_route'
          show_cmd_for 'traefik_ingress_route'
          map "traefik/ingress_route" => :traefik_ingress_route
          map "traefik/ingress-route" => :traefik_ingress_route

          desc 'traefik/middleware NAME', 'show a middleware'
          show_cmd_for 'traefik_middleware'
          map "traefik/middleware" => :traefik_middleware

          desc 'traefik/tls_option NAME', 'show a tls_option'
          show_cmd_for 'traefik_tls_option'
          map "traefik/tls_option" => :traefik_tls_option
          map "traefik/tls-option" => :traefik_tls_option
        end
      end

      module Delete
        extend ActiveSupport::Concern

        included do
          desc 'traefik/ingress_route NAME', 'delete an ingress_route'
          delete_cmd_for 'traefik_ingress_route'
          map "traefik/ingress_route" => :traefik_ingress_route
          map "traefik/ingress-route" => :traefik_ingress_route

          desc 'traefik/middleware NAME', 'delete a middleware'
          delete_cmd_for 'traefik_middleware'
          map "traefik/middleware" => :traefik_middleware

          desc 'traefik/tls_option NAME', 'delete a tls_option'
          delete_cmd_for 'traefik_tls_option'
          map "traefik/tls_option" => :traefik_tls_option
          map "traefik/tls-option" => :traefik_tls_option
        end
      end

      module Diff
        extend ActiveSupport::Concern

        included do
          desc 'traefik/ingress_route NAME', 'diff an ingress_route'
          diff_cmd_for 'traefik_ingress_route'
          map "traefik/ingress_route" => :traefik_ingress_route
          map "traefik/ingress-route" => :traefik_ingress_route

          desc 'traefik/middleware NAME', 'diff a middleware'
          diff_cmd_for 'traefik_middleware'
          map "traefik/middleware" => :traefik_middleware

          desc 'traefik/tls_option NAME', 'diff a tls_option'
          diff_cmd_for 'traefik_tls_option'
          map "traefik/tls_option" => :traefik_tls_option
          map "traefik/tls-option" => :traefik_tls_option
        end
      end

      module Recreate
        extend ActiveSupport::Concern

        included do
          desc 'traefik/ingress_route NAME', 'recreate an ingress_route'
          recreate_cmd_for 'traefik_ingress_route'
          map "traefik/ingress_route" => :traefik_ingress_route
          map "traefik/ingress-route" => :traefik_ingress_route

          desc 'traefik/middleware NAME', 'recreate a middleware'
          recreate_cmd_for 'traefik_middleware'
          map "traefik/middleware" => :traefik_middleware

          desc 'traefik/tls_option NAME', 'recreate a tls_option'
          recreate_cmd_for 'traefik_tls_option'
          map "traefik/tls_option" => :traefik_tls_option
          map "traefik/tls-option" => :traefik_tls_option
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
