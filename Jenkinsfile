 pipeline {
    agent {
        kubernetes {
            yaml '''
apiVersion: v1
kind: Pod
spec:
  securityContext:
    runAsUser: 1000
  containers:
  - name: openjdk11
    image: adoptopenjdk/openjdk11
    command:
    - cat
    tty: true
'''
            defaultContainer 'jnlp'
        }
    }
    stages {
     
       stage('Gradle Build Output stash') {
            steps {
                container(name: 'openjdk11') {
                    sh '''
                    chmod +x gradlew
                    ./gradlew build --stacktrace
                    pwd
                    ls -al build/
                    '''
                    stash name:'buildoutput', includes: 'build/**/*'
                }
            }
        }
        stage('Docker Image build & Push') {
            agent {
                    kubernetes {
            yaml '''
apiVersion: v1
kind: Pod
spec:
  securityContext:
    runAsUser: 0
  containers:
  - name: kaniko
    image: gcr.io/kaniko-project/executor:debug
    command:
    - /busybox/cat
    tty: true
    volumeMounts:
    - name: docker-config
      mountPath: /kaniko/.docker/
  volumes:
  - name: docker-config
    configMap:
      name: docker-config
'''
                }
            }
            steps {
                container(name: 'kaniko') {
                    unstash 'buildoutput'
                    sh '''
                    pwd
                    ls -al
                    '''
                    sh '/kaniko/executor --context `pwd` --destination 400603430485.dkr.ecr.ap-northeast-2.amazonaws.com/spring-music:latest'
                }
            }
        }
    }
}
