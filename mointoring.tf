resource "aws_cloudwatch_metric_alarm" "high_cpu" {
  alarm_name          = "cloudcart-high-cpu"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 5
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Average"
  threshold           = 70
  alarm_description   = "Alarm if average CPU > 70% for 5 minutes"
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.asg.name
  }
  alarm_actions = [var.sns_topic_arn] # create SNS topic and subscribe email/ops
}
 
