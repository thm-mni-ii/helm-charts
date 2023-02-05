# Helm Charts

[![Artifact Hub](https://img.shields.io/endpoint?url=https://artifacthub.io/badge/repository/thm-mni-ii)](https://artifacthub.io/packages/search?repo=thm-mni-ii)

This repo contains all the Helm charts for this Github organisation.

## Available charts

| Chart Name                              | Source Code                                                                                  |
| --------------------------------------- | -------------------------------------------------------------------------------------------- |
| [feedbacksystem](charts/feedbacksystem) | [https://github.com/thm-mni-ii/feedbacksystem](https://github.com/thm-mni-ii/feedbacksystem) |

## Usage

[Helm](https://helm.sh) is required to use the charts.  
Please refer to the [Helm documentation](https://helm.sh/docs/intro/quickstart/) for installation instructions.

After the installation, the repo can be added with the following command:

`helm repo add thm-mni-ii https://thm-mni-ii.github.io/helm-charts`

**Update the Repo**:

`helm repo update`

**List all available chats**:

`helm search repo thm-mni-ii`

**To install the <chart-name> chart**:

`helm install my-<chart-name> thm-mni-ii/<chart-name>`

**To uninstall the chart**:

`helm delete my-<chart-name>`
