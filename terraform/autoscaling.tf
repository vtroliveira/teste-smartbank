resource "aws_launch_configuration" "smartbank-web-app-cluster" {
    name                = "smartbank-web-app-launch-configuration"
    image_id            =  "${var.ami_id}"
    instance_type       = "${var.web_app_instance_type}"
    security_groups     = ["${aws_security_group.smartbank-web-app-sg.id}"]
    key_name            = "${aws_key_pair.smartbank_key.key_name}"

    lifecycle {
        create_before_destroy = true
    }
}

resource "aws_autoscaling_group" "smartbank-web-app-scaling-group" {
    name                        = "smartbank-web-app-scaling-group"
    launch_configuration        = "${aws_launch_configuration.smartbank-web-app-cluster.name}"
    vpc_zone_identifier         = ["${aws_subnet.public_subnet_1.id}", "${aws_subnet.public_subnet_2.id}"]
    min_size                    = 1
    max_size                    = 4
    enabled_metrics             = ["GroupMinSize", "GroupMaxSize", "GroupDesiredCapacity", "GroupInServiceInstances", "GroupTotalInstances"]
    metrics_granularity         = "1Minute"
    target_group_arns           = ["${aws_lb_target_group.smartbank-web-app-tg.arn}"]
    health_check_type           = "ELB"
}

resource "aws_autoscaling_policy" "smartbank-auto-policy" {
    name = "smartbank-auto-policy"
    scaling_adjustment      = 1
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 300
    autoscaling_group_name  = "${aws_autoscaling_group.smartbank-web-app-scaling-group.name}"
}

resource "aws_cloudwatch_metric_alarm" "smartbank-web-app-cpu-alarm" {
    alarm_name              = "smartbank-web-app-cpu-alarm"
    comparison_operator     = "GreaterThanOrEqualToThreshold"
    evaluation_periods      = "2"
    metric_name             = "CPUUtilization"
    namespace               = "AWS/EC2"
    period                  = "120"
    statistic               = "Average"
    threshold               = "60"

    dimensions {
        AutoScalingGroupName = "${aws_autoscaling_group.smartbank-web-app-scaling-group.name}"
    }

    alarm_description = "This metric monitor EC2 web app instance cpu utilization"
    alarm_actions = ["${aws_autoscaling_policy.smartbank-auto-policy.arn}"]
}

resource "aws_autoscaling_policy" "smartbank-auto-policy-down" {
    name                    = "smartbank-auto-policy-down"
    scaling_adjustment      = -1
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 300
    autoscaling_group_name  = "${aws_autoscaling_group.smartbank-web-app-scaling-group.name}"
}

resource "aws_cloudwatch_metric_alarm" "smartbank-cpu-alarm-down" {
    alarm_name              = "smartbank-cpu-alarm-down"
    comparison_operator     = "LessThanOrEqualToThreshold"
    evaluation_periods      = "2"
    metric_name             = "CPUUtilization"
    namespace               = "AWS/EC2"
    period                  = "120"
    statistic               = "Average"
    threshold               = "10"

    dimensions {
        AutoScalingGroupName = "${aws_autoscaling_group.smartbank-web-app-scaling-group.name}"
    }

    alarm_description = "This metric monitor EC2 web app instance cpu utilization"
    alarm_actions = ["${aws_autoscaling_policy.smartbank-auto-policy-down.arn}"]
}