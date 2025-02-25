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
