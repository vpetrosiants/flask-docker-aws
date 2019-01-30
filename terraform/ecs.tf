resource "aws_ecs_cluster" "main" {
  name = "flask-cluster"
}

data "template_file" "flask_app" {
  template = "${file("terraform/flask_app.json.tpl")}"

  vars {
    flask_image  = "${var.flask_image}"
    ecs_cpu      = "${var.ecs_cpu}"
    ecs_mem	 = "${var.ecs_mem}"
    aws_reg      = "${var.aws_reg}"
    flask_port   = "${var.flask_port}"
  }
}

resource "aws_ecs_task_definition" "app" {
  family                   = "flask-app-task"
  execution_role_arn       = "${var.ecs_task_execution_role}"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "${var.ecs_cpu}"
  memory                   = "${var.ecs_mem}"
  container_definitions    = "${data.template_file.flask_app.rendered}"
}

resource "aws_ecs_service" "main" {
  name            = "flask-service"
  cluster         = "${aws_ecs_cluster.main.id}"
  task_definition = "${aws_ecs_task_definition.app.arn}"
  desired_count   = "${var.flask_num}"
  launch_type     = "FARGATE"

  network_configuration {
    security_groups  = ["${aws_security_group.ecs_tasks.id}"]
    subnets          = ["${aws_subnet.private.*.id}"]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = "${aws_alb_target_group.app.id}"
    container_name   = "flask-app"
    container_port   = "${var.flask_port}"
  }

  depends_on = [
    "aws_alb_listener.front_end",
  ]
}
