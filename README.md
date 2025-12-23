#Deploying the Swiggy clone app#
>> use terraform to install  EC2 instances (one for jenkins and trivy  and one for sonar qube)
>> install needed plugins and configure jenkins tools (nodejs , jdk , docker , sonarqube scanner )
>> configure Sonarqube & integrate it with jenkins 
   will generate token to be used by jenkins to access SQ 
   add token to jenkins credentials (secret text)
   add sonarqube server ip in system  
   
will create Qualitygate in SQ , 
then will create webhook so that SQ can use to reply to jenkins with the result

>>Create AWS EKS Cluster and Download the Config/Secret file for EKS Cluster
* on Jenkins EC2 will 
1. Install kubectl 
2. Install AWS Cli
3. Installing  eksctl
now will create IAM Role and attach it to Jenkins EC2
4. Setup Kubernetes using eksctl


 eksctl create cluster --name virtualtechbox-cluster --region us-east-1 --node-type t3.small --nodes 3 \


>> create jenkins pipeline to push created image to dockerhub & Deploy Application on EKS
install Kubernetes plugins 
add credentials of EKS cluster to jenkins
 our pipeline stages will be as below : 
  Pipeline Stages

*Clean Workspace
Clears the Jenkins workspace to ensure a fresh build with no leftover files from previous runs.
*Checkout from Git
Clones the source code from the main branch of the GitHub repository.
*SonarQube Analysis
Runs static code analysis using SonarQube Scanner to check code quality, bugs, and vulnerabilities.
*Quality Gate
Waits for the SonarQube Quality Gate result to ensure the code meets defined quality standards before continuing.
*Install Dependencies
Installs all required Node.js dependencies using npm install.
*Trivy File System Scan
Performs a security scan on the project file system using Trivy and saves the report to trivyfs.txt.
*Docker Build & Push
Builds a Docker image for the application
Tags the image
Pushes it to Docker Hub
*Trivy Image Scan
Scans the Docker image for vulnerabilities using Trivy and stores the results in trivyimage.txt.
*Deploy to Kubernetes
Deploys the application to a Kubernetes cluster by applying the deployment and service YAML files. 

>> will create webhook on github repo to automate te CICD







