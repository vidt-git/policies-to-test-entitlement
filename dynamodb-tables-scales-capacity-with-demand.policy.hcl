# Copyright IBM Corp. 2025, 2026

policy {

}

resource_policy "aws_dynamodb_table" "dynamodb_table_sacale_target" {
    locals {
        aws_appautoscaling_read_target  = core::getresources("aws_appautoscaling_target", {
            scalable_dimension = "dynamodb:table:ReadCapacityUnits"
        })

        aws_appautoscaling_write_target = core::getresources("aws_appautoscaling_target", {
            scalable_dimension = "dynamodb:table:WriteCapacityUnits"
        })

        aws_appautoscaling_read_policy  = core::getresources("aws_appautoscaling_policy", {
            scalable_dimension = "dynamodb:table:ReadCapacityUnits"
        })

        aws_appautoscaling_write_policy = core::getresources("aws_appautoscaling_policy", {
            scalable_dimension = "dynamodb:table:WriteCapacityUnits"
        })

        is_read_target_valid  = core::length(local.aws_appautoscaling_read_target) > 0 ? local.aws_appautoscaling_read_target[0].min_capacity >= 1 && local.aws_appautoscaling_read_target[0].max_capacity <= 40000 : false
        is_write_target_valid = core::length(local.aws_appautoscaling_write_target) > 0 ? local.aws_appautoscaling_write_target[0].min_capacity >= 1 && local.aws_appautoscaling_write_target[0].max_capacity <= 40000 : false
        read_policy  = core::length(local.aws_appautoscaling_read_policy) > 0 ? local.aws_appautoscaling_read_policy[0].target_tracking_scaling_policy_configuration : []
        write_policy = core::length(local.aws_appautoscaling_write_policy) > 0 ? local.aws_appautoscaling_write_policy[0].target_tracking_scaling_policy_configuration : []
        is_write_policy_valid = core::length(local.write_policy) > 0 ? local.write_policy[0].target_value >= 20 && local.write_policy[0].target_value <= 90 : false
        is_read_policy_valid  = core::length(local.read_policy) > 0 ? local.read_policy[0].target_value >= 20 && local.read_policy[0].target_value <= 90 : false
        
    }
    
    enforcement_level = "advisory"
    enforce {

        condition = local.is_read_target_valid && local.is_write_target_valid && local.is_read_policy_valid && local.is_write_policy_valid
        error_message = "Autoscaling is not enabled for 'aws_dynamodb_table' resources.Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/dynamodb-controls.html#dynamodb-1 for more details."
    }
}
