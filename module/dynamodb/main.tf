#--------------------------------------------------------------
# DynamoDB
#--------------------------------------------------------------

resource "aws_dynamodb_table" "metadata_table" {
  name           = "${var.env}-metadata-table"
  billing_mode   = "PROVISIONED"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "user-id"
  range_key      = "file-name"

  attribute {
    name = "user-id"
    type = "S"
  }

  attribute {
    name = "file-name"
    type = "S"
  }

  # LSIの定義
  local_secondary_index {
    name            = "file-name-index"
    range_key       = "file-name"
    projection_type = "ALL"
  }
}


# https://repost.aws/ja/knowledge-center/dynamodb-auto-scaling
resource "aws_appautoscaling_target" "read_scale_out" {
  max_capacity       = var.max_capacity
  min_capacity       = var.min_capacity
  resource_id        = "table/${aws_dynamodb_table.metadata_table.name}"
  scalable_dimension = "dynamodb:table:ReadCapacityUnits"
  service_namespace  = "dynamodb"
}

resource "aws_appautoscaling_policy" "dynamodb_table_read_policy" {
  name               = "DynamoDBReadCapacityUtilization:${aws_appautoscaling_target.read_scale_out.resource_id}"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.read_scale_out.resource_id
  scalable_dimension = aws_appautoscaling_target.read_scale_out.scalable_dimension
  service_namespace  = aws_appautoscaling_target.read_scale_out.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "DynamoDBReadCapacityUtilization"
    }

    target_value = var.target_value
  }
}

resource "aws_appautoscaling_target" "write_scale_out" {
  max_capacity       = var.max_capacity
  min_capacity       = var.min_capacity
  resource_id        = "table/${aws_dynamodb_table.metadata_table.name}"
  scalable_dimension = "dynamodb:table:WriteCapacityUnits"
  service_namespace  = "dynamodb"
}

resource "aws_appautoscaling_policy" "write_policy" {
  name               = "DynamoDBWriteCapacityUtilization:${aws_appautoscaling_target.write_scale_out.resource_id}"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.write_scale_out.resource_id
  scalable_dimension = aws_appautoscaling_target.write_scale_out.scalable_dimension
  service_namespace  = aws_appautoscaling_target.write_scale_out.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "DynamoDBWriteCapacityUtilization"
    }

    target_value = var.target_value
  }
}