# Design Notes

This document sketches out the design for the `matsuri-traefik` plugin.

## Design Considerations

### Command-line interface

```
bin/matsuri staging apply traefik/middleware redirect_to_https
bin/matsuri staging apply traefik/tls_option tls12
bin/matsuri staging apply traefik/ingress_route api
bin/matsuri staging apply traefik/ingress_route auth
bin/matsuri staging apply traefik/service auth
```

I thought about creating a sub resources with crd like so:

```
bin/matsuri staging apply crd middleware redirect_to_https
bin/matsuri staging apply crd tls_option tls12
bin/matsuri staging apply crd ingress_route api
bin/matsuri staging apply crd ingress_route auth
```

However, semantically, I think we don't care that it is a CRD. We care more
about the resource we are controlling.

I had also thought about using non-namespaced resource names:

```
bin/matsuri staging apply middleware redirect_to_https
bin/matsuri staging apply tls_option tls12
bin/matsuri staging apply ingress_route api
bin/matsuri staging apply ingress_route auth
bin/matsuri staging apply traefik_service auth
```

Presumably, the engineer would know that the Traefik CRDs have been installed, and
that we would not install CRDs with competing names.

### File locations

Examples:

```
platform/traefix/middlewares/redirect_to_https.rb
platform/traefix/tls_options/tls12.rb
platform/traefix/ingress_routes/api.rb
platform/traefix/ingress_routes/staging/api.rb
platform/traefix/services/auth.rb
```

I had also considered using a DSL-style, so that middleware can
be created all in a group. However, there is no easy way to reconcile
the whole lot together, and we already have a notion of "bundling" these
things together in the form of "apps" in Matsuri.

### Resources

https://docs.traefik.io/routing/providers/kubernetes-crd/

#### IngressRoute

https://docs.traefik.io/routing/providers/kubernetes-crd/#kind-ingressroute

```
# Example yaml
apiVersion: traefik.containo.us/v1alpha1
kind: IngressRoute
metadata:
  name: foo
  namespace: bar
spec:
  entryPoints:                      # [1]
    - foo
  routes:                           # [2]
  - kind: Rule
    match: Host(`test.example.com`) # [3]
    priority: 10                    # [4]
    middlewares:                    # [5]
    - name: middleware1             # [6]
      namespace: default            # [7]
    services:                       # [8]
    - kind: Service
      name: foo
      namespace: default
      passHostHeader: true
      port: 80
      responseForwarding:
        flushInterval: 1ms
      scheme: https
      sticky:
        cookie:
          httpOnly: true
          name: cookie
          secure: true
          sameSite: none
      strategy: RoundRobin
      weight: 10
  tls:                              # [9]
    secretName: supersecret         # [10]
    options:                        # [11]
      name: opt                     # [12]
      namespace: default            # [13]
    certResolver: foo               # [14]
    domains:                        # [15]
    - main: example.net             # [16]
      sans:                         # [17]
      - a.example.net
      - b.example.net

```

#### Example DSL

```
Matsuri.define :traefik_tls_option, "opt" do
  let(:min_version) { "VersionTLS13" }
  let(:max_version) { "VersionTLS13" }

  let(:client_auth) do
    client_auth_config "RequireAndVerifyClientCert",
      ca_files: %W[
        tests/clientca1.crt
        tests/clientca2.crt
      ]
  end

  let(:cipher_suites) do
    %W[
      TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
    ]
  end
end
```

```
Matsuri.define :traefik_ingress_route, "main_platform" do
  let(:entry_points) { %w[foo] }
  let(:routes) { [test_example_route] }


  let(:test_example_route) do
    rule "Host('test.example.com')",
      priority: 10,
      middlewares: [ middleware('middleware1', namespace: 'default') ],
      services: [foo_service]
  end

  let(:tls) do
    tls_config secretName: 'super_secret',
               options: tls_option('opt', namespace: 'default'),
               certResolver: 'foo',
               domains: [
                 tls_domain('example.net', sans: %w[a.example.net b.example.net])
               ]
  end



  let(:foo_service) do
    k8s_service 'foo',
      namespace: 'default',
      pass_host_header: true,
      port: 80,
      response_forwarding: { flushInterval: '1ms' },
      scheme: 'https',
      sticky: cookie('cookie', http_only: true, secure: true, same_site: 'none'),
      strategy: 'RoundRobin',
      weight: 10
  end
end
```

### Installing

```
# Traefik 1.7
Matsuri.define :pod, 'traefik-ingress-controller' do
  include Matsuri::Traefik::Manifests::Pods::IngressController_1_7
end
```

```
# Traefik 2.2
Matsuri.define :pod, 'traefik-ingress-controller' do
  include Matsuri::Traefik::Manifests::Pods::IngressController_2_2
end
```

