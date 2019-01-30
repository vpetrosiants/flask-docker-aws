variable "aws_reg" {
  default     = "us-west-2"
}

variable "num_az" {
  default     = "2"
}

variable "flask_image" {
  description = "Docker image"
  default     = "099698789819.dkr.ecr.us-west-2.amazonaws.com/flask-docker-aws:latest"
}

variable "flask_port" {
  description = "flask port"
  default     = 80
}

variable "flask_num" {
  description = "Number of containers"
  default     = 3
}

variable "ecs_autoscale_role" {
  description = "Role  ecsAutoscaleRole"
  default     = "arn:aws:iam::099698789819:role/ecsAutoscaleRole"
}

variable "ecs_task_execution_role" {
  description = "Role ecsTaskExecutionRole"
  default     = "arn:aws:iam::099698789819:role/ecsTaskExecutionRole"
}

variable "health_check_path" {
  default = "/"
}

variable "ecs_cpu" {
  default     = "1024"
}

variable "ecs_mem" {
  default     = "2048"
}

# setup provider
provider "aws" {
  shared_credentials_file = "$HOME/.aws/credentials"
  profile                 = "default"
  region                  = "${var.aws_reg}"
}

# setup logs
resource "aws_cloudwatch_log_group" "flask_logs" {
  name              = "/ecs/flask-app"
  retention_in_days = 30

  tags {
    Name = "flask-log-group"
  }
}

resource "aws_cloudwatch_log_stream" "flask_log_stream" {
  name           = "flask-log-stream"
  log_group_name = "${aws_cloudwatch_log_group.flask_logs.name}"
}

# output to console
output "alb_hostname" {
  value = "${aws_alb.main.dns_name}"
}

