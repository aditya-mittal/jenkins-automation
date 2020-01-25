resource "aws_iam_role" "jenkins" {
  name        = "${local.name_prefix}-jenkins-iam-role"
  description = "IAM role attached to Jenkins"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

  tags = merge(
    map(
      "Name", "${local.name_prefix}-jenkins-iam-role"
    ),
    local.common_tags
  )
}

resource "aws_iam_role_policy_attachment" "ecr_readonly_policy" {
  role       = aws_iam_role.jenkins.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_iam_instance_profile" "jenkins" {
  name = aws_iam_role.jenkins.name
  role = aws_iam_role.jenkins.name
}