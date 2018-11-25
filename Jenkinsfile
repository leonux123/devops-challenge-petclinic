pipeline {
    agent any
    stages {
    	   stage('Test') {
	            steps {
	            	sh 'echo "Task: Test"'
            }
        }
  	     stage('Build') {
	            steps {
	            	sh './mvnw package'
            }
        }
	    stage('Deliver for DEV') {
            when {
                branch 'PR-*'
            }
            steps {
                sh 'echo "AWS Provisioning Task: Started"'
		sh './jenkins/scripts/EC2_on-demand.sh start'
                sh 'export IP=$(cat ip_from_file) && ssh -oStrictHostKeyChecking=no -i /home/leonux/aws/MyKeyPair.pem ec2-user@$IP ./deploy.sh'
	        sh 'export IP=$(cat ip_from_file) && echo "Your app is ready: http://$IP:8080"'
		input message: 'Finished using the web site? (Click "Proceed" to continue)'
		sh 'echo "Terminate Task: Started"'
		sh './jenkins/scripts/EC2_on-demand.sh terminate'
            }
        }
        stage('Deliver for PROD') {
            when {
                branch 'master' 
            }
            steps {
	        sh 'echo "AWS Provisioning Task: Started"'
		sh './jenkins/scripts/EC2_on-demand.sh start'
                sh 'export IP=$(cat ip_from_file) && ssh -oStrictHostKeyChecking=no -i /home/leonux/aws/MyKeyPair.pem ec2-user@$IP ./deploy.sh'
	        sh 'export IP=$(cat ip_from_file) && echo "Your app is ready: http://$IP:8080"'
		input message: 'Finished using the web site? (Click "Proceed" to continue)'
		sh 'echo "Terminate Task: Started"'
		sh './jenkins/scripts/EC2_on-demand.sh terminate'
            }
        }
    }
}
