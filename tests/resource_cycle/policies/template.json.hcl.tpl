${jsonencode({
    "Statement": [
        {
            "Action": [
                "ec2:GetConsoleScreenShot"
            ],
            "Effect": "Allow",
            "Resource": instance_arns,
            "Sid": "ListOfVars"
        }
    ],
    "Version": "2012-10-17"
  })}
