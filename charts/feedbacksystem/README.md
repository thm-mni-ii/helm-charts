# Feedbacksystem Helm Chart

Official Helm Chart for installing the **Feedbacksystem (FBS 2.0)** on a [Kubernetes](https://kubernetes.io/) cluster.

## Architecture Overview

Feedbacksystem 2.0 uses a microservice and micro-frontend architecture:
- **`web-shell`** (Vue 3 / Vuetify): Central portal, dynamic navbar, iframe host, app management, and user management.
- **`identity-service`** (Spring Boot 3 / Kotlin): Central Identity Provider (IdP), OIDC/OAuth2 server, GraphQL User Management API, and SAML 2.0 SP federation.
- **`course-management-web`** (Angular): Course and task management frontend (embedded in web shell).
- **`sql-playground-web`** (Angular): Interactive database sandbox frontend (embedded in web shell).
- **`core`** (Spring Boot): Backend API for courses, tasks, submissions, and grading.
- **`runner`** (Vert.x / DinD): Code and SQL evaluation sandbox.
- **`eat`** (Dash / Python): Learning Analytics dashboard.
- **`collab`** (Node.js): Real-time collaborative editor backend.
- **`qcm`** (Node.js / Vue): Quiz and question catalog management backend & frontend.

---

## Chart Installation

### Requirements

- A Kubernetes Cluster (1.23+)
- [kubectl](https://kubernetes.io/docs/tasks/tools/)
- [helm](https://helm.sh/docs/intro/install/) (v3.10+)
- [deno](https://deno.land/manual/getting_started/installation) (optional, for script-based values generation)
- [keytool / OpenSSL](https://docs.oracle.com/en/java/javase/17/docs/specs/man/keytool.html) (for OIDC signing keystore generation)

### Initial Setup Steps

#### 1. Generate OIDC Signing Keystore

The `fbs-identity-service` signs JWT access/ID tokens using an RSA-4096 key pair stored in a PKCS#12 keystore:

```bash
keytool -genkeypair \
  -alias identity-signing \
  -keyalg RSA \
  -keysize 4096 \
  -storetype PKCS12 \
  -keystore identity-signing-key.p12 \
  -storepass changeit \
  -keypass changeit \
  -dname "CN=fbs-identity, OU=Feedbacksystem, O=THM, C=DE" \
  -validity 3650
```

Create a Kubernetes secret containing the keystore:
```bash
kubectl create secret generic fbs-identity-signing-key \
  --from-file=identity-signing-key.p12=./identity-signing-key.p12 \
  --namespace <namespace>
```

#### 2. Generate Values

Generate a customized values file using the Deno script:
```bash
deno run --reload=https://raw.githubusercontent.com --allow-write=vals.yaml \
  https://raw.githubusercontent.com/thm-mni-ii/helm-charts/main/charts/feedbacksystem/generate-values.ts vals.yaml
```

Set `identity.config.signingKey.existingSecret: "fbs-identity-signing-key"` in `vals.yaml`.

#### 3. Install Chart

```bash
helm repo add thm-mni-ii https://thm-mni-ii.github.io/helm-charts
helm install my-feedbacksystem thm-mni-ii/feedbacksystem -f vals.yaml --namespace <namespace> --create-namespace
```

#### 4. Bootstrap the Initial Administrator Account

Once MySQL and Identity Service are healthy, insert the initial administrator account into `fbs_identity.user`:

```bash
kubectl exec -i -n <namespace> deployment/my-feedbacksystem-mysql -- mysql -u root -p<ROOT_PASSWORD> fbs_identity <<'EOF'
INSERT IGNORE INTO `user`
  (`user_id`, `prename`, `surname`, `email`, `password`, `username`, `privacy_checked`, `deleted`, `alias`, `global_role`)
VALUES
  (1, 'System', 'Administrator', 'admin@example.org',
   '$2y$10$W7tXl9/M7FC8EwxYn9UU7.3/rgWUGCODhsqInUxPJwYEZNzogxPF2',
   'admin', 1, 0, 'sysadmin', 0);
EOF
```
*(Default credentials: `admin` / `admin123`)*

---

## Parameters

### Common

| Parameter              | Description       | Default              |
| ---------------------- | ----------------- | -------------------- |
| common.config.protocol | The Used Protocol | https:               |
| common.config.hostname | The Used Hostname | feedback.example.org |
| common.config.port     | The Used Port     | 443                  |

### Web Shell (Main Frontend Portal)

| Parameter                        | Description                                     | Default                   |
| -------------------------------- | ----------------------------------------------- | ------------------------- |
| webShell.enabled                 | Enable Web Shell portal                         | true                      |
| webShell.image.registry          | Docker registry for Web Shell                   | ghcr.io                   |
| webShell.image.name              | Image name for Web Shell                        | thm-mni-ii/fbs-web-shell  |
| webShell.image.tag               | Image tag for Web Shell                         | ""                        |
| webShell.image.pullPolicy        | Pull policy for Web Shell                       | IfNotPresent              |
| webShell.resources.cpu.request   | CPU request                                     | 0.01                      |
| webShell.resources.cpu.limit     | CPU limit                                       | 1                         |
| webShell.resources.memory.request| Memory request                                  | 50Mi                      |
| webShell.resources.memory.limit  | Memory limit                                    | 500Mi                     |
| webShell.ingress.enabled         | Enable standard Kubernetes Ingress for portal   | false                     |
| webShell.ingress.className       | Ingress class name                              | ""                        |
| webShell.ingress.annotations     | Ingress annotations                             | {}                        |
| webShell.ingress.hosts           | Custom Ingress host & path rules                | []                        |
| webShell.ingress.tls             | TLS configurations for Ingress                  | []                        |
| webShell.ingressRoute.enabled    | Enable Traefik IngressRoute for root portal     | false                     |

### Identity Service (OIDC & SAML Auth)

| Parameter                                            | Description                                          | Default                          |
| ---------------------------------------------------- | ---------------------------------------------------- | -------------------------------- |
| identity.enabled                                     | Enable Identity Service                              | true                             |
| identity.image.registry                              | Docker registry for Identity Service                 | ghcr.io                          |
| identity.image.name                                  | Image name for Identity Service                      | thm-mni-ii/fbs-identity-service  |
| identity.image.tag                                   | Image tag for Identity Service                       | ""                               |
| identity.image.pullPolicy                            | Pull policy for Identity Service                     | IfNotPresent                     |
| identity.resources.cpu.request                       | CPU request                                          | 0.1                              |
| identity.resources.cpu.limit                         | CPU limit                                            | 2                                |
| identity.resources.memory.request                    | Memory request                                       | 250Mi                            |
| identity.resources.memory.limit                      | Memory limit                                         | 4Gi                              |
| identity.config.saml.enabled                         | Enable SAML 2.0 authentication                       | false                            |
| identity.config.oidc.issuer                          | OIDC Issuer URL (defaults to common host)            | ""                               |
| identity.config.oidc.clientId                        | Web Shell OIDC Client ID                             | fbs-web-shell                    |
| identity.config.oidc.redirectUris                    | Allowed redirect URIs                                | []                               |
| identity.config.oidc.postLogoutRedirectUris          | Allowed post-logout redirect URIs                     | []                               |
| identity.config.oidc.accessTokenTtlMinutes           | Access token TTL in minutes                          | 15                               |
| identity.config.oidc.authCodeTtlMinutes              | Auth code TTL in minutes                             | 5                                |
| identity.config.signingKey.existingSecret            | Existing secret containing identity signing keystore | ""                               |
| identity.config.signingKey.keystore                  | Base64 encoded `.p12` keystore (if not using secret) | ""                               |
| identity.config.signingKey.storePassword             | Keystore store password                              | changeit                         |
| identity.config.signingKey.alias                     | Key pair alias in keystore                           | identity-signing                 |
| identity.config.signingKey.keyPassword               | Key password                                         | changeit                         |
| identity.config.antiBruteForce.maxFailuresPerIp      | Max login failures per IP before blocking            | 150                              |
| identity.config.antiBruteForce.maxFailuresPerIpUser  | Max login failures per user/IP combination           | 15                               |
| identity.config.antiBruteForce.windowSeconds         | Rate limit evaluation window in seconds              | 600                              |
| identity.config.antiBruteForce.trustedProxies        | Number of upstream reverse proxies                   | 0                                |
| identity.config.antiBruteForce.allowList             | Array of exempt CIDRs / IPs                          | []                               |
| identity.ingress.enabled                             | Enable standard Kubernetes Ingress for Identity      | false                            |
| identity.ingress.className                           | Ingress class name                                   | ""                               |
| identity.ingress.annotations                         | Ingress annotations                                  | {}                               |
| identity.ingress.hosts                               | Custom Ingress host & path rules                     | []                               |
| identity.ingress.tls                                 | TLS configurations for Ingress                       | []                               |
| identity.ingressRoute.enabled                        | Enable Traefik IngressRoute for Identity Service     | false                            |

### Course Management Web (Micro-Frontend)

| Parameter                                      | Description                                       | Default                   |
| ---------------------------------------------- | ------------------------------------------------- | ------------------------- |
| courseManagementWeb.enabled                    | Enable Course Management Web                      | true                      |
| courseManagementWeb.image.registry             | Docker registry                                   | ghcr.io                   |
| courseManagementWeb.image.name                 | Image name                                        | thm-mni-ii/fbs-core-web   |
| courseManagementWeb.image.tag                  | Image tag                                         | ""                        |
| courseManagementWeb.image.pullPolicy           | Pull policy                                       | IfNotPresent              |
| courseManagementWeb.ingress.enabled            | Enable standard Kubernetes Ingress                | false                     |
| courseManagementWeb.ingress.className          | Ingress class name                                | ""                        |
| courseManagementWeb.ingress.annotations        | Ingress annotations                               | {}                        |
| courseManagementWeb.ingress.pathPrefix         | Path prefix for routing                           | /course-management        |
| courseManagementWeb.ingress.hosts              | Custom Ingress host & path rules                  | []                        |
| courseManagementWeb.ingress.tls                | TLS configurations for Ingress                    | []                        |
| courseManagementWeb.ingressRoute.enabled       | Enable IngressRoute                               | false                     |
| courseManagementWeb.ingressRoute.pathPrefix    | Path prefix for routing                           | /course-management        |

### SQL Playground Web (Micro-Frontend)

| Parameter                                  | Description                                           | Default                          |
| ------------------------------------------ | ----------------------------------------------------- | -------------------------------- |
| sqlPlaygroundWeb.enabled                   | Enable SQL Playground Web                             | true                             |
| sqlPlaygroundWeb.image.registry            | Docker registry                                       | ghcr.io                          |
| sqlPlaygroundWeb.image.name                | Image name                                            | thm-mni-ii/fbs-sql-playground-web|
| sqlPlaygroundWeb.image.tag                 | Image tag                                             | ""                               |
| sqlPlaygroundWeb.image.pullPolicy          | Pull policy                                           | IfNotPresent                     |
| sqlPlaygroundWeb.ingress.enabled           | Enable standard Kubernetes Ingress                    | false                            |
| sqlPlaygroundWeb.ingress.className         | Ingress class name                                    | ""                               |
| sqlPlaygroundWeb.ingress.annotations       | Ingress annotations                                   | {}                               |
| sqlPlaygroundWeb.ingress.pathPrefix        | Path prefix for routing                               | /sql-playground                  |
| sqlPlaygroundWeb.ingress.hosts             | Custom Ingress host & path rules                      | []                               |
| sqlPlaygroundWeb.ingress.tls               | TLS configurations for Ingress                        | []                               |
| sqlPlaygroundWeb.ingressRoute.enabled      | Enable IngressRoute                                   | false                            |
| sqlPlaygroundWeb.ingressRoute.pathPrefix   | Path prefix for routing                               | /sql-playground                  |

### Core API

| Parameter                                | Description                                | Default                          |
| ---------------------------------------- | ------------------------------------------ | -------------------------------- |
| core.enabled                             | Enable Core API backend                    | true                             |
| core.image.registry                      | Docker registry for Core                   | ghcr.io                          |
| core.image.name                          | Docker image name for Core                 | thm-mni-ii/fbs-core              |
| core.image.tag                           | Docker image tag for Core                  | ""                               |
| core.image.pullPolicy                    | Image pull policy for Core                 | IfNotPresent                     |
| core.volumes.config.size                 | Size of config volume                      | 8G                               |
| core.volumes.config.mode                 | Access mode for config volume              | ReadWriteOnce                    |
| core.volumes.uploadDir.size              | Size of upload directory volume            | 16G                              |
| core.volumes.uploadDir.mode              | Access mode for upload directory volume    | ReadWriteOnce                    |
| core.resources.cpu.request               | CPU request                                | 0.1                              |
| core.resources.cpu.limit                 | CPU limit                                  | 2                                |
| core.resources.memory.request            | Memory request                             | 250Mi                            |
| core.resources.memory.limit              | Memory limit                               | 4Gi                              |
| core.config.jwtSecret                    | Legacy JWT Secret                          | 2edb8793d987389e1626918e0ec1dbee |
| core.config.id.salt                      | Salt used for ID generation                | fbs-helm-chart-salt              |
| core.config.sqlPlaygroundShare.publicHost| Public host for SQL playground sharing     | 127.0.0.1                        |
| core.config.sqlPlaygroundShare.publicPort| Public port for SQL playground sharing     | 4321                             |
| core.ingress.enabled                     | Enable standard Kubernetes Ingress for Core API | false                            |
| core.ingress.className                   | Ingress class name                              | ""                               |
| core.ingress.annotations                 | Ingress annotations                             | {}                               |
| core.ingress.servicePort                 | Service port to target (443 or 80)              | 443                              |
| core.ingress.hosts                       | Custom Ingress host & path rules                | []                               |
| core.ingress.tls                         | TLS configurations for Ingress                  | []                               |
| core.ingressRoute.enabled                | Enable IngressRoute for Core API           | false                            |

### Runner

| Parameter                                   | Description                                       | Default                              |
| ------------------------------------------- | ------------------------------------------------- | ------------------------------------ |
| runner.enabled                              | Enable Runner execution service                   | true                                 |
| runner.image.registry                       | Docker registry for Runner                        | ghcr.io                              |
| runner.image.name                           | Docker image name for Runner                      | thm-mni-ii/fbs-runner                |
| runner.image.tag                            | Docker image tag for Runner                       | ""                                   |
| runner.image.pullPolicy                     | Image pull policy for Runner                      | IfNotPresent                         |
| runner.resources.cpu.request                | CPU request                                       | 0.1                                  |
| runner.resources.cpu.limit                  | CPU limit                                         | 2                                    |
| runner.resources.memory.request             | Memory request                                    | 250Mi                                |
| runner.resources.memory.limit               | Memory limit                                      | 4Gi                                  |
| runner.config.hmacSecret                    | Secret used to generate HMACs for Database Users  | fbs                                  |
| runner.config.debug.disableContainerRemoval | Keep spawned containers after execution           | false                                |
| runner.sqlChecker.enabled                   | Enable SQL Checker                                | true                                 |
| runner.sqlChecker.image                     | Docker image for SQL Checker                      | ghcr.io/thm-mni-ii/fbs-sql-checker:latest |
| runner.bashChecker.image                    | Docker image for Bash Checker                     | ghcr.io/thm-mni-ii/fbs-runtime-bash:latest|

### Learning Analytics (EAT)

| Parameter                          | Description                               | Default                          |
| ---------------------------------- | ----------------------------------------- | -------------------------------- |
| eat.enabled                        | Enable Analytics Dashboard                | false                            |
| eat.image.registry                 | Docker registry for EAT                   | ghcr.io                          |
| eat.image.name                     | Docker image name for EAT                 | thm-mni-ii/fbs-eat               |
| eat.image.tag                      | Docker image tag for EAT                  | ""                               |
| eat.config.sessionSecret           | Session encryption secret                 | fbs                              |
| eat.ingress.enabled                | Enable standard Kubernetes Ingress for EAT | false                            |
| eat.ingress.className              | Ingress class name                        | ""                               |
| eat.ingress.annotations            | Ingress annotations                       | {}                               |
| eat.ingress.hosts                  | Custom Ingress host & path rules          | []                               |
| eat.ingress.tls                    | TLS configurations for Ingress            | []                               |
| eat.ingressRoute.enabled           | Enable IngressRoute for EAT               | false                            |

### Collaboration (Collab)

| Parameter                          | Description                               | Default                          |
| ---------------------------------- | ----------------------------------------- | -------------------------------- |
| collab.enabled                     | Enable real-time collab backend           | true                             |
| collab.image.registry              | Docker registry for Collab                | ghcr.io                          |
| collab.image.name                  | Docker image name for Collab              | thm-mni-ii/fbs-collab            |
| collab.ingress.enabled             | Enable standard Kubernetes Ingress for Collab | false                         |
| collab.ingress.className           | Ingress class name                        | ""                               |
| collab.ingress.annotations         | Ingress annotations                       | {}                               |
| collab.ingress.hosts               | Custom Ingress host & path rules          | []                               |
| collab.ingress.tls                 | TLS configurations for Ingress            | []                               |
| collab.ingressRoute.enabled        | Enable IngressRoute for Collab            | false                            |

### QCM (Quiz & Catalog Management)

| Parameter                          | Description                               | Default                          |
| ---------------------------------- | ----------------------------------------- | -------------------------------- |
| qcm.enabled                        | Enable QCM                                | true                             |
| qcm.backend.image.name             | Image name for QCM Backend                | thm-mni-ii/fbs-qcm-backend       |
| qcm.frontend.image.name            | Image name for QCM Frontend               | thm-mni-ii/fbs-qcm-frontend      |
| qcm.ingress.enabled                | Enable standard Kubernetes Ingress for QCM | false                            |
| qcm.ingress.className              | Ingress class name                        | ""                               |
| qcm.ingress.annotations            | Ingress annotations                       | {}                               |
| qcm.ingress.hosts                  | Custom Ingress host & path rules          | []                               |
| qcm.ingress.tls                    | TLS configurations for Ingress            | []                               |
| qcm.ingressRoute.enabled           | Enable IngressRoute for QCM              | false                            |

### Databases

| Parameter                          | Description                               | Default                          |
| ---------------------------------- | ----------------------------------------- | -------------------------------- |
| mysql.auth.database                | Core Database name                        | fbs                              |
| mysql.auth.username                | MySQL User                                | fbs                              |
| mysql.auth.password                | MySQL Password                            | fbs                              |
| mysql.auth.rootPassword            | MySQL Root Password                       | root                             |
| minio.auth.rootPassword            | MinIO Root Password                       | fbs-12345678                     |
