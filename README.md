# kelm
kelm is Helm wrapper.

## subcommand

```
apply   : 'kubectl apply -f -'
show    : show helm reslut
test    : 'kubectl apply --dry-run -f -'
delete  : 'kubectl delete -f -'
recreate: 'kubectl delete -f -' && 'kubectl apply -f -'
```

## options
### global

```
-l, -helm-version int     : use helm version (2,3), (default: 3)
-e, -env          string  : your cluster envirouments, (default: dev), require
-n, -namespace    string  : apply namespace
    -name         string  : release name
-f, -values       []string: using values file(mlutiple), (default: '${APP_NAME}/values/${ENV}-values.yaml')
```