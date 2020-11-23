# Cloud Provider Scraper

The purpose of this repo is create a mechanism to get cloud docs, text, images, etc, from cloud provider. To do that, our approach was to use web crawwlers to extract data from different sources:

- [Oracle](./oracle)
- [Azure](./azure)

## Docker

To run this scraper, you can use docker with follow command:

```Shell
# windows enviroment
docker run --rm -p 8888:8888 -e JUPYTER_ENABLE_LAB=yes -v "C:\Users\user\your\folder\target":/home/jovyan/work pavelsjo/jupyter-scraper

# linux environment
docker run --rm -p 8888:8888 -e JUPYTER_ENABLE_LAB=yes -v your/folder/target:/home/jovyan/work pavelsjo/jupyter-scraper
```

The `-v` command enable a share folder between your local computer and docker image container. **Warning** please check this [recommendation-wsl](https://docs.docker.com/docker-for-windows/wsl/)

This project is based on [Jupyter Docker Stacks](https://jupyter-docker-stacks.readthedocs.io/en/latest/index.html), and, fell free to use other [Image options](https://jupyter-docker-stacks.readthedocs.io/en/latest/using/selecting.html). **Warnnig:** this approach will be required install aditional python libraries.

## Oracle kubernets setup

### Registry

You need install [docker]('') in your local machine, and look your:

- `<name_space>`,
- `<your.user@domain.com>`
- `<password>`

Run the follow script:

```bash
# windows environment

# loggin
docker login us-ashburn-1.ocir.io --<username> <name_space>/oracleidentitycloudservice/<your.user@domain.com> -password '<password>'

# tag your local image
docker tag <image_name>:latest us-ashburn-1.ocir.io/<name_space>/<oci_repository_name>/<image_name:latest>

# push to oracle registry
docker push us-ashburn-1.ocir.io/name_space/repository_name/image_name:latest

```
### Kubertenes Configuration.

Create kubernetes secrete
```bash
kubectl create secret docker-registry ocirsecret --docker-server=<region-key>.ocir.io --docker-username='<tenancy-namespace>/<oci-username>' --docker-password='<oci-auth-token>' --docker-email='<email-address>'

```
Kubernetes Manifest for Jupiter-scraper Service:

```bash
apiVersion: apps/v1
kind: Deployment
metadata:
  name: orionlad-deployment
spec:
  selector:
    matchLabels:
      app: orionlad
  replicas: 1
  template:
    metadata:
      labels:
        app: orionlad
    spec:
      containers:
      - name: orionlad
    # enter the path to your image, be sure to include the correct region prefix    
        image: us-ashburn-1.ocir.io/<name_space>/<oci_repository_name>/<image_name:latest>
        ports:
        - containerPort: 8888
      imagePullSecrets:
    # enter the name of the secret you created  
      - name: ocirsecret
---
apiVersion: v1
kind: Service
metadata:
  name: orionlad-service
spec:
  type: LoadBalancer
  ports:
  - port: 8888
    protocol: TCP
    targetPort: 8888
  selector:
    app: orionlad
```

Deploy Kubernetes Service for Jupiter-scraper

```bash
kubectl create -f ./orionlad-lb.yml
```
View services IP
```bash
kubectl get services
```
## Disclaimer

The views expressed on this repository are my own and do not reflect the views of the company(ies) I work (or have worked for) neither Oracle Corporation. The opinions expressed by visitors on this repository are theirs, not mine.

The information in this repository is written based on personal experiences. You are free to use the information on this repository but I am not responsible and will not compensate to you if you ever happen to suffer a loss/inconvenience/damage because of/while making use of this information.
