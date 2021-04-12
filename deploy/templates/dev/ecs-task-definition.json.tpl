[
    {
      "name":   "${task_name}",
      "image":  "${image}",
      "cpu":    256,
      "memory": 512,
      "essential": true,
      "portMappings" : [
        {
          "containerPort": 3000, 
          "hostPort"     : 3000
        }
      ]
    }
]