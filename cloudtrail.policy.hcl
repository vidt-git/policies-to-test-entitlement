# Copyright IBM Corp. 2025, 2026

policy {
  
}

resource_policy "aws_cloudtrail" "enable_log_file_validation" {
  enforcement_level = "advisory"
  enforce {
    condition     = core::try(attrs.enable_log_file_validation, false) == true
    error_message = "attr value of this resource must be true. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/cloudtrail-controls.html#cloudtrail-4 for more details."

  }
}

# resource_policy "aws_cloudtrail" "watchdog_enabled" {
#     enforce {
#         condition = attrs.cloud_watch_logs_group_arn != null && attrs.cloud_watch_logs_group_arn != ""
#         error_message = "cloud_watch_logs_group_arn must be set and not empty"
#     }
# }