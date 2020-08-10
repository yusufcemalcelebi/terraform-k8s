resource "aws_iam_role" "kops-master" {
  name               = "kops-master-role"
  assume_role_policy = file("${path.module}/assume-role-policy.json")
}

# Then parse through the list using count
resource "aws_iam_policy_attachment" "kops-master-role-attach" {
  name       = "kops-master-role-attachment"
  roles       = [aws_iam_role.kops-master.name]
  count      = length(var.iam_policy_arn)
  policy_arn = var.iam_policy_arn[count.index]
}

resource "aws_iam_instance_profile" "kops-master-profile" {
  name  = "kops-master-profile"
  role = aws_iam_role.kops-master.name
}