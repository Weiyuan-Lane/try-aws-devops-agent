resource "aws_security_group" "alb_internal" {
  name        = "${local.name_prefix}-alb-internal"
  description = "Internal ALB for Fargate test endpoint"
  vpc_id      = aws_vpc.main.id

  ingress {
    description     = "HTTP from Lambda"
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.lambda.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-alb-internal-sg"
  })
}

resource "aws_security_group" "fargate" {
  name        = "${local.name_prefix}-fargate"
  description = "Fargate tasks for test endpoint"
  vpc_id      = aws_vpc.main.id

  ingress {
    description     = "HTTP from internal ALB"
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_internal.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-fargate-sg"
  })
}

resource "aws_security_group" "lambda" {
  name        = "${local.name_prefix}-lambda"
  description = "Lambda function reaching internal Fargate endpoint"
  vpc_id      = aws_vpc.main.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-lambda-sg"
  })
}
