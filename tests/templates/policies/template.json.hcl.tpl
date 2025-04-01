${jsonencode({
    "Statement": [
        {
            "Action": [
                "sts:GetCallerIdentity"
            ],
            "Effect": "Allow",
            "Resource": "*",
            "Sid": "PolicyBase"
        },
        {
            "Action": [
                "ec2:GetConsoleScreenShot"
            ],
            "Effect": "Allow",
            "Resource": "arn:${partition}:ec2:${region}:${account_id}:instance/*",
            "Sid": "TemplateVars"
        }
    ],
    "Version": "2012-10-17"
})}
