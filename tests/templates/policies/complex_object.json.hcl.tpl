${jsonencode({
    "Statement": [
        {
            "Condition": {
                "ForAnyValue:StringNotLike": {
                    "aws:RequestedRegion": allowed_regions
                }
            },
            "Effect": "Deny",
            "NotAction": [
                "resource-explorer:*"
            ],
            "Resource": "*",
            "Sid": "RestrictRegions"
        },
        {
            "Action": [
                "ec2:GetConsoleScreenShot"
            ],
            "Effect": "Allow",
            "Resource": instance_arns,
            "Sid": "ComplexTemplateVars"
        }
    ],
    "Version": "2012-10-17"
})}
