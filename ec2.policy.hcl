# Copyright IBM Corp. 2025, 2026

policy{
    
    plugins {
        sample={
            source="../plugin/plugin_binary"
        }
    } 
}

resource_policy "aws_instance" "ami" {

    locals{
        ami = core::getdatasource("aws_ami", {
            filter = [{
                name = "image-id"
                values = [attrs.ami]
            }]
        })

        hello = plugin::sample::echo("hello world")

    }

    enforcement_level = "advisory"
    enforce {
        condition = local.ami[*].name == "ubuntu-eks/k8s_1.31/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-20250626"
        error_message = "only ubutu image are allowed ${local.hello}"
    }
}