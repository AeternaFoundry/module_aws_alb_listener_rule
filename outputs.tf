output "alb_listener_rules_id" {
  description = "Map of id values across all alb_listener_rules, keyed the same as var.alb_listener_rules"
  value       = { for k, v in aws_alb_listener_rule.alb_listener_rules : k => v.id if v.id != null && length(v.id) > 0 }
}
output "alb_listener_rules_action" {
  description = "Map of action values across all alb_listener_rules, keyed the same as var.alb_listener_rules"
  value       = { for k, v in aws_alb_listener_rule.alb_listener_rules : k => v.action if v.action != null && length(v.action) > 0 }
  sensitive   = true
}
output "alb_listener_rules_arn" {
  description = "Map of arn values across all alb_listener_rules, keyed the same as var.alb_listener_rules"
  value       = { for k, v in aws_alb_listener_rule.alb_listener_rules : k => v.arn if v.arn != null && length(v.arn) > 0 }
}
output "alb_listener_rules_condition" {
  description = "Map of condition values across all alb_listener_rules, keyed the same as var.alb_listener_rules"
  value       = { for k, v in aws_alb_listener_rule.alb_listener_rules : k => v.condition if v.condition != null && length(v.condition) > 0 }
}
output "alb_listener_rules_listener_arn" {
  description = "Map of listener_arn values across all alb_listener_rules, keyed the same as var.alb_listener_rules"
  value       = { for k, v in aws_alb_listener_rule.alb_listener_rules : k => v.listener_arn if v.listener_arn != null && length(v.listener_arn) > 0 }
}
output "alb_listener_rules_priority" {
  description = "Map of priority values across all alb_listener_rules, keyed the same as var.alb_listener_rules"
  value       = { for k, v in aws_alb_listener_rule.alb_listener_rules : k => v.priority if v.priority != null }
}
output "alb_listener_rules_region" {
  description = "Map of region values across all alb_listener_rules, keyed the same as var.alb_listener_rules"
  value       = { for k, v in aws_alb_listener_rule.alb_listener_rules : k => v.region if v.region != null && length(v.region) > 0 }
}
output "alb_listener_rules_tags" {
  description = "Map of tags values across all alb_listener_rules, keyed the same as var.alb_listener_rules"
  value       = { for k, v in aws_alb_listener_rule.alb_listener_rules : k => v.tags if v.tags != null && length(v.tags) > 0 }
}
output "alb_listener_rules_tags_all" {
  description = "Map of tags_all values across all alb_listener_rules, keyed the same as var.alb_listener_rules"
  value       = { for k, v in aws_alb_listener_rule.alb_listener_rules : k => v.tags_all if v.tags_all != null && length(v.tags_all) > 0 }
}
output "alb_listener_rules_transform" {
  description = "Map of transform values across all alb_listener_rules, keyed the same as var.alb_listener_rules"
  value       = { for k, v in aws_alb_listener_rule.alb_listener_rules : k => v.transform if v.transform != null && length(v.transform) > 0 }
}

