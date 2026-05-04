# Copyright IBM Corp. 2025, 2026

policy {}

resource_policy "aws_cloudfront_distribution" "s3_origin_access_control_enabled" {
  locals {
    first_origin = core::try(attrs.origin[0], {})

    all_origin_access_controls = core::getresources("aws_cloudfront_origin_access_control", {})

    oac_type_by_id = {
      for oac in local.all_origin_access_controls :
      core::try(oac.id, core::try(oac.attrs.id, "")) => core::try(oac.origin_access_control_origin_type, core::try(oac.attrs.origin_access_control_origin_type, ""))
      if core::try(oac.id, core::try(oac.attrs.id, "")) != ""
    }

    origin_access_control_id = core::try(local.first_origin.origin_access_control_id, "")
    origin_access_control_type = core::try(local.oac_type_by_id[local.origin_access_control_id], "")
  }

  enforcement_level = "advisory"
  enforce {
    condition = local.origin_access_control_id != "" && local.origin_access_control_type == "s3"
    error_message = "CloudFront distribution must have S3 Origin Access Control enabled. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/cloudfront-controls.html#cloudfront-13 for more details."
  }
}
