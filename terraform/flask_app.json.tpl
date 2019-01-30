[
  {
    "name": "flask-app",
    "image": "${flask_image}",
    "cpu": ${ecs_cpu},
    "memory": ${ecs_mem},
    "networkMode": "awsvpc",
    "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "/ecs/flask-app",
          "awslogs-region": "${aws_reg}",
          "awslogs-stream-prefix": "ecs"
        }
    },
    "portMappings": [
      {
        "containerPort": ${flask_port},
        "hostPort": ${flask_port}
      }
    ]
  }
]