# Deploy-a-Web-Application-in-Kubernetes-with-Terraform
We will first provision an EKS cluster with Terraform. Then, we will deploy an HTML5 web-based Pac-Man game that you can play in your browser to your EKS cluster with Terraform. 

![image](https://github.com/user-attachments/assets/4fb30f5e-f045-4144-ad6d-4817fd3b18ee)

### Deploy your EKS Cluster with Terraform
#### Create an IAM Acess Key and Configure the AWS CLI
#### Note : Creating an IAM (Identity and Access Management) user is a best practice in AWS security. Instead of using the root account, which has unrestricted access to all AWS services, an IAM user provides controlled and secure access. Below are the key                  reasons why we create an IAM user before deploying the EKS cluster with Terraform. So Initally we will be creating a IAM user named ```cloud_user```.

- In the AWS Management Console, select IAM from the list of Services.
- On the IAM dashboard, under IAM resources, click Users
- In the list of users, click cloud_user.
- Click the Security credentials tab.
- Scroll down to the Access keys section and click Create access key.
- For Step 1, select Command Line Interface (CLI), check the I understand the above recommendations and want to proceed to create an     access key checkbox, and click Next.
- For Step 2, in the Description tag value field, enter Terraform_Access_Key and click Create access key.
- Copy the ```Access key``` and ```Secret access key``` provided, and capture them in a safe and easily accessible location.
- In your terminal, configure the AWS CLI to connect to your AWS instance:
```bash
aws configure
```
- When prompted for the ```AWS Access Key ID```, enter the Access key you copied from the AWS console.
- When prompted for the ```AWS Secret Access Key```, enter the Access key you copied from the AWS console.
- When prompted, press Enter to accept the ```Default region name``` and ```Default output format```.

#### Deploy the EKS Cluster with Terraform
- Download the EKS Terraform configuration provided or you can download the folder in my repository
```//github.com/pluralsight-cloud/content-deploying-and-managing-a-web-application-in-kubernetes-with-terraform/raw/main/eks.zip```
- Unzip the file
```bash
unzip eks.zip
```
- change into the ```EKS``` directory
```bash
cd eks
```
- List the files in the directory
```bash
ls
```
#### Note : You should see the ```eks-cluster.tf, main.tf, outputs.tf, terraform.tf, variables.tf, and vpc.tf``` configuration files
- Intialize the working directory
```bash
terraform init
```
- Validate the configuration
```bash
terraform validate
```
- Create an execution plan in terraform
```bash
terraform plan
```
- Apply the configuration and deploy the EKS cluster
```bash
terraform apply
```
- Once deployed, configure the Kubernetes CLI to use the cluster's context
``` bash
# Used to configure kubectl (Kubernetes CLI) to connect to an Amazon EKS (Elastic Kubernetes Service) cluster.
aws eks --region $(terraform output -raw region) update-kubeconfig --name $(terraform output -raw cluster_name)
```
- Cnnfirm that the cluster is up and running
``` bash
kubectl cluster-info
```
#### Note : You should see that the ```Kubernetes control plane``` and ```CoreDNS``` are running as expected.

#### Complete the Terraform Configuration
- Chnage into the main directory
``` bash
cd ../
```
- Download the Pac-Man Terraform configuration provided or you can find this in repository files section :
``` bash
wget https://github.com/pluralsight-cloud/content-deploying-and-managing-a-web-application-in-kubernetes-with-terraform/raw/main/pac-man.zip
```
- Unzip th file:
```bash
unzip pac-man.zip
```
- List the files:
```bash
ls
```
- Change into th ```pac-man``` directory
```bash
cd pac-man/
```
- List the fils in the directory
```bash
ls
```
#### Note : You should see the ```modules``` directory and the ```pac-man.tf``` configuration file.
-  Edit the Pac-Man configuration deployment:
```bash
vim modules/pac-man/pac-man-deployment.tf
```
-  For the ```container``` spec, update the ```image``` argument with the Docker image provided :
```bash
image = "docker.io/jessehoch/pacman-nodejs-app:latest"
```
-  List the files in the modules directory :
```bash
ls modules/
```
#### Note : You should see the ```mongo``` and ```pac-man``` directories.
-  Edit the main Terraform configuration file:
```bash
vim pac-man.tf
```
-   Update the file to include these two modules and pass the ```pac-man``` namespace to them:
```bash
# Define a Terraform module named "mongo" to deploy a MongoDB instance
module "mongo" {
  source = "./modules/mongo"       # Path to the MongoDB module
  kubernetes_namespace = "pac-man" # Deploy MongoDB in the "pac-man" Kubernetes namespace
}

# Define a Terraform module named "pac-man" to deploy the Pac-Man application
module "pac-man" {
  source = "./modules/pac-man"      # Path to the Pac-Man application module
  kubernetes_namespace = "pac-man"  # Deploy Pac-Man in the same "pac-man" Kubernetes namespace

  # Ensure MongoDB is deployed first before deploying the Pac-Man application
  depends_on = [module.mongo]  
}
```
- Check the configuration for any formatting issues
```bash
 terraform fmt
```
-  Intialize the working directory
```bash
 terraform init
```
-  Validate the configuration
```bash
terraform validate
```
#### Deploy the Pac-Man Web Application with Terraform :
-  Apply the configuration and deploy the web application:
```bash
terraform apply
```
-  When prompted, enter yes to confirm.
-  Once deployed, confirm that the web application resources were deployed in the ```pac-man``` namespace and are available:
```bash
kubectl -n pac-man get all
```
#### Note : You should see that the ```mongo``` and ```pac-man pods```, services, deployments, and replicas are all available and running as expected.
-  For the ```pac-man``` service, copy the external IP address provided in the ```EXTERNAL-IP``` column.
-  In a new browser tab or window, paste the external IP address and hit Enter.
-  When the Pac-Man web application launches, click to play as instructed, and play the game to confirm that it is working as expected.

#### Scale the Kubernetes Web Application :
- Back in the terminal, edit the MongoDB deployment configuration file:
```bash
vim modules/mongo/mongo-deployment.tf
```
-  For the replicas spec, update the ```replicas``` value to 2.
-  Edit the Pac-Man deployment configuration file:
```bash
vim modules/pac-man/pac-man-deployment.tf
```
-  For the replicas spec, update the replicas value to 3.
-  Apply the updates to the configuration:
```bash
terraform apply
```
-  When prompted, enter yes to confirm.
-  Confirm that the resources were updated:
  ```bash
kubectl -n pac-man get all
```
-  You should see that the mongo and pac-man pods, deployments, and replicas have all been scaled up to 2 and 3, respectively.
-  In the browser, refresh the Pac-Man web application and confirm that it is still working as expected.
-  Back in the terminal, edit the MongoDB and Pac-Man deployment configuration files again, this time changing the replicas back to 1.
-  Apply the updates to the configuration:
```bash
terraform apply
```
-  When prompted, enter yes to confirm.
-  Confirm that the resources were updated:
```bash
kubectl -n pac-man get all
```
-  You should see that the mongo and pac-man pods, deployments, and replicas have all been scaled back down to 1 each.

-  In the browser, refresh the Pac-Man web application again and confirm that it is still working as expected.



#### ⚠️ Disclaimer: This project is based on a Pluralsight course: "Deploying and Managing a Web Application in Kubernetes with Terraform." I have modified and extended the implementation for my own use case.If you find this project useful, consider checking out the original course on Pluralsight!




#### 📜 License: This project is provided for educational purposes. Please ensure you comply with Pluralsight's terms of use before distributing this work.


#### 💡 Contributions: Feel free to modify and improve this project! If you add new features or optimizations, consider opening a pull request.
