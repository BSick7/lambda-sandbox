resource "aws_lambda_function" "sandbox" {
  function_name    = "bsickles-sandbox"
  runtime          = "go1.x"
  handler          = "sandbox"
  filename         = "dist/sandbox.zip"
  source_code_hash = "${base64sha256(file("dist/sandbox.zip"))}"
  role             = "${aws_iam_role.sandbox.arn}"
}

resource "aws_iam_role" "sandbox" {
  name               = "bsickles-sandbox"
  assume_role_policy = "${data.aws_iam_policy_document.sandbox-assume.json}"
}

data "aws_iam_policy_document" "sandbox-assume" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "sandbox-cloudwatch" {
  role       = "${aws_iam_role.sandbox.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}