# Deploying Traditional Web Applications on Kubernetes

Once you have [built the container image](/1-container-image) and [Helm chart](/2-helm-chart), you can proceed to deploying your traditional web application on top of Kubernetes via the Helm chart.

## Deploy Helm chart

Based on the [WordPress example Helm chart with NGINX and PHP-FPM](/2-helm-charts/examples/nginx-php-fpm/), you can deploy it like this:

```console
$ helm install my-release /path/to/nginx-php-fpm
```

To specify deployment options, for instance, a different username:

```console
$ helm install my-release  /path/to/nginx-php-fpm
```

## Publish Helm chart

> NOTE: Ensure that container images used in the chart are all publicly available before uploading the chart.

To make a Helm chart public, so that it can be deployed by others, it is essential to have access to a Helm repository. See [how to create a chart repository](https://helm.sh/docs/topics/chart_repository/).

Once you have created the repository, you can easily package your chart via `helm package` and publish it to the repository as documented [here](https://helm.sh/docs/topics/chart_repository/#managing-chart-repositories).

## Maintenance

Helm natively supports several two maintenance operations, [`upgrade`](https://helm.sh/docs/helm/helm_upgrade/) and [`rollback`](https://helm.sh/docs/helm/helm_rollback/). Refer to the [official Helm docs](https://helm.sh/docs/) for more information.

It is responsability of the chart to implement any other operation, for instance: Periodic jobs, support for scaling, persistence, support for app updates, etc.

## Limitations

Helm is the simpler way to deploy solutions on top of Kubernetes. However, it has certain limitations, like for example:

* It is not prepared to perform operations on top of an installed release. Any such features must be implemented by the operator.
* Dynamic resources creation outside of deployment/upgrade is not supported, and needs to be implemented as software.

When solutions require advanced functionalities not provided by Helm, it is common to adapt Operators. [Check out the official docs regarding Kubernetes Operators for more information](https://kubernetes.io/docs/concepts/extend-kubernetes/operator/).
