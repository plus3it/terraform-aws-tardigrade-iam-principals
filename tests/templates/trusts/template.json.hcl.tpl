{
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::${account_id}:root"
            },
            "Sid": "AssumeRoleCrossAccount"
        }
    ],
    "Version": "2012-10-17"
}
