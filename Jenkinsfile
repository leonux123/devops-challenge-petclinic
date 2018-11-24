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
	        sh 'echo "Task: Deliver for DEV"'
            }
        }
        stage('Deliver for PROD') {
            when {
                branch 'master' 
            }
            steps {
	        sh 'echo "AWS Provisioning Task: Started"'
		    sh './jenkins/scripts/EC2_on-demand.sh start'
            }
        }
    }
}
