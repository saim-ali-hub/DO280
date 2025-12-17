#
Q1)  

    - configure the Oauth server to use HTPasswd as the identity provider
    - Secret name should be `secure-secret` and Identity provider name should be `user-id`
    - Create user `sam` with password `lincoln`
    - Create user `nick` with password `nick123`
    - Create user `mike` with password `mike123`
    - Create user `steve` with password `steve123`
    - Create user `tim` with password `tim123`
    - Create user `garry` with password `garry123`
    - Create user `lerry` with password `lerry123`
```
Q2) 
    - Create Projects `apollo`, `test`, `demo`
    - sam should have `cluster-admin` Permissions
    - mike can create projects
    - nick can not create projects
    - steve can `view` resources in `apollo` and `test` Projects
    - tim should have `admin` permissions on `apollo` Project
    - Delete `kubeadmin`

Q3)
    - Create groups `devteam`, `adminteam`
    - nick is member of `devteam` group
    - mike and tim are member of `adminteam` group
    - devteam group has `edit` Permission on `test` Project
    - adminteam group has `view` Permission on `demo` Project

Q4)
    - Create Resource Quota in `rocky` project
    - Quota name: `myquota`
    - `pods`=3 `cpu`=2 `services`=6 `memory`=1Gi `secrets`=6 `replicationcontrollers`=6

Q5)
    - Create limitrange name `darpa-limits` in `darpa` Project
    - `Pod` minimum memory 5Mi, maximum 300Mi
    - `Container` minimum memory 5Mi, maximum memory 300Mi, defaultrequest memory 100Mi
    - `Pod` minimum cpu 5m, maximum 300m
    - `Container` minimum cpu 5m, maximum cpu 300m, defaultrequest cpu 100m

Q6)
    - There is application running in `world` project
    - Manually Scale deployment to 5 replicas

Q7) 
    - in `scaling` project set the resource requests and limits
      requirement:
         requests: cpu: 1 and memory: 50Mi
         limits: cpu: 4 and memory: 100Mi
    - Autoscale pods
         minimum replicas 2, maximum replicas 5 and cpu percent 60%

Q7A)
    - There is one application in `troubleshooting-1` project
    - Application Should Produce Output

Q7B) 
    - There is one application in `troubleshooting-2` project
    - Application Should Produce Output

Q7C) 
    - There is one application in `troubleshooting-3`
    - Application Should Produce Output

Q8) 
    - Create secret name `magic` in `math` project
    - The Key name should be `MYSQL_ROOT_PASSWORD` The Value of key is `password123`

Q9) 
    - There is an application pod in `math` project 
    - Application should be running state

Q10) 
    - Create Secure Route for application running in project `quart`
    - application is accessible using `http`
    - route name: `quart-route`
    - It should run on https with self-signed certificate
    - there is certificate file cert-cmd on the system which has openssl commands
    - Subject is "/C=US/ST=New York/L=Brooklyn/O=abc/CN=info.apps.test-cluster.your-domain
    - Application should Produce output

Q11) 
    - Create ServiceAccount `qed-sa` in `qed` Project
    - ServiceAccount should be associated with `anyuid` SCC


Q12) 

    - There is one application running in `qed` Project
    - Application Should produce output

Q13) 

    - Use `default` Project
    - Install helm etherpad chart from https://redhat-cop.github.io/helm-charts
    - repository name: eth-repo
    - deployment name should be etherpad-app
    - Use latest version of etherpad

Q14) 

    - Create CronJob in `cron-test` Project
    - job name: `test-cron`
    - It should run at 04:05 on 2nd day of every month
    - Image `busybox`
    - successfulJobsHistoryLimit is 1
    - Create Service Account `project-1-sa`
    - Set Service Account to the cronjob

Q15) 

    - Create Project Template `mytemplate`, include LimitRange and limitrange name is `projectname-limit`
    - LimitRange Specs: 
      minimum memory 5Mi and maximum memory 1Gi
      Default request memory 254Mi and limit 512Mi

Q16)

    - Install `file-integrity-operator`
    - Namespace `openshift-file-integrity`

Q18) 

    - Create a deployment using `nginx` image in `page` project
    - PersistentVolume name: `landing-pv`, Access Mode: `ReadWriteMany`, Size: `1Gi` storageclass: `nfs-client`
    - Create PVC name `landing-pvc`, Access Mode: `same-as-pv`, Size: `same-as-pv`, MountPath: `/usr/share/nginx/html`
    - web files exists in web directory
    - Application should Produce output

Q20) 

    - Create NetworkPolicy `mysql-db-con`
    - Application running in `project-b` need to connect to database running on `project-a`
    - namespace label: `team=devsecops`
    - pod label: `tier=frontend`
    - port: `3306`
    - Application should be accessable at http://myhobbies.apps.test-cluster.your-domain-name

Q21) 

    - There is application running in `tuesday` Project. Add `livenessProb` HealthCheck.
    - port `8443` , `initialdelay` 3,`period` 10, `failures` 3, `Path` /index.html

    - FINAL TASK (5 minutes)
    - Create system10<clusterid>.tar.gz
    - Upload using /usr/bin/script/script