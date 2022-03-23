# -*- encoding: utf-8 -*-
# stub: matsuri-traefik 0.1.0 ruby lib

Gem::Specification.new do |s|
  s.name = "matsuri-traefik".freeze
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Ho-Sheng Hsiao".freeze]
  s.date = "1980-01-01"
  s.description = "Traefik CRD and controller definitions for Matsuri".freeze
  s.email = ["talktohosh@gmail.com".freeze]
  s.files = [".gitignore".freeze, "DESIGN.md".freeze, "LICENSE".freeze, "README.md".freeze, "lib/matsuri/traefik.rb".freeze, "lib/matsuri/traefik/cmd.rb".freeze, "lib/matsuri/traefik/k8s/ingress_route.rb".freeze, "lib/matsuri/traefik/k8s/middleware.rb".freeze, "lib/matsuri/traefik/k8s/tls_option.rb".freeze, "lib/matsuri/traefik/manifests/daemon_sets/ingress-controller.rb".freeze, "lib/matsuri/traefik/manifests/pods/ingress-controller-1-7.rb".freeze, "lib/matsuri/traefik/manifests/pods/ingress-controller-2-2.rb".freeze, "lib/matsuri/traefik/manifests/pods/ingress-controller-2-3.rb".freeze, "lib/matsuri/traefik/manifests/pods/ingress-controller-2-5.rb".freeze, "lib/matsuri/traefik/manifests/rbac.rb".freeze, "lib/matsuri/traefik/manifests/v2.2/crd.yaml".freeze, "lib/matsuri/traefik/manifests/v2.5/crd.yaml".freeze, "lib/matsuri/traefik/manifests/v2.5/ingressroute.yaml".freeze, "lib/matsuri/traefik/manifests/v2.5/ingressroutetcp.yaml".freeze, "lib/matsuri/traefik/manifests/v2.5/ingressrouteudp.yaml".freeze, "lib/matsuri/traefik/manifests/v2.5/middlewares.yaml".freeze, "lib/matsuri/traefik/manifests/v2.5/middlewarestcp.yaml".freeze, "lib/matsuri/traefik/manifests/v2.5/serverstransports.yaml".freeze, "lib/matsuri/traefik/manifests/v2.5/tlsoptions.yaml".freeze, "lib/matsuri/traefik/manifests/v2.5/tlsstores.yaml".freeze, "lib/matsuri/traefik/manifests/v2.5/traefikservices.yaml".freeze, "lib/matsuri/traefik/version.rb".freeze, "matsuri-traefik.gemspec".freeze]
  s.homepage = "https://github.com/matsuri-rb/matsuri-traefik".freeze
  s.rubygems_version = "3.2.26".freeze
  s.summary = "Traefik plugin for Matsuri".freeze

  s.installed_by_version = "3.2.26" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4
  end

  if s.respond_to? :add_runtime_dependency then
    s.add_runtime_dependency(%q<matsuri>.freeze, [">= 0"])
    s.add_development_dependency(%q<bundler>.freeze, ["~> 1.10"])
    s.add_development_dependency(%q<rake>.freeze, ["~> 10.0"])
    s.add_development_dependency(%q<rspec>.freeze, [">= 0"])
  else
    s.add_dependency(%q<matsuri>.freeze, [">= 0"])
    s.add_dependency(%q<bundler>.freeze, ["~> 1.10"])
    s.add_dependency(%q<rake>.freeze, ["~> 10.0"])
    s.add_dependency(%q<rspec>.freeze, [">= 0"])
  end
end
