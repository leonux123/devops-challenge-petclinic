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
	            	sh 'echo "Task: Build"'
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
	        sh 'echo "Task: Deliver for PROD"'
            }
        }
    }
}
