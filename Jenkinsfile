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
                stash name:'buildoutput', includes: 'output/**/*'
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
                    sh '/kaniko/executor --context `pwd` --destination public.ecr.aws/o4u2o3b3/spring-music:latest'
                }
            }
        }
    }
}
