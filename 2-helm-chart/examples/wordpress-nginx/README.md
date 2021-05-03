# WordPress

[WordPress](https://wordpress.org/) is one of the most versatile open source content management systems on the market. A publishing platform for building blogs and websites.

## TL;DR

```console
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install my-release bitnami/wordpress
```

## Introduction

This chart bootstraps a [WordPress](https://github.com/bitnami/bitnami-docker-wordpress) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

It also packages the [Bitnami MariaDB chart](https://github.com/bitnami/charts/tree/master/bitnami/mariadb) which is required for bootstrapping a MariaDB deployment for the database requirements of the WordPress application, and the [Bitnami Memcached chart](https://github.com/bitnami/charts/tree/master/bitnami/memcached) that can be used to cache database queries.

Bitnami charts can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters. This chart has been tested to work with NGINX Ingress, cert-manager, fluentd and Prometheus on top of the [BKPR](https://kubeprod.io/).

## Prerequisites

- Kubernetes 1.12+
- Helm 3.1.0
- PV provisioner support in the underlying infrastructure
- ReadWriteMany volumes for deployment scaling

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm install my-release bitnami/wordpress
```

The command deploys WordPress on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Parameters

The following table lists the configurable parameters of the WordPress chart and their default values per section/component:

### Global parameters

| Parameter                 | Description                                     | Default                                                 |
|---------------------------|-------------------------------------------------|---------------------------------------------------------|
| `global.imageRegistry`    | Global Docker image registry                    | `nil`                                                   |
| `global.imagePullSecrets` | Global Docker registry secret names as an array | `[]` (does not add image pull secrets to deployed pods) |
| `global.storageClass`     | Global storage class for dynamic provisioning   | `nil`                                                   |

### Common parameters

| Parameter           | Description                                                          | Default                        |
|---------------------|----------------------------------------------------------------------|--------------------------------|
| `nameOverride`      | String to partially override common.names.fullname                   | `nil`                          |
| `fullnameOverride`  | String to fully override common.names.fullname                       | `nil`                          |
| `clusterDomain`     | Default Kubernetes cluster domain                                    | `cluster.local`                |
| `commonLabels`      | Labels to add to all deployed objects                                | `{}`                           |
| `commonAnnotations` | Annotations to add to all deployed objects                           | `{}`                           |
| `kubeVersion`       | Force target Kubernetes version (using Helm capabilities if not set) | `nil`                          |
| `extraDeploy`       | Array of extra objects to deploy with the release                    | `[]` (evaluated as a template) |

### WordPress parameters

| Parameter                     | Description                                                                                                                                                                                                                      | Default                                                 |
|-------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|---------------------------------------------------------|
| `nginxImage.registry`         | NGINX image registry                                                                                                                                                                                                             | `docker.io`                                             |
| `nginxImage.repository`       | NGINX image name                                                                                                                                                                                                                 | `bitnami/wordpress`                                     |
| `nginxImage.tag`              | NGINX image tag                                                                                                                                                                                                                  | `{TAG_NAME}`                                            |
| `nginxImage.pullPolicy`       | NGINX image pull policy                                                                                                                                                                                                          | `IfNotPresent`                                          |
| `nginxImage.pullSecrets`      | Specify docker-registry secret names as an array                                                                                                                                                                                 | `[]` (does not add image pull secrets to deployed pods) |
| `nginxImage.debug`            | Specify if debug logs should be enabled                                                                                                                                                                                          | `false`                                                 |
| `wordpressImage.registry`     | WordPress image registry                                                                                                                                                                                                         | `docker.io`                                             |
| `wordpressImage.repository`   | WordPress image name                                                                                                                                                                                                             | `bitnami/wordpress`                                     |
| `wordpressImage.tag`          | WordPress image tag                                                                                                                                                                                                              | `{TAG_NAME}`                                            |
| `wordpressImage.pullPolicy`   | WordPress image pull policy                                                                                                                                                                                                      | `IfNotPresent`                                          |
| `wordpressImage.pullSecrets`  | Specify docker-registry secret names as an array                                                                                                                                                                                 | `[]` (does not add image pull secrets to deployed pods) |
| `wordpressImage.debug`        | Specify if debug logs should be enabled                                                                                                                                                                                          | `false`                                                 |
| `hostAliases`                 | Add deployment host aliases                                                                                                                                                                                                      | `Check values.yaml`                                     |
| `existingSecret`              | Name of the existing Wordpress Secret (it must contain a key named `wordpress-password`). When it's set, `wordpressPassword` is ignored                                                                                          | `nil`                                                   |
| `serviceAccountName`          | Name of a service account for the WordPress pods                                                                                                                                                                                 | `default`                                               |
| `allowEmptyPassword`          | Allow DB blank passwords                                                                                                                                                                                                         | `true`                                                  |
| `command`                     | Override default container command (useful when using custom images)                                                                                                                                                             | `nil`                                                   |
| `args`                        | Override default container args (useful when using custom images)                                                                                                                                                                | `nil`                                                   |
| `extraEnvVars`                | Extra environment variables to be set on WordPress container                                                                                                                                                                     | `{}`                                                    |
| `extraEnvVarsCM`              | Name of existing ConfigMap containing extra env vars                                                                                                                                                                             | `nil`                                                   |
| `extraEnvVarsSecret`          | Name of existing Secret containing extra env vars                                                                                                                                                                                | `nil`                                                   |

### WordPress deployment parameters

| Parameter                   | Description                                                                               | Default                              |
|-----------------------------|-------------------------------------------------------------------------------------------|--------------------------------------|
| `replicaCount`              | Number of WordPress Pods to run                                                           | `1`                                  |
| `containerPorts.http`       | HTTP port to expose at container level                                                    | `8080`                               |
| `containerPorts.https`      | HTTPS port to expose at container level                                                   | `8443`                               |
| `podSecurityContext`        | WordPress pods' Security Context                                                          | Check `values.yaml` file             |
| `containerSecurityContext`  | WordPress containers' Security Context                                                    | Check `values.yaml` file             |
| `resources.limits`          | The resources limits for the WordPress container                                          | `{}`                                 |
| `resources.requests`        | The requested resources for the WordPress container                                       | `{"memory": "512Mi", "cpu": "300m"}` |
| `livenessProbe`             | Liveness probe configuration for WordPress                                                | Check `values.yaml` file             |
| `readinessProbe`            | Readiness probe configuration for WordPress                                               | Check `values.yaml` file             |
| `customLivenessProbe`       | Override default liveness probe                                                           | `nil`                                |
| `customReadinessProbe`      | Override default readiness probe                                                          | `nil`                                |
| `updateStrategy`            | Set up update strategy                                                                    | `RollingUpdate`                      |
| `schedulerName`             | Name of the alternate scheduler                                                           | `nil`                                |
| `podAntiAffinityPreset`     | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`  | `soft`                               |
| `nodeAffinityPreset.type`   | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard` | `""`                                 |
| `nodeAffinityPreset.key`    | Node label key to match. Ignored if `affinity` is set.                                    | `""`                                 |
| `nodeAffinityPreset.values` | Node label values to match. Ignored if `affinity` is set.                                 | `[]`                                 |
| `affinity`                  | Affinity for pod assignment                                                               | `{}` (evaluated as a template)       |
| `nodeSelector`              | Node labels for pod assignment                                                            | `{}` (evaluated as a template)       |
| `tolerations`               | Tolerations for pod assignment                                                            | `[]` (evaluated as a template)       |
| `podLabels`                 | Extra labels for WordPress pods                                                           | `{}`                                 |
| `podAnnotations`            | Annotations for WordPress pods                                                            | `{}`                                 |
| `extraVolumeMounts`         | Additional volume mounts                                                                  | `[]`                                 |
| `extraVolumes`              | Additional volumes                                                                        | `[]`                                 |
| `initContainers`            | Add additional init containers to the WordPress pods                                      | `{}` (evaluated as a template)       |
| `sidecars`                  | Attach additional sidecar containers to the pod                                           | `{}` (evaluated as a template)       |

### Exposure parameters

| Parameter                          | Description                                                                   | Default                        |
|------------------------------------|-------------------------------------------------------------------------------|--------------------------------|
| `service.nginx.type`               | Kubernetes Service type                                                       | `LoadBalancer`                 |
| `service.nginx.port`               | Service HTTP port                                                             | `80`                           |
| `service.nginx.httpsPort`          | Service HTTPS port                                                            | `443`                          |
| `service.nginx.httpsTargetPort`    | Service Target HTTPS port                                                     | `https`                        |
| `service.nginx.nodePorts.http`     | Kubernetes http node port                                                     | `""`                           |
| `service.nginx.nodePorts.https`    | Kubernetes https node port                                                    | `""`                           |
| `service.nginx.extraPorts`         | Extra ports to expose in the service (normally used with the `sidecar` value) | `nil`                          |
| `service.nginx.clusterIP`          | WordPress service clusterIP IP                                                | `None`                         |
| `service.nginx.loadBalancerSourceRanges` | Restricts access for LoadBalancer (only with `service.nginx.type: LoadBalancer`) | `[]`                  |
| `service.nginx.loadBalancerIP`     | loadBalancerIP if service type is `LoadBalancer`                              | `nil`                          |
| `service.nginx.externalTrafficPolicy` | Enable client source IP preservation                                       | `Cluster`                      |
| `service.nginx.annotations`         | Service annotations                                                          | `{}` (evaluated as a template) |
| `service.phpFpm.type`               | Kubernetes Service type                                                      | `LoadBalancer`                 |
| `service.phpFpm.port`               | Service HTTP port                                                            | `80`                           |
| `service.phpFpm.httpsPort`          | Service HTTPS port                                                           | `443`                          |
| `service.phpFpm.httpsTargetPort`    | Service Target HTTPS port                                                    | `https`                        |
| `service.phpFpm.nodePorts.http`     | Kubernetes http node port                                                    | `""`                           |
| `service.phpFpm.nodePorts.https`    | Kubernetes https node port                                                   | `""`                           |
| `service.phpFpm.extraPorts`         | Extra ports to expose in the service (normally used with the `sidecar` value) | `nil`                         |
| `service.phpFpm.clusterIP`          | WordPress service clusterIP IP                                               | `None`                         |
| `service.phpFpm.loadBalancerSourceRanges` | Restricts access for LoadBalancer (only with `service.phpFpm.type: LoadBalancer`) | `[]`                |
| `service.phpFpm.loadBalancerIP`     | loadBalancerIP if service type is `LoadBalancer`                             | `nil`                          |
| `service.phpFpm.externalTrafficPolicy` | Enable client source IP preservation                                      | `Cluster`                      |
| `service.phpFpm.annotations`       | Service annotations                                                           | `{}` (evaluated as a template) |
| `ingress.enabled`                  | Enable ingress controller resource                                            | `false`                        |
| `ingress.certManager`              | Add annotations for cert-manager                                              | `false`                        |
| `ingress.hostname`                 | Default host for the ingress resource                                         | `wordpress.local`              |
| `ingress.path`                     | Default path for the ingress resource                                         | `/`                            |
| `ingress.tls`                      | Create TLS Secret                                                             | `false`                        |
| `ingress.annotations`              | Ingress annotations                                                           | `[]` (evaluated as a template) |
| `ingress.extraHosts[0].name`       | Additional hostnames to be covered                                            | `nil`                          |
| `ingress.extraHosts[0].path`       | Additional hostnames to be covered                                            | `nil`                          |
| `ingress.extraPaths`               | Additional arbitrary path/backend objects                                     | `nil`                          |
| `ingress.extraTls[0].hosts[0]`     | TLS configuration for additional hostnames to be covered                      | `nil`                          |
| `ingress.extraTls[0].secretName`   | TLS configuration for additional hostnames to be covered                      | `nil`                          |
| `ingress.secrets[0].name`          | TLS Secret Name                                                               | `nil`                          |
| `ingress.secrets[0].certificate`   | TLS Secret Certificate                                                        | `nil`                          |
| `ingress.secrets[0].key`           | TLS Secret Key                                                                | `nil`                          |

### Persistence parameters

| Parameter                   | Description                              | Default                                     |
|-----------------------------|------------------------------------------|---------------------------------------------|
| `persistence.enabled`       | Enable persistence using PVC             | `true`                                      |
| `persistence.existingClaim` | Enable persistence using an existing PVC | `nil`                                       |
| `persistence.storageClass`  | PVC Storage Class                        | `nil` (uses alpha storage class annotation) |
| `persistence.accessModes`   | PVC Access Modes                        | `[ReadWriteOnce]`                            |
| `persistence.size`          | PVC Storage Request                      | `10Gi`                                      |
| `persistence.dataSource`    | PVC data source                          | `{}`                                        |

### Database parameters

| Parameter                                 | Description                                          | Default                                        |
|-------------------------------------------|------------------------------------------------------|------------------------------------------------|
| `mariadb.enabled`                         | Deploy MariaDB container(s)                          | `true`                                         |
| `mariadb.architecture`                    | MariaDB architecture (`standalone` or `replication`) | `standalone`                                   |
| `mariadb.auth.rootPassword`               | Password for the MariaDB `root` user                 | _random 10 character alphanumeric string_      |
| `mariadb.auth.database`                   | Database name to create                              | `bitnami_wordpress`                            |
| `mariadb.auth.username`                   | Database user to create                              | `bn_wordpress`                                 |
| `mariadb.auth.password`                   | Password for the database                            | _random 10 character long alphanumeric string_ |
| `mariadb.primary.persistence.enabled`     | Enable database persistence using PVC                | `true`                                         |
| `mariadb.primary.persistence.accessModes` | Database Persistent Volume Access Modes              | `[ReadWriteOnce]`                              |
| `mariadb.primary.persistence.size`        | Database Persistent Volume Size                      | `8Gi`                                          |
| `externalDatabase.host`                   | Host of the external database                        | `localhost`                                    |
| `externalDatabase.user`                   | Existing username in the external db                 | `bn_wordpress`                                 |
| `externalDatabase.password`               | Password for the above username                      | `nil`                                          |
| `externalDatabase.database`               | Name of the existing database                        | `bitnami_wordpress`                            |
| `externalDatabase.port`                   | Database port number                                 | `3306`                                         |
| `externalDatabase.existingSecret`         | Name of the database existing Secret Object          | `nil`                                          |
| `memcached.enabled`                       | Deploy Memcached for caching database queries        | `false`                                        |

### Volume Permissions parameters

| Parameter                                     | Description                                                                                                          | Default                                                 |
|-----------------------------------------------|----------------------------------------------------------------------------------------------------------------------|---------------------------------------------------------|
| `volumePermissions.enabled`                   | Enable init container that changes the owner and group of the persistent volume(s) mountpoint to `runAsUser:fsGroup` | `false`                                                 |
| `volumePermissions.image.registry`            | Init container volume-permissions image registry                                                                     | `docker.io`                                             |
| `volumePermissions.image.repository`          | Init container volume-permissions image name                                                                         | `bitnami/bitnami-shell`                                 |
| `volumePermissions.image.tag`                 | Init container volume-permissions image tag                                                                          | `"10"`                                                  |
| `volumePermissions.image.pullPolicy`          | Init container volume-permissions image pull policy                                                                  | `Always`                                                |
| `volumePermissions.image.pullSecrets`         | Specify docker-registry secret names as an array                                                                     | `[]` (does not add image pull secrets to deployed pods) |
| `volumePermissions.resources.limits`          | Init container volume-permissions resource  limits                                                                   | `{}`                                                    |
| `volumePermissions.resources.requests`        | Init container volume-permissions resource  requests                                                                 | `{}`                                                    |
| `volumePermissions.securityContext.*`         | Other container security context to be included as-is in the container spec                                          | `{}`                                                    |
| `volumePermissions.securityContext.runAsUser` | User ID for the init container (when facing issues in OpenShift or uid unknown, try value "auto")                    | `0`                                                     |

### Other parameters

| Parameter                  | Description                                                    | Default |
|----------------------------|----------------------------------------------------------------|---------|
| `pdb.create`               | Enable/disable a Pod Disruption Budget creation                | `false` |
| `pdb.minAvailable`         | Minimum number/percentage of pods that should remain scheduled | `1`     |
| `pdb.maxUnavailable`       | Maximum number/percentage of pods that may be made unavailable | `nil`   |
| `autoscaling.enabled`      | Enable autoscaling for WordPress                               | `false` |
| `autoscaling.minReplicas`  | Minimum number of WordPress replicas                           | `1`     |
| `autoscaling.maxReplicas`  | Maximum number of WordPress replicas                           | `11`    |
| `autoscaling.targetCPU`    | Target CPU utilization percentage                              | `nil`   |
| `autoscaling.targetMemory` | Target Memory utilization percentage                           | `nil`   |

The above parameters map to the env variables defined in [bitnami/wordpress](http://github.com/bitnami/bitnami-docker-wordpress). For more information please refer to the [bitnami/wordpress](http://github.com/bitnami/bitnami-docker-wordpress) image documentation.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
helm install my-release \
  --set mariadb.auth.rootPassword=secretpassword \
    bitnami/wordpress
```

The above command sets the MariaDB `root` user password to `secretpassword`.

> NOTE: Once this chart is deployed, it is not possible to change the database credentials, such as usernames or passwords, using Helm. To change these application credentials after deployment, delete any persistent volumes (PVs) used by the chart and re-deploy it, or use the application's built-in administrative tools if available.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
helm install my-release -f values.yaml bitnami/wordpress
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Configuration and installation details

### [Rolling VS Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Known limitations

When performing admin operations that require activating the maintenance mode (such as updating a plugin or theme), it's activated in only one replica (see: [bug report](https://core.trac.wordpress.org/ticket/50797)). This implies that WP could be attending requests on other replicas while performing admin operations, with unpredictable consequences.

To avoid that, you can manually activate/deactivate the maintenance mode on every replica using the WP CLI. For instance, if you installed WP with three replicas, you can run the commands below to activate the maintenance mode in all of them (assuming that the release name is `wordpress`):

```console
kubectl exec $(kubectl get pods -l app.kubernetes.io/name=wordpress -o jsonpath='{.items[0].metadata.name}') -c wordpress -- wp maintenance-mode activate
kubectl exec $(kubectl get pods -l app.kubernetes.io/name=wordpress -o jsonpath='{.items[1].metadata.name}') -c wordpress -- wp maintenance-mode activate
kubectl exec $(kubectl get pods -l app.kubernetes.io/name=wordpress -o jsonpath='{.items[2].metadata.name}') -c wordpress -- wp maintenance-mode activate
```

### External database support

You may want to have WordPress connect to an external database rather than installing one inside your cluster. Typical reasons for this are to use a managed database service, or to share a common database server for all your applications. To achieve this, the chart allows you to specify credentials for an external database with the [`externalDatabase` parameter](#parameters). You should also disable the MariaDB installation with the `mariadb.enabled` option. Here is an example:

```console
mariadb.enabled=false
externalDatabase.host=myexternalhost
externalDatabase.user=myuser
externalDatabase.password=mypassword
externalDatabase.database=mydatabase
externalDatabase.port=3306
```

Refer to the [documentation on using an external database with WordPress](https://docs.bitnami.com/kubernetes/apps/wordpress/configuration/use-external-database/) and the [tutorial on integrating WordPress with a managed cloud database](https://docs.bitnami.com/tutorials/secure-wordpress-kubernetes-managed-database-ssl-upgrades/) for more information.

### Memcached

This chart provides support for using Memcached to cache database queries improving the website performance. To enable this feature, set `memcached.enabled` to `true`.

When this features is enabled, a Memcached server will be deployed in your K8s cluster using the Bitnami Memcached chart. You must install the [W3 Total Cache](https://wordpress.org/plugins/w3-total-cache/) and configure it to use the Memcached server for database caching.

### Ingress

This chart provides support for Ingress resources. If an Ingress controller, such as [nginx-ingress](https://kubeapps.com/charts/stable/nginx-ingress) or [traefik](https://kubeapps.com/charts/stable/traefik), that Ingress controller can be used to serve WordPress.

To enable Ingress integration, set `ingress.enabled` to `true`. The `ingress.hostname` property can be used to set the host name. The `ingress.tls` parameter can be used to add the TLS configuration for this host. It is also possible to have more than one host, with a separate TLS configuration for each host. [Learn more about configuring and using Ingress](https://docs.bitnami.com/kubernetes/apps/wordpress/configuration/configure-use-ingress/).

### TLS secrets

The chart also facilitates the creation of TLS secrets for use with the Ingress controller, with different options for certificate management. [Learn more about TLS secrets](https://docs.bitnami.com/kubernetes/apps/wordpress/administration/enable-tls/).

## Persistence

The [Bitnami WordPress](https://github.com/bitnami/bitnami-docker-wordpress) image stores the WordPress data and configurations at the `/bitnami` path of the container. Persistent Volume Claims are used to keep the data across deployments. [Learn more about persistence in the chart documentation](https://docs.bitnami.com/kubernetes/apps/wordpress/configuration/chart-persistence/).

### Additional environment variables

In case you want to add extra environment variables (useful for advanced operations like custom init scripts), you can use the `extraEnvVars` property.

```yaml
wordpress:
  extraEnvVars:
    - name: BITNAMI_DEBUG
      value: true
```

Alternatively, you can use a ConfigMap or a Secret with the environment variables. To do so, use the `extraEnvVarsCM` or the `extraEnvVarsSecret` values.

### Sidecars

If additional containers are needed in the same pod as WordPress (such as additional metrics or logging exporters), they can be defined using the `sidecars` parameter. If these sidecars export extra ports, extra port definitions can be added using the `service.extraPorts` parameter. [Learn more about configuring and using sidecar containers](https://docs.bitnami.com/kubernetes/apps/wordpress/administration/configure-use-sidecars/).

### Pod affinity

This chart allows you to set your custom affinity using the `affinity` parameter. Find more information about Pod affinity in the [kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity).

As an alternative, use one of the preset configurations for pod affinity, pod anti-affinity, and node affinity available at the [bitnami/common](https://github.com/bitnami/charts/tree/master/bitnami/common#affinities) chart. To do so, set the `podAffinityPreset`, `podAntiAffinityPreset`, or `nodeAffinityPreset` parameters.
