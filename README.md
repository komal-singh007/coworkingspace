# Coworking Space 
The Coworking Space Service is a set of APIs that enables users to request one-time tokens and administrators to authorize access to a coworking space. This service follows a microservice pattern and the APIs are split into distinct services that can be deployed and managed independently of one another.

For this project, you are a DevOps engineer who will be collaborating with a team that is building an API for business analysts. The API provides business analysts basic analytics data on user activity in the service. The application they provide you functions as expected locally and you are expected to help build a pipeline to deploy it in Kubernetes.

### Dependencies
You'll need a Python environment (3.6+), Docker CLI, `kubectl` for your local environment. For remote resources, you'll need AWS CodeBuild, AWS ECR, a Kubernetes environment with AWS EKS, AWS CloudWatch, and GitHub.

### Setup
#### 1. Configure a Database


## Set up a Postgres database

Find the yml file in db folder and run the following commands 

```bash
kubectl apply -f pvc.yaml
kubectl apply -f pv.yaml
kubectl apply -f postgresql-deployment.yaml
```

##  Connecting to postgress Via Port Forwarding
```bash
kubectl port-forward --namespace default svc/<SERVICE_NAME>-postgresql 5432:5432 &
    PGPASSWORD="$POSTGRES_PASSWORD" psql --host 127.0.0.1 -U postgres -d postgres -p 5432
```

## Run Seed Files
 Run the seed files in `db/` in order to create the tables and populate them with data.

```bash
kubectl port-forward --namespace default svc/<SERVICE_NAME>-postgresql 5432:5432 &
    PGPASSWORD="$POSTGRES_PASSWORD" psql --host 127.0.0.1 -U postgres -d postgres -p 5432 < <FILE_NAME.sql>
```
## Run python app.py
To run the application, you need to set several environment variables. These can be set per session with `export KEY=VAL` or prepended to your command. The variables are:

* `DB_USERNAME`
* `DB_PASSWORD`
* `DB_HOST` (default: `127.0.0.1`)
* `DB_PORT` (default: `5432`)
* `DB_NAME` (default: `postgres`)

To prepend them to your command, use the following format:
```bash
DB_USERNAME=username DB_PASSWORD=password python app.py
```
## Verifying The Application
* Generate report for check-ins grouped by dates
`curl <BASE_URL>/api/reports/daily_usage`

* Generate report for check-ins grouped by users
`curl <BASE_URL>/api/reports/user_visits`

## Create a `Dockerfile` for the Python application.

1. Create a Dockerfile in `analytics/`.
2. Transfer local setup to Dockerfile.
3. Use a Python Docker image (slim version) for `FROM`.
4. Add `-y` to `apt` commands.
5. Build and test your Docker image:

```bash
docker build -t test-coworking-analytics .
```

## Continuous Integration with CodeBuild 

1. Create an Amazon ECR repository.
2. Set up an Amazon CodeBuild project linked to your GitHub repo.
3. Create a `buildspec.yaml` file to trigger on repo updates. It should:
   - Set up Docker login (`aws ecr get-login-password`)
   - Build the app (`docker build`)
   - Tag the image (`docker tag`) using `$CODEBUILD_BUILD_NUMBER`
   - Push the image to ECR (`docker push`)
4. Add necessary environment variables in AWS console.
5. Update IAM role permissions for CodeBuild to access ECR.
6. Verify by clicking "Start Build" in CodeBuild console and check ECR for the Docker image.



## Create a service and deployment using Kubernetes configuration files to deploy the application.

1. **ConfigMap**: Create a ConfigMap for plaintext variables (DB_HOST, DB_USERNAME, DB_PORT, DB_NAME). DB_HOST is the service name from `kubectl get svc`. DB_PORT is `5432`.

2. **Secret**: Store sensitive variables (DB_PASSWORD) in a Secret.

3. **Deployment**: Create a deployment YAML file to deploy the Docker image from your ECR repository to your Kubernetes network. Reference ConfigMap and Secret in the Deployment manifest file using `env` or `envFrom`.




## CloudWatch Logging (README)
Set up CloudWatch logging using the Container Insights feature. Refer to the Operationalizing Kubernetes lesson for setup instructions. Screenshots demonstrating successful setup are expected. 




