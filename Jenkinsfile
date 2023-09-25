pipeline {
    agent any
    environment {
        ANSIBLE_SERVER = "167.99.136.157"
    }
    stages {
        stage("copy files to ansible server") {
            steps {
                script {
                    echo "copying all neccessary files to ansible control node"
                    sshagent(['ansible-server-key']) {
                        sh "scp -o StrictHostKeyChecking=no ansible/* root@159.89.165.97:/root"

                        withCredentials([sshUserPrivateKey(credentialsId: 'ec2-server-key', keyFileVariable: 'keyfile', usernameVariable: 'user')]) {
                            sh 'scp $keyfile root@159.89.165.97:/root/ssh-key.pem'
                        }
                    }
                }
            }
        }
    }
}
