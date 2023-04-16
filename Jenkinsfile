def gitBranch = "latest"
def gitURL = "git@github.com:Memphisdev/memphis-docker.git"
def repoUrlPrefix = "memphisos"
import hudson.model.*
import groovy.transform.Field

node {
  git credentialsId: 'main-github', url: gitURL, branch: gitBranch
  
  try{

    stage('Login to Docker Hub') {
      withCredentials([usernamePassword(credentialsId: 'docker-hub', usernameVariable: 'DOCKER_HUB_CREDS_USR', passwordVariable: 'DOCKER_HUB_CREDS_PSW')]) {
      sh 'docker login -u $DOCKER_HUB_CREDS_USR -p $DOCKER_HUB_CREDS_PSW'
      }
    }
    
    stage('Import version number from broker'){
      dir('memphis-broker'){
        git credentialsId: 'main-github', url: 'git@github.com:memphisdev/memphis-broker.git', branch: gitBranch
      }
      sh """
        cat memphis-broker/version.conf | cut -d "-" -f1 > version.conf
        rm -rf memphis-broker
      """
    }
    
    stage('Checkout to version branch'){
      withCredentials([sshUserPrivateKey(keyFileVariable:'check',credentialsId: 'main-github')]) {
        sh "git reset --hard origin/latest" //change to latest
        sh"""
          GIT_SSH_COMMAND='ssh -i $check'  git checkout -b v\$(cat version.conf)
          GIT_SSH_COMMAND='ssh -i $check'  git push --set-upstream origin v\$(cat version.conf)
        """
      }
    }

    stage('Create new release') {
      sh 'sudo yum-config-manager --add-repo https://cli.github.com/packages/rpm/gh-cli.repo'
      sh 'sudo yum install gh -y'
      sh 'sudo yum install jq -y'
      withCredentials([string(credentialsId: 'gh_token', variable: 'GH_TOKEN')]) {
        sh(script:"""gh release create v\$(cat version.conf) --generate-notes --target latest""", returnStdout: true)
      }
    }
    
    stage('Merge to gh-pages'){

    }

    notifySuccessful()
  
  }
    catch (e) {
      currentBuild.result = "FAILED"
      cleanWs()
      notifyFailed()
      throw e
  }
}
 def notifySuccessful() {
  emailext (
      subject: "SUCCESSFUL: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'",
      body: """SUCCESSFUL: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]':
        Check console output and connection attributes at ${env.BUILD_URL}""",
      recipientProviders: [requestor()]
    )
}
def notifyFailed() {
  emailext (
      subject: "FAILED: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'",
      body: """FAILED: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]':
        Check console output at ${env.BUILD_URL}""",
      recipientProviders: [requestor()]
    )
}  
