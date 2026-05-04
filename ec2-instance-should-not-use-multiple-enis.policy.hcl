# Copyright IBM Corp. 2025, 2026

policy {}

resource_policy "aws_instance" "instance_should_not_use_multiple_enis" {
    locals {
        network_interface = core::try(attrs.network_interface, [])
    }
    enforcement_level = "advisory"
    enforce {
        condition =  core::length(local.network_interface) <= 1
        error_message = "EC2 instance should not use multiple ENIs. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/ec2-controls.html#ec2-17 for more details."
    }
}
