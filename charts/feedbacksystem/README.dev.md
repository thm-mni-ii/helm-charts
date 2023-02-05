# Feedbackssystem Helm Chart Development

Instructions to run this Helm Chart locally to test and develop it. A production-ready guide can be found [here](README.md).

## Requirements

- [kubectl](https://kubernetes.io/docs/tasks/tools/)
- [helm](https://helm.sh/docs/intro/install/)
- [minikube](https://minikube.sigs.k8s.io/docs/start/)
- [deno](https://deno.land/manual/getting_started/installation)

## Steps

1. Install requirements
2. Start minikube `minikube start --driver=docker`
3. Generate values `deno run --reload=https://raw.githubusercontent.com https://raw.githubusercontent.com/thm-mni-ii/helm-charts/main/charts/feedbacksystem/generate-values.ts --allow-write=vals.yaml vals.yaml`
4. Install `helm install -n <namepsace> --create-namespace --wait -f vals.yaml fbs .`
5. Forward FBS `kubectl -n <namespace> port-forward services/fbs-core 8443:443`
6. Acess https://localhost:8443
