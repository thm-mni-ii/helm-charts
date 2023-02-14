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

| Parameter             | Description                     | Default                          |
| --------------------- | ------------------------------- | -------------------------------- |
| core.enabled          | Should the Container be Enabled | true                             |
| core.config.jwtSecret | The Used JWT Secret             | 2edb8793d987389e1626918e0ec1dbee |

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

#### Runner

| Parameter                                   | Description                                                                                           | Default |
| ------------------------------------------- | ----------------------------------------------------------------------------------------------------- | ------- |
| runner.enabled                              | Should the Container be Enabled                                                                       | true    |
| runner.config.hmacSecret                    | Secret Used to Generate hmacs for Database Users                                                      | fbs     |
| runner.config.debug.disableContainerRemoval | Determines whether the spawned Docker container that is used for a check should be kept after its use | false   |

#### Digital Classroom

| Parameter                          | Description                                                  | Default                          |
| ---------------------------------- | ------------------------------------------------------------ | -------------------------------- |
| digitalClassroom.enabled           | Should the Container be Enabled                              | false                            |
| digitalClassroom.config.jwtSecret  | The Used JWT Secret for the Digital Classroom                | 2edb8793d987389e1626918e0ec1dbee |
| digitalClassroom.config.secret     | Secret used to interact with the Digital Classroom           | 1f2a08f5dbd81580a6fb0f645dce3737 |
| digitalClassroom.config.bbb.url    | URL to the BigBlueButton Sever that should be used           | https://bbb.example.org          |
| digitalClassroom.config.bbb.secret | Secret for the Configured BigBlueButton Server               | 1234                             |
| digitalClassroom.config.path       | The Path under which the digital classroom will be available | /digitalclassroom                |

#### Mysql

| Parameter                       | Description                                         | Default   |
| ------------------------------- | --------------------------------------------------- | --------- |
| mysql.auth.database             | The name of the Database                            | fbs       |
| mysql.auth.username             | The name of the Database User                       | fbs       |
| mysql.auth.password             | The Password of the Database User                   | fbs       |
| mysql.auth.rootPassword         | The Password of the Database Root User              | root      |
| mysql.primray.existingConfigmap | The name of an existing ConfigMap containg `my.cnf` | CHANGE-ME |

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

#### Checker Mongodb

| Parameter                        | Description                            | Default |
| -------------------------------- | -------------------------------------- | ------- |
| checkerMongodb.auth.database     | The name of the Database               | fbs     |
| checkerMongodb.auth.username     | The name of the Database User          | fbs     |
| checkerMongodb.auth.password     | The Password of the Database User      | fbs     |
| checkerMongodb.auth.rootPassword | The Password of the Database Root User | root    |

#### Minio

| Parameter               | Description                    | Default      |
| ----------------------- | ------------------------------ | ------------ |
| minio.auth.rootPassword | The Password of the Minio User | fbs-12345678 |

## License

[Apache-2.0 © 2023 Technischen Hochschule Mittelhessen](https://github.com/thm-mni-ii/feedbacksystem/blob/main/LICENSE)
