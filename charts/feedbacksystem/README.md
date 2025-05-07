# Feedbackssystem Helm Chart

Official Helm Chart for Installing the [Feedbacksystem](https://github.com/thm-mni-ii/feedbacksystem) on a [Kubernetes](https://kubernetes.io/) cluster.

## Chart Installation

### Requirements

- A Kubernetes Cluster
- [kubectl](https://kubernetes.io/docs/tasks/tools/)
- [helm](https://helm.sh/docs/intro/install/)
- [deno](https://deno.land/manual/getting_started/installation)

### Steps

1. Ensure the requirements are met
2. Generate values (See [here](#script) for details) `deno run --reload=https://raw.githubusercontent.com --allow-write=vals.yaml https://raw.githubusercontent.com/thm-mni-ii/helm-charts/main/charts/feedbacksystem/generate-values.ts vals.yaml`
3. Add the helm repository `helm repo add thm-mni-ii https://thm-mni-ii.github.io/helm-charts`
4. Install `helm install my-feedbacksystem thm-mni-ii/feedbacksystem`

## Configuration

### Script

There is a [Deno](https://deno.land) script to generate the configuration file for this helm chart. It generates random values for all secrets to be changed and asks for configuration values.

- **Source:** [generate-values.ts](https://github.com/thm-mni-ii/helm-charts/blob/main/charts/feedbacksystem/generate-values.ts)
- **Usage:** `deno run --reload=https://raw.githubusercontent.com --allow-write=vals.yaml https://raw.githubusercontent.com/thm-mni-ii/helm-charts/main/charts/feedbacksystem/generate-values.ts vals.yaml`

### Parameters

#### Common

| Parameter              | Description       | Default              |
| ---------------------- | ----------------- | -------------------- |
| common.config.protocol | The Used Protocol | https:               |
| common.config.hostname | The Used Hostname | feedback.example.org |
| common.config.port     | The Used Port     | 443                  |

#### Core

| Parameter                                | Description                                | Default                          |
| ---------------------------------------- | ------------------------------------------ | -------------------------------- |
| core.enabled                             | Should the Container be Enabled            | true                             |
| core.image.registry                      | Docker registry for the Core image         | docker.io                        |
| core.image.name                          | Docker image name for Core                 | thmmniii/fbs-core                |
| core.image.tag                           | Docker image tag for Core                  | ""                               |
| core.image.pullPolicy                    | Image pull policy for Core                 | IfNotPresent                     |
| core.volumes.config.size                 | Size of the config volume                  | 8G                               |
| core.volumes.config.mode                 | Access mode for the config volume          | ReadWriteOnce                    |
| core.volumes.uploadDir.size              | Size of the upload directory volume        | 16G                              |
| core.volumes.uploadDir.mode              | Access mode for the upload directory volume| ReadWriteOnce                    |
| core.resources.cpu.request               | CPU request for Core                       | 0.1                              |
| core.resources.cpu.limit                 | CPU limit for Core                         | 2                                |
| core.resources.memory.request            | Memory request for Core                    | 250Mi                            |
| core.resources.memory.limit              | Memory limit for Core                      | 4Gi                              |
| core.config.jwtSecret                    | The Used JWT Secret                        | 2edb8793d987389e1626918e0ec1dbee |
| core.config.id.salt                      | Salt used for ID generation                | fbs-helm-chart-salt              |
| core.config.sqlPlaygroundShare.publicHost| Public host for SQL playground sharing     | 127.0.0.1                        |
| core.config.sqlPlaygroundShare.publicPort| Public port for SQL playground sharing     | 4321                             |
| core.ingressRoute.enabled                | Enable ingress for the core                | false                            |

#### LDAP

| Parameter                            | Description                                             | Default      |
| ------------------------------------ | ------------------------------------------------------- | ------------ |
| core.config.ldap.enabled             | Should ldap be enabled                                  | false        |
| core.config.ldap.allowLogn           | Allow authentication using ldap                         | false        |
| core.config.ldap.baseDn              | The base dn of the ldap server                          |              |
| core.config.ldap.url                 | The url of the ldap server                              |              |
| core.config.ldap.startTls            | Allow startTls when connecting to ldap                  |              |
| core.config.ldap.filter              | The filter to use to locate a user in ldap              | (uid={user}) |
| core.config.ldap.timeout             | The timeout for ldap requests                           | 5000         |
| core.config.ldap.bind.enabled        | Use bind authentication for ldap queries                | false        |
| core.config.ldap.bind.dn             | The dn to bind to                                       | ""           |
| core.config.ldap.bind.password       | The password to bind to                                 | ""           |
| core.config.ldap.attributeNames.uid  | The name of the ldap attribute to use as the user id    | uid          |
| core.config.ldap.attributeNames.sn   | The name of the ldap attribute to use as the last name  | sn           |
| core.config.ldap.attributeNames.name | The name of the ldap attribute to use as the first name | givenName    |
| core.config.ldap.attributeNames.mail | The name of the ldap attribute to use as the user mail  | mail         |

#### (External) Digital Classroom

| Parameter                           | Description                                                                                   | Default                          |
| ----------------------------------- | --------------------------------------------------------------------------------------------- | -------------------------------- |
| core.config.digitalClassroom.url    | The URL of the external classroom to use (Overwritten if digitalClassroom.enabled)            | https://bbb.feedback.example.org |
| core.config.digitalClassroom.secret | The secret of the external digital classroom to use (Overwritten if digitalClassroom.enabled) | 1234                             |

#### Anti-Brute-Force

| Parameter                                | Description                                | Default |
| ---------------------------------------- | ------------------------------------------ | ------- |
| core.config.antiBruteForce.trustedProxyCount | Number of trusted proxies in front of the service | 0 |
| core.config.antiBruteForce.interval     | Time interval in seconds for brute force detection | 600 |
| core.config.antiBruteForce.maxAttempts  | Maximum number of login attempts in the interval | 10 |
| core.config.antiBruteForce.allowList    | List of IPs that are exempt from brute force detection | [] |

#### Integrations

| Parameter                                | Description                                | Default |
| ---------------------------------------- | ------------------------------------------ | ------- |
| core.config.integrations.modelling.url   | URL to the modelling integration           | https://fbs-modelling.mni.thm.de/ |

#### Runner

| Parameter                                   | Description                                                                                           | Default |
| ------------------------------------------- | ----------------------------------------------------------------------------------------------------- | ------- |
| runner.enabled                              | Should the Container be Enabled                                                                       | true    |
| runner.image.registry                       | Docker registry for the Runner image                                                                  | docker.io |
| runner.image.name                           | Docker image name for Runner                                                                          | thmmniii/fbs-runner |
| runner.image.tag                            | Docker image tag for Runner                                                                           | "" |
| runner.image.pullPolicy                     | Image pull policy for Runner                                                                          | IfNotPresent |
| runner.resources.cpu.request                | CPU request for Runner                                                                                | 0.1 |
| runner.resources.cpu.limit                  | CPU limit for Runner                                                                                  | 2 |
| runner.resources.memory.request             | Memory request for Runner                                                                             | 250Mi |
| runner.resources.memory.limit               | Memory limit for Runner                                                                               | 4Gi |
| runner.config.hmacSecret                    | Secret Used to Generate hmacs for Database Users                                                      | fbs     |
| runner.config.debug.disableContainerRemoval | Determines whether the spawned Docker container that is used for a check should be kept after its use | false   |
| runner.sqlChecker.enabled                   | Enable SQL Checker                                                                                    | true |
| runner.sqlChecker.image                     | Docker image for SQL Checker                                                                          | thmmniii/fbs-sql-checker:latest |
| runner.bashChecker.image                    | Docker image for Bash Checker                                                                         | thmmniii/fbs-runtime-bash:latest |

#### Docker in Kubernetes (DINK)

| Parameter                                | Description                                | Default |
| ---------------------------------------- | ------------------------------------------ | ------- |
| runner.dink.image.registry               | Docker registry for the DINK image         | docker.io |
| runner.dink.image.name                   | Docker image name for DINK                 | library/docker |
| runner.dink.image.tag                    | Docker image tag for DINK                  | 20.10.21-dind |
| runner.dink.image.pullPolicy             | Image pull policy for DINK                 | IfNotPresent |
| runner.dink.volumes.images.size          | Size of the Docker images volume           | 16G |
| runner.dink.volumes.images.mode          | Access mode for the Docker images volume   | ReadWriteOnce |
| runner.dink.resources.cpu.request        | CPU request for DINK                       | 0.1 |
| runner.dink.resources.cpu.limit          | CPU limit for DINK                         | 2 |
| runner.dink.resources.memory.request     | Memory request for DINK                    | 100Mi |
| runner.dink.resources.memory.limit       | Memory limit for DINK                      | 4Gi |

#### Digital Classroom

| Parameter                          | Description                                                  | Default                          |
| ---------------------------------- | ------------------------------------------------------------ | -------------------------------- |
| digitalClassroom.enabled           | Should the Container be Enabled                              | false                            |
| digitalClassroom.internal          | Deploy an internal digital classroom                         | false                            |
| digitalClassroom.image.registry    | Docker registry for the Digital Classroom image              | ghcr.io                          |
| digitalClassroom.image.name        | Docker image name for Digital Classroom                      | thm-mni-ii/digital-classroom     |
| digitalClassroom.image.tag         | Docker image tag for Digital Classroom                       | v1.0.1                           |
| digitalClassroom.image.pullPolicy  | Image pull policy for Digital Classroom                      | IfNotPresent                     |
| digitalClassroom.resources.cpu.request | CPU request for Digital Classroom                        | 0.1                              |
| digitalClassroom.resources.cpu.limit | CPU limit for Digital Classroom                            | 2                                |
| digitalClassroom.resources.memory.request | Memory request for Digital Classroom                  | 250Mi                            |
| digitalClassroom.resources.memory.limit | Memory limit for Digital Classroom                      | 4Gi                              |
| digitalClassroom.config.jwtSecret  | The Used JWT Secret for the Digital Classroom                | 2edb8793d987389e1626918e0ec1dbee |
| digitalClassroom.config.secret     | Secret used to interact with the Digital Classroom           | 1f2a08f5dbd81580a6fb0f645dce3737 |
| digitalClassroom.config.bbb.url    | URL to the BigBlueButton Sever that should be used           | https://bbb.example.org          |
| digitalClassroom.config.bbb.secret | Secret for the Configured BigBlueButton Server               | 1234                             |
| digitalClassroom.config.path       | The Path under which the digital classroom will be available | /digitalclassroom                |

#### Eat

| Parameter                          | Description                                                  | Default                          |
| ---------------------------------- | ------------------------------------------------------------ | -------------------------------- |
| eat.enabled                        | Should the Container be Enabled                              | false                            |
| eat.image.registry                 | Docker registry for the EAT image                            | docker.io                        |
| eat.image.name                     | Docker image name for EAT                                    | thmmniii/fbs-eat                 |
| eat.image.tag                      | Docker image tag for EAT                                     | ""                               |
| eat.image.pullPolicy               | Image pull policy for EAT                                    | IfNotPresent                     |
| eat.resources.cpu.request          | CPU request for EAT                                          | 0.1                              |
| eat.resources.cpu.limit            | CPU limit for EAT                                            | 2                                |
| eat.resources.memory.request       | Memory request for EAT                                       | 250Mi                            |
| eat.resources.memory.limit         | Memory limit for EAT                                         | 4Gi                              |
| eat.config.sessionSecret           | The session secret used for eat                              | fbs                              |
| eat.ingressRoute.enabled           | Enable ingress for the eat                                   | false                            |

#### Collab

| Parameter                          | Description                                                  | Default                          |
| ---------------------------------- | ------------------------------------------------------------ | -------------------------------- |
| collab.enabled                     | Should the Container be Enabled                              | true                             |
| collab.image.registry              | Docker registry for the Collab image                         | docker.io                        |
| collab.image.name                  | Docker image name for Collab                                 | thmmniii/fbs-collab              |
| collab.image.tag                   | Docker image tag for Collab                                  | ""                               |
| collab.image.pullPolicy            | Image pull policy for Collab                                 | IfNotPresent                     |
| collab.resources.cpu.request       | CPU request for Collab                                       | 0.1                              |
| collab.resources.cpu.limit         | CPU limit for Collab                                         | 2                                |
| collab.resources.memory.request    | Memory request for Collab                                    | 50Mi                             |
| collab.resources.memory.limit      | Memory limit for Collab                                      | 1Gi                              |
| collab.ingressRoute.enabled        | Enable ingress for the Collab                                | false                            |

#### QCM (Question and Content Management)

| Parameter                          | Description                                                  | Default                          |
| ---------------------------------- | ------------------------------------------------------------ | -------------------------------- |
| qcm.enabled                        | Should the Container be Enabled                              | true                             |
| qcm.backend.image.registry         | Docker registry for the QCM Backend image                    | docker.io                        |
| qcm.backend.image.name             | Docker image name for QCM Backend                            | thmmniii/fbs-qcm-backend         |
| qcm.backend.image.tag              | Docker image tag for QCM Backend                             | ""                               |
| qcm.backend.image.pullPolicy       | Image pull policy for QCM Backend                            | IfNotPresent                     |
| qcm.backend.resources.cpu.request  | CPU request for QCM Backend                                  | 0.1                              |
| qcm.backend.resources.cpu.limit    | CPU limit for QCM Backend                                    | 2                                |
| qcm.backend.resources.memory.request | Memory request for QCM Backend                             | 50Mi                             |
| qcm.backend.resources.memory.limit | Memory limit for QCM Backend                                 | 1Gi                              |
| qcm.frontend.image.registry        | Docker registry for the QCM Frontend image                   | docker.io                        |
| qcm.frontend.image.name            | Docker image name for QCM Frontend                           | thmmniii/fbs-qcm-frontend        |
| qcm.frontend.image.tag             | Docker image tag for QCM Frontend                            | ""                               |
| qcm.frontend.image.pullPolicy      | Image pull policy for QCM Frontend                           | IfNotPresent                     |
| qcm.frontend.resources.cpu.request | CPU request for QCM Frontend                                 | 0.01                             |
| qcm.frontend.resources.cpu.limit   | CPU limit for QCM Frontend                                   | 1                                |
| qcm.frontend.resources.memory.request | Memory request for QCM Frontend                           | 50Mi                             |
| qcm.frontend.resources.memory.limit | Memory limit for QCM Frontend                               | 1Gi                              |
| qcm.ingressRoute.enabled           | Enable ingress for the QCM                                   | false                            |

#### Mysql

| Parameter                       | Description                                         | Default   |
| ------------------------------- | --------------------------------------------------- | --------- |
| mysql.auth.database             | The name of the Database                            | fbs       |
| mysql.auth.username             | The name of the Database User                       | fbs       |
| mysql.auth.password             | The Password of the Database User                   | fbs       |
| mysql.auth.rootPassword         | The Password of the Database Root User              | root      |
| mysql.auth.createDatabase       | Create the database                                 | true      |
| mysql.primary.existingConfigmap | The name of an existing ConfigMap containg `my.cnf` | {{ .Release.Name }}-mysql-config |

#### Runner Mysql

| Parameter                             | Description                                         | Default   |
| ------------------------------------- | --------------------------------------------------- | --------- |
| runnerMysql.auth.database             | The name of the Database                            | fbs       |
| runnerMysql.auth.username             | The name of the Database User                       | fbs       |
| runnerMysql.auth.password             | The Password of the Database User                   | fbs       |
| runnerMysql.auth.rootPassword         | The Password of the Database Root User              | root      |
| runnerMysql.primray.existingConfigmap | The name of an existing ConfigMap containg `my.cnf` | CHANGE-ME |

#### Runner Postgres

| Parameter                         | Description                            | Default |
| --------------------------------- | -------------------------------------- | ------- |
| runnerPostgres.auth.database      | The name of the Database               | fbs     |
| runnerPostgres.auth.username      | The name of the Database User          | fbs     |
| runnerPostgres.auth.password      | The Password of the Database User      | fbs     |
| runnerMysql.auth.postgresPassword | The Password of the Database Root User | root    |

#### Runner Playground Postgres

| Parameter                                      | Description                            | Default |
| ---------------------------------------------- | -------------------------------------- | ------- |
| runnerPlaygroundPostgres.auth.database         | The name of the Database               | fbs     |
| runnerPlaygroundPostgres.auth.username         | The name of the Database User          | fbs     |
| runnerPlaygroundPostgres.auth.password         | The Password of the Database User      | fbs     |
| runnerPlaygroundPostgres.auth.postgresPassword | The Password of the Database Root User | root    |

#### Playground Share Postgres

| Parameter                                | Description                            | Default |
| ---------------------------------------- | -------------------------------------- | ------- |
| playgroundSharePostgres.nameOverride     | Override the name of the deployment    | playground-share-postgres |
| playgroundSharePostgres.auth.database    | The name of the Database               | fbs     |
| playgroundSharePostgres.auth.username    | The name of the Database User          | fbs     |
| playgroundSharePostgres.auth.password    | The Password of the Database User      | fbs     |
| playgroundSharePostgres.auth.postgresPassword | The Password of the Database Root User | root    |

#### Checker Mongodb

| Parameter                        | Description                            | Default |
| -------------------------------- | -------------------------------------- | ------- |
| checkerMongodb.nameOverride      | Override the name of the deployment    | checker-mongodb |
| checkerMongodb.useStatefulSet    | Use a StatefulSet instead of Deployment| true    |
| checkerMongodb.auth.database     | The name of the Database               | fbs     |
| checkerMongodb.auth.username     | The name of the Database User          | fbs     |
| checkerMongodb.auth.password     | The Password of the Database User      | fbs     |
| checkerMongodb.auth.rootPassword | The Password of the Database Root User | root    |

#### QCM Mongodb

| Parameter                        | Description                            | Default |
| -------------------------------- | -------------------------------------- | ------- |
| qcmMongodb.nameOverride          | Override the name of the deployment    | qcm-mongodb |
| qcmMongodb.useStatefulSet        | Use a StatefulSet instead of Deployment| true    |
| qcmMongodb.auth.database         | The name of the Database               | fbs     |
| qcmMongodb.auth.username         | The name of the Database User          | fbs     |
| qcmMongodb.auth.password         | The Password of the Database User      | fbs     |
| qcmMongodb.auth.rootPassword     | The Password of the Database Root User | root    |

#### Minio

| Parameter               | Description                    | Default      |
| ----------------------- | ------------------------------ | ------------ |
| minio.auth.rootPassword | The Password of the Minio User | fbs-12345678 |

## License

[Apache-2.0 © 2023 Technischen Hochschule Mittelhessen](https://github.com/thm-mni-ii/feedbacksystem/blob/main/LICENSE)
