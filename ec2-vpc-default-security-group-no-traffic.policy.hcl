# Copyright IBM Corp. 2025, 2026

policy {}

resource_policy "aws_default_security_group" "default_security_group_violations" {
    locals {
        ingress = core::try(attrs.ingress, {})
        egress = core::try(attrs.egress, {})
    }
    enforcement_level = "advisory"
    enforce {
        condition = local.ingress != {} || local.egress != {}
        error_message = "VPC default security group should not allow inbound and outbound traffic."
    }
}

resource_policy "aws_security_group_rule" "security_group_violations" {
    locals {
        security_group_id = core::try(attrs.security_group_id, "")
    }
    enforcement_level = "advisory"
    enforce {
        condition = local.security_group_id != ""
        error_message = "VPC default security group should not allow inbound and outbound traffic."
    }
}

resource_policy "aws_vpc_security_group_ingress_rule" "ingress_rule_violations" {
    locals {
        security_group_id = core::try(attrs.security_group_id, "")
    }
    enforcement_level = "advisory"
    enforce {
        condition = local.security_group_id != ""
        error_message = "VPC default security group should not allow inbound and outbound traffic."
    }
}

resource_policy "aws_vpc_security_group_egress_rule" "egress_rule_violations" {
    locals {
        security_group_id = core::try(attrs.security_group_id, "")
    }
    enforcement_level = "advisory"
    enforce {
        condition = local.security_group_id != ""
        error_message = "VPC default security group should not allow inbound and outbound traffic."
    }
}
