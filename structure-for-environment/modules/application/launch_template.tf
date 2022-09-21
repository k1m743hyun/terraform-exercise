# Node Group Launch Template
resource "aws_launch_template" "this" {
  for_each        = var.ngroup_value

  name_prefix     = format("lt-${var.tags.Environment}-lt-%s-wrk", each.value.name)
  default_version = each.value.default_version

  image_id        = contains(keys(each.value), "image_id") ? each.value.image_id : ""
  instance_type   = each.value.instance_type

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size           = each.value.volume_size
      volume_type           = "gp3"
      delete_on_termination = true
      encrypted             = true
      #kms_key_id            = var.kms.ebs
    }
  }

  user_data = base64encode(local.lt_userdata)

  # Instance Tag
  tag_specifications {
    resource_type = "instance"

    tags = merge(
      var.tags,
      {
        "Name" = format("${var.tags.Environment}-ec2-%s-wrk", each.value.name)
        "Type" = "ec2"
      }
    )
  }

  # Volume Tag
  tag_specifications {
    resource_type = "volume"

    tags = merge(
      var.tags,
      {
        "Name" = format("${var.tags.Environment}-ebs-%s-wrk", each.value.name)
        "Type" = "ebs"
      }
    )
  }

  # Launch Template Tag
  tags = merge(
    var.tags,
    {
      "Name" = format("${var.tags.Environment}-lt-%s-wrk", each.value.name)
      "Type" = "lt"
    }
  )

  lifecycle {
    create_before_destroy = true
  }
}