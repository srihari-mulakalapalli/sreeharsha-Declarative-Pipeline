pipeline {
    agent any
    stages {
    stage('Packer Build AMI') {
      when {
        expression {
          params.ACTION == 'CREATE IMAGE'
        }
      }
          steps {
            sh 'pwd'
            sh 'ls -al'
            sh 'packer build packer.json'
          }
    }

    stage('Deploy EC2 Server') {
      when {
        expression {
          params.ACTION == 'DEPLOY'
        }
      }
          steps {
            sh 'rm -rf .terraform'
        sh 'terraform init'
            sh 'terraform plan'
            sh 'terraform apply --auto-approve'
          }
    }

        stage('Build Docker Image') {
          when {
        expression {
          params.ACTION == 'DEPLOY'
        }
          }
          steps {
            sh 'docker build -t sreeharshav/devopsb15:${BUILD_NUMBER} .'
          }
        }

        stage('Push Image to Docker Hub') {
          when {
        expression {
          params.ACTION == 'DEPLOY'
        }
          }
          steps {
        sh 'docker push sreeharshav/devopsb15:${BUILD_NUMBER}'
          }
        }

        stage('Deploy to Docker Host') {
          when {
        expression {
          params.ACTION == 'DEPLOY'
        }
          }
          steps {
        sh 'sleep 30s'
            sh 'docker -H tcp://10.1.1.111:2375 stop prodwebapp1 || true'
            sh 'docker -H tcp://10.1.1.111:2375 run --rm -dit --name prodwebapp1 --hostname prodwebapp1 -p 8000:80 sreeharshav/devopsb15:${BUILD_NUMBER}'
          }
        }

        stage('Check WebApp Rechability') {
          when {
        expression {
          params.ACTION == 'DEPLOY'
        }
          }
          steps {
          sh 'sleep 10s'
          sh ' curl http://10.1.1.111:8000'
          }
        }

        stage('Destroy Terraform Config') {
          when {
        expression {
          params.ACTION == 'DESTROY'
        }
          }
          steps {
            sh 'terraform destroy --auto-approve'
          }
        }
    }
}
