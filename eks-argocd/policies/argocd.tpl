{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "secretsmanager:GetSecretValue", 
        "secretsmanager:DescribeSecret"
      ],
      "Resource": [
        "arn:aws:secretsmanager:*:413968250213:secret:/eks/secret/argocd/*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "ssm:DescribeParameter*", 
        "ssm:GetParameter*"
      ],
      "Resource": [
        "arn:aws:ssm:*:413968250213:parameter/eks/secret/argocd/*"
      ]
    }
  ]
}