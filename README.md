# Simple flask app docker container in AWS ECS and Fargate

1. You will need Docker(with sudo permissions) and Terraform on you PC\laptop and of course aws account
    I used my laptop with Ubuntu 18 and my aws account
    By default aws creds store in /home/YOUR_USERNAME/.aws (in my case)
            
              *[terraform]
              *aws_access_key_id = YOUR_KEY_ID
              *aws_secret_access_key = YOU_ACCESS_KEY


2. $cd flask-docker-aws
3. On AWS web concole (https://us-west-2.console.aws.amazon.com/ecr/repositories?region=us-west-2#) you need Create repository with name "flask-docker-aws"
4.Open it "flask-docker-aws"  and push button "view push commands" there you will see commands for build and upload your docker container
  In my account:
    $sudo $(aws ecr get-login --no-include-email --region us-west-2)
    $sudo docker build -t flask-docker-aws .
    $sudo docker tag flask-docker-aws:latest 099698789819.dkr.ecr.us-west-2.amazonaws.com/flask-docker-aws:latest
    $sudo docker push 099698789819.dkr.ecr.us-west-2.amazonaws.com/flask-docker-aws:latest

5. Open repository "flask-docker-aws" in AWS web console and copy link to container in my case it "099698789819.dkr.ecr.us-west-2.amazonaws.com/flask-docker-aws"
    then paste it to flask-docker-aws/terraform/variables.tf in 11 line. Save file.

6. Opent AWS web console IAM  (https://console.aws.amazon.com/iam/home?region=us-west-2#/roles) and create two roles
          All instruction you can find (https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_execution_IAM_role.html)
          One role for ecsTaskExectuionRole
          Another for ecsAutoscaleRole
      Short instruction:
      Create Role -> AWS Service -> Elastic container service -> Elastic Container Service Autoscale -> Next: permissions ->
          -> attache Policy "AmazonEC2ContainerServiceAutoscaleRole" -> Next:Tags ->Next:Review-> name "ecsAutoscaleRole" -> Create Role
      Open this role and copy "Role ARN" ant paste it to terraform/variables.tf  in 26 line. Save file

      Create Role -> AWS Service -> Elastic container service -> Elastic Container Service Task -> Next :permissions ->
          -> attache Policy "AmazonECSTaskExecutionRolePolicy" -> Next:Tags ->Next:Review-> name "ecsTaskExecutionRole"
      Open this role and copy "Role ARN" ant paste it to terraform/variables.tf  in 31 line. Save file -> Create Role

      Come back to root folder "flask-docker-aws"

7. $terraform init terraform/
8. $terraform apply terraform/
9. Type "yes"
10. In the end of execution you will see link which you can run in browser(possible you will need to wait for a couple of minutes, while AWS will end all work), in my case it
    http://flask-lb-1486827826.us-west-2.elb.amazonaws.com/


Improvements for future :
  -analyze ECS cluster, may be will be better us another type of cluster to run infrastructure
  -make automation for build and push docker containers to aws
  -make automation for setup AWS roles
  -check containers before push
  -recheck net configuration
  -analyze CPU utilization, there are some reasons for errors inside container
  -assign real domain for load balancers
  -etc.
