# Helm Charts

[![Artifact Hub](https://img.shields.io/endpoint?url=https://artifacthub.io/badge/repository/thm-mni-ii)](https://artifacthub.io/packages/search?repo=thm-mni-ii)

This repo contains all the Helm charts for this Github organisation.

## Available charts

| Chart Name                              | Source Code                                                                                                                                                           | Package                                                                                                                                                                       |
| --------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [feedbacksystem](charts/feedbacksystem) | [![(https://github.com/thm-mni-ii/feedbacksystem](https://img.shields.io/badge/GitHub-Feedbacksystem-blue?logo=github)](https://github.com/thm-mni-ii/feedbacksystem) | [![Artifact Hub](https://img.shields.io/endpoint?url=https://artifacthub.io/badge/repository/feedbacksystem)](https://artifacthub.io/packages/helm/thm-mni-ii/feedbacksystem) |

## Usage

[Helm](https://helm.sh) is required to use the charts.  
Please refer to the [Helm documentation](https://helm.sh/docs/intro/quickstart/) for installation instructions.

After the installation, the repo can be added with the following command:

`helm repo add thm-mni-ii https://thm-mni-ii.github.io/helm-charts`

**Update the Repo**:

`helm repo update`

**List all available chats**:

`helm search repo thm-mni-ii`

**To install the chart**:

`helm install my-<chart-name> thm-mni-ii/<chart-name>`

**To uninstall the chart**:

`helm delete my-<chart-name>`
