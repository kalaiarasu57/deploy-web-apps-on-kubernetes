# Creating a CI/CD pipeline to deploy a traditional web application on Kubernetes

A CI/CD pipeline allows to automate manual steps to get a web application deployed to Kubernetes. It also forces (or makes it easier to follow) good practices like ensuring that the image can be built reproducibly, and that it is re-built periodically with the last app and/or dependencies patches.

## Good reads

* Bitnami KubeCon session [App Testing at Scale: How Bitnami Tests Thousands of Releases Per Month](https://www.youtube.com/watch?v=DdszFwKm9tI). It describes how the Bitnami pipeline works for testing & releasing container images and Helm charts.
* [Continuous Integration and Deployment with GitLab, Kubernetes and Bitnami](https://docs.bitnami.com/tutorials/series/gitlab-kubernetes-ci-bitnami/)
* [Create a Continuous Integration Pipeline with Jenkins and Google Kubernetes Engine](https://docs.bitnami.com/tutorials/create-ci-cd-pipeline-jenkins-gke/)

## CI/CD vendors

There are a lot of CI/CD vendors out there, many of them are free. For example:

* [GitHub Actions](https://github.com/features/actions): The most convenient if you are hosting your container image source code on Github.
* [GitLab CI/CD](https://docs.gitlab.com/ee/ci/): Same but when hosting the source code on GitLab.
* [Travis CI](https://www.travis-ci.com): Very popular amongst open-source projects since they allow them to run for free.
* [CircleCI](https://circleci.com/): Another popular CI/CD solution which is easy to integrate with a lot of platforms.

There are also various open-source projects which you can host on your own. [Jenkins](https://www.jenkins.io/) is one of the most known ones, which we even use internally at Bitnami. A cloud-native re-implementation of this project can be found in [Jenkins X](https://jenkins-x.io/), and is gaining a lot of traction lately.
