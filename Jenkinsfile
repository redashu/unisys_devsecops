pipeline {
    agent any 
    stages {
        // create stage 1 for fetching git repo info 
        stage('fetching git repo details'){
            // steps 
            steps {
                echo 'fetching git repo'
                git branch: 'springboot', url:'https://github.com/redashu/unisys_devsecops.git'
                sh 'ls'
            }
            
        }
        // creating second stage for doing SAST analysis for any Critical bugs
        stage('SAST using trivy for Critical vulns'){
            steps {
                echo 'using trivy to scan code pushed by developer'
                sh 'trivy  fs --scanners  vuln,secret,misconfig  .'
            }
        }
        // using compsoe to build and test
        stage('building image with compose'){
            steps {
                echo 'running docker compose'
                sh 'docker-compose down'
                sh 'docker-compose up -d --build'
                sh 'docker-compose ps'
            }
        }
        // pushing image to dockerhub 
        stage('image rebuild and push'){
            steps {
                echo 'using docker pipeline plugin to build and push image'
                script {
                    def imageName = "dockerashu/ashujava"
                    def imageTag  = "tomcatdeploy$BUILD_NUMBER"
                    def ashuCred = "480087f2-27c4-4acf-b208-19b1e0b0cf57"
                    // building image 
                    docker.build(imageName + ":" + imageTag , " -f Dockerfile .")
                    // pushing image 
                    docker.withRegistry('https://registry.hub.docker.com',ashuCred){
                        docker.image(imageName + ":" + imageTag).push()
                    }
                }
            }
            
        }
        // testing kubectl connection 
        stage('checking connection with kubectl to AKS'){
            steps {
                echo 'kubectl version using it'
                sh 'kubectl get nodes'
                sh 'kubectl version'
            }
        }
        // deploying app using deploy and expose using service 
        stage('deploy yaml files'){
            steps {
                echo 'using kubectl to deploy'
                sh 'kubectl apply -f deploy1.yaml -f service.yaml'
                sh 'kubectl get deploy,pod,service'
            }
        }
        // app upgrade
        stage('upgrade'){
            steps {
                echo 'upgrading to current iamge'
                sh 'kubectl set image deployment ashu-tomcat ashujava=dockerashu/ashujava:tomcatdeploy$BUILD_NUMBER'
            }
        }

    }
}