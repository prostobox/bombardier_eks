resource "aws_iam_role" "lambda-bomb-role" {
  name = "lambda-bomb-role"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_policy" "policy_for_lambda_bomb_role" {
  name        = "lambda-policy"
  description = "Policy for Lambda role"

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ec2:Describe*",
                "ec2:StopInstances"
            ],
            "Resource": "*"
        }
    ]
}
POLICY
}

resource "aws_iam_policy_attachment" "policy_for_lambda_bomb_role" {
  name       = "policy_for_lambda_bomb_role"
  roles      = [aws_iam_role.lambda-bomb-role.name]
  policy_arn = aws_iam_policy.policy_for_lambda_bomb_role.arn

}

resource "aws_lambda_function" "lambda_bomb_function" {
  function_name    = "lambda-bomb"
  filename         = "lambda-bomb.zip"
  role             = aws_iam_role.lambda-bomb-role.arn
  handler          = "EC2-Stopped-Tagged-Lambda.py"
  source_code_hash = filebase64sha256("lambda-bomb.zip")
  runtime          = "python3.8"
  #  timeout          = var.timeout
  #  memory_size      = var.memory_size
}

resource "aws_cloudwatch_event_rule" "every_fifteen_minutes_rule" {
  name                = "every_fifteen_minutes_rule"
  description         = "Fires every 58 minutes"
  schedule_expression = "rate(58 minutes)"
}

resource "aws_cloudwatch_event_target" "every_fifteen_minutes_target" {
  rule      = aws_cloudwatch_event_rule.every_fifteen_minutes_rule.name
  target_id = "lambda_function_target"
  arn       = aws_lambda_function.lambda_bomb_function.arn
}

resource "aws_lambda_permission" "allow_cloudwatch_to_call_lambada_function" {
  statement_id  = "AllowExecutionFromCloudWatch-lambda-role"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_bomb_function.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.every_fifteen_minutes_rule.arn
}
