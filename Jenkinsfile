pipeline {
  agent any
  environment {
    AWS_REGION = 'ap-south-1'
    ECR_REGISTRY = '051101197314.dkr.ecr.ap-south-1.amazonaws.com'
    FRONTEND_REPO = 'movie-frontend'
    BACKEND_REPO = 'movie-backend'
    ECS_CLUSTER = 'movie-cluster'
    FRONTEND_SERVICE = 'frontend-service'
    BACKEND_SERVICE = 'backend-service'
  }
  stages {
    stage('Clean Workspace') {
            steps {
                cleanWs()
            } 
        }
    stage('Checkout') {
      steps {
        git branch: 'main', url: 'https://github.com/saurav-22/Saurav-Movies-App.git'
      }
    }
    stage('Build Frontend') {
      steps {
        dir('frontend') {
          sh """docker build -t ${ECR_REGISTRY}/${FRONTEND_REPO}:latest ."""
        }
      }
    }
    stage('Build Backend') {
      steps {
        dir('backend') {
          sh """docker build -t ${ECR_REGISTRY}/${BACKEND_REPO}:latest ."""
        }
      }
    }
    stage('Push to ECR') {
      steps {
        sh """
          aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${ECR_REGISTRY}
          docker push ${ECR_REGISTRY}/${FRONTEND_REPO}:latest
          docker push ${ECR_REGISTRY}/${BACKEND_REPO}:latest
        """
      }
    }
    stage('Deploy to ECS') {
      steps { 
          sh """
            aws ecs update-service --cluster ${ECS_CLUSTER} --service ${FRONTEND_SERVICE} --force-new-deployment
            aws ecs update-service --cluster ${ECS_CLUSTER} --service ${BACKEND_SERVICE} --force-new-deployment
          """
      }
    }
  }
}
