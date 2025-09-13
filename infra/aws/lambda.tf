data "aws_iam_policy_document" "lambda_assume" {
  statement {
    actions = ["sts:AssumeRole"]
    principals { type = "Service" identifiers = ["lambda.amazonaws.com"] }
  }
}

resource "aws_iam_role" "cir_lambda_role" {
  name               = "cir-demo-lambda-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume.json
}

resource "aws_iam_role_policy_attachment" "basic_exec" {
  role       = aws_iam_role.cir_lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_lambda_function" "cir_translator" {
  function_name = "cir-demo-translator"
  role          = aws_iam_role.cir_lambda_role.arn
  handler       = "app.lambda_handler"
  runtime       = "python3.12"
  filename      = "${path.module}/lambda.zip"

  environment {
    variables = {
      GCP_TRANSLATOR_URL = var.gcp_translator_url
    }
  }

  depends_on = [aws_iam_role_policy_attachment.basic_exec]
}

resource "aws_cloudwatch_event_rule" "cir_demo" {
  name          = "cir-demo"
  event_pattern = jsonencode({ "source": ["cir.demo"] })
}

resource "aws_cloudwatch_event_target" "cir_demo_target" {
  rule = aws_cloudwatch_event_rule.cir_demo.name
  arn  = aws_lambda_function.cir_translator.arn
}

resource "aws_lambda_permission" "allow_events" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.cir_translator.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.cir_demo.arn
  statement_id  = "AllowEventInvoke"
}

output "event_rule_arn" { value = aws_cloudwatch_event_rule.cir_demo.arn }
