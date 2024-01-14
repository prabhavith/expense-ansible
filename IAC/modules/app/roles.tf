resource "aws_iam_role" "main" {
  name               = "${var.component}-${var.env}"
  assume_role_policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Action = [
          "ec2:Describe*",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
  inline_policy {
    name = "parameters-read"
    policy = jsonencode({
      "Version": "2012-10-17",
      "Statement": [
        {
          "Sid": "VisualEditor0",
          "Effect": "Allow",
          "Action": [
            "ssm:GetParameters",
            "ssm:GetParameter"
          ],
          "Resource": "arn:aws:ssm:*:180933357369:parameter/*"
        }
      ]
    })
  }
  inline_policy {
    name = "ec2-run"
    policy = jsonencode({
      "Version": "2012-10-17",
      "Statement": [
        {
          "Sid": "VisualEditor0",
          "Effect": "Allow",
          "Action": [
            "ec2:TerminateInstances",
            "ec2:CreateTags",
            "ec2:RunInstances"
          ],
          "Resource": "*"
        }
      ]
    })
  }
  inline_policy {
    name = "prometheus-alertmanager-publish-alert-sns"
    policy = jsonencode({
      "Version": "2012-10-17",
      "Statement": [
        {
          "Sid": "VisualEditor0",
          "Effect": "Allow",
          "Action": "sns:Publish",
          "Resource": "arn:aws:sns:us-east-1:180933357369:Prometheus-alertmanager"
        }
      ]
    })

  }
  inline_policy {
    name = "s3-getobject"
    policy = jsonencode({
      "Version": "2012-10-17",
      "Statement": [
        {
          "Sid": "VisualEditor0",
          "Effect": "Allow",
          "Action": [
            "s3:GetObject",
            "s3:ListBucket"
          ],
          "Resource": [
            "arn:aws:s3:::prometheusalerts",
            "arn:aws:s3:::prometheusalerts/*",
            "arn:aws:s3:::terraterraform-tfstate.backup",
            "arn:aws:s3:::terraform-tfstate.backup/*"
          ]
        }
      ]
    })
  }
  inline_policy {
    name = "s3-put-object"
    policy = jsonencode({
      "Version": "2012-10-17",
      "Statement": [
        {
          "Sid": "VisualEditor0",
          "Effect": "Allow",
          "Action": [
            "s3:PutObject",
            "s3:GetObject",
            "s3:GetObjectTagging",
            "s3:ListBucket",
            "s3:GetBucketOwnershipControls"
          ],
          "Resource": [
            "arn:aws:s3:::prometheusalerts/*",
            "arn:aws:s3:::terraform-tfstate.backup/*",
            "arn:aws:s3:::prometheusalerts",
            "arn:aws:s3:::terraform-tfstate.backup"
          ]
        }
      ]
    })
  }
}

resource "aws_iam_instance_profile" "main" {
  role = aws_iam_role.main.name
}
