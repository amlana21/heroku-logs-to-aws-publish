pipeline{
    agent any
    environment{
        AWS_ACCESS_KEY_ID=""
        AWS_SECRET_ACCESS_KEY=""
        AWS_DEFAULT_REGION="us-east-1"
        REGISTRY_URL='container_registry url'
        EC2KEY="keyp"
        IMAGE_CREDS = credentials('gitlabimagereg')
        
    }

    stages{
        stage('build image'){
            steps{
                sh 'docker login registry.gitlab.com -u $IMAGE_CREDS_USR -p $IMAGE_CREDS_PSW'
                sh  '''cd Dockerfiles
                       ls -a
                       docker build --no-cache -t $REGISTRY_URL/streamherokulogs:1.0 .
                       docker push $REGISTRY_URL/streamherokulogs:1.0'''  
            }
            post{
                failure{
                    echo 'this failed build'
                   
                }
                success{
                    echo 'this is a success'
                     
                }
            }

        }
        stage('launch instance'){
            steps{
                script {
                    env.STACKID = sh(label:'',script:"aws cloudformation create-stack --stack-name herokulogsinstance-$BUILD_NUMBER --template-body file://$PWD/workspace/${currentBuild.projectName}/deploy_ec2_log_instance.json --capabilities CAPABILITY_IAM --parameters ParameterKey=KeyP,ParameterValue=${env.EC2KEY} ParameterKey=InstanceType,ParameterValue=t2.micro --query StackId",returnStdout: true).trim()
                    env.STACKSTATUS=sh(label:'',script:"aws cloudformation describe-stacks --stack-name ${env.STACKID} --query Stacks[0].StackStatus",returnStdout: true).trim()
                        while("${env.STACKSTATUS}"=='"CREATE_IN_PROGRESS"'){
                            sleep(20)
                            env.STACKSTATUS=sh(label:'',script:"aws cloudformation describe-stacks --stack-name ${env.STACKID} --query Stacks[0].StackStatus",returnStdout: true).trim()
                        }
                        env.INSTIP=sh(label:'',script:"aws cloudformation describe-stacks --stack-name ${env.STACKID} --query Stacks[0].Outputs[1].OutputValue",returnStdout: true).trim()
                        env.INSTID=sh(label:'',script:"aws cloudformation describe-stacks --stack-name ${env.STACKID} --query Stacks[0].Outputs[0].OutputValue",returnStdout: true).trim()
                        env.INSTIP=env.INSTIP.replaceAll('"','')
                        env.INSTID=env.INSTID.replaceAll('"','')
                        env.STACKID=env.STACKID.replaceAll('"','')
                    }
            }
        }
        stage('bootstrap instance'){
            steps{
                 sh '''cd monitorlogs
                 knife bootstrap $INSTIP  --connection-user ec2-user --sudo --yes -i "$PWD/.chef/id_rsa.pem" --node-name monitorlognode-$BUILD_NUMBER --chef-license accept --run-list "role[logsinstance]"'''
               }
            post{
                success{
                    echo 'this was bootstrapped'
                }
                failure{
                    echo 'this was a failure on bootstrap'
                    sh 'aws cloudformation delete-stack --stack-name $STACKID'
                }
            }
        }
    }
}