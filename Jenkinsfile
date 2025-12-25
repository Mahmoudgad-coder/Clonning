
pipeline{
     agent any
     
     tools{
         jdk 'jdk17'
         nodejs 'node16'
     }
     environment {
         SCANNER_HOME=tool 'sonarqube-scanner'
     }
     
     stages {
         stage('Clean Workspace'){
             steps{
                 cleanWs()
             }
         }
         stage('Checkout from Git'){
             steps{
                 git branch: 'main', url: 'https://github.com/Mahmoudgad-coder/Clonning.git'
             }
         }
         stage("Sonarqube Analysis "){
             steps{
                 withSonarQubeEnv('SonarQube-Server') {
                     sh ''' $SCANNER_HOME/bin/sonar-scanner -Dsonar.projectName=Swiggy-CI \
                     -Dsonar.projectKey=Swiggy-CI '''
                 }
             }
         }
         stage("Quality Gate"){
            steps {
                 script {
                     waitForQualityGate abortPipeline: false, credentialsId: 'SonarQube-Token' 
                 }
             } 
         }
         stage('Install Dependencies') {
             steps {
                 sh "npm install"
             }
         }
        stage('Trivy FS Scan') {
    		steps {
        	sh '''
        	docker run --rm \
          	-v $(pwd):/project \
          	aquasec/trivy:latest \
          	fs /project \
          	--severity HIGH,CRITICAL \
          	--no-progress \
          	> trivy-fs.txt
        	'''
    	}
	}
          stage("Docker Build & Push"){
             steps{
                 script{
                    withDockerRegistry(credentialsId: 'dockerhub', toolName: 'docker'){   
                        sh "docker build -t swiggy-clone ."
                        sh "docker tag swiggy-clone mmgad/swiggy-clone:latest "
                        sh "docker push mmgad/swiggy-clone:latest "
                     }
                 }
             }
         }
         stage('Trivy Image Scan') {
    		steps {
        	sh '''
        	docker run --rm \
          	-v /var/run/docker.sock:/var/run/docker.sock \
          	aquasec/trivy:latest \
          	image swiggy-clone:latest \
         	 --severity HIGH,CRITICAL \
          	--no-progress \
         	 > trivy-image.txt
        	'''
    		}
		}

          stage('Deploy to Kubernets'){
             steps{
                 script{
                     dir('Kubernetes') {
                         kubeconfig(credentialsId: 'kubernetes', serverUrl: '') {
                         sh 'kubectl delete --all pods'
                         sh 'kubectl apply -f deployment.yml'
                         sh 'kubectl apply -f service.yml'
                         }   
                     }
                 }
             }
         }



     }
 }
