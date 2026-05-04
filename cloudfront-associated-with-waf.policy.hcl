# Copyright IBM Corp. 2025, 2026

policy {
    
}

resource_policy "aws_cloudfront_distribution" "associated_with_waf" {
locals{
    web_acl_id = core::try(attrs.web_acl_id, null)
    has_web_acl = local.web_acl_id != null && local.web_acl_id != ""
}
    enforcement_level = "advisory"
    enforce {
        condition = local.has_web_acl
        error_message = "CloudFront distribution must be associated with a WAF Web ACL. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/cloudfront-controls.html#cloudfront-6 for more details."
    }
}
