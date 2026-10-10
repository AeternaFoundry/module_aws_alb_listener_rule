variable "alb_listener_rules" {
  description = <<EOT
Map of alb_listener_rules, attributes below
Required:
    - listener_arn
    - action (block):
        - authenticate_cognito (optional, block):
            - authentication_request_extra_params (optional)
            - on_unauthenticated_request (optional)
            - scope (optional)
            - session_cookie_name (optional)
            - session_timeout (optional)
            - user_pool_arn (required)
            - user_pool_client_id (required)
            - user_pool_domain (required)
        - authenticate_oidc (optional, block):
            - authentication_request_extra_params (optional)
            - authorization_endpoint (required)
            - client_id (required)
            - client_secret (required)
            - issuer (required)
            - on_unauthenticated_request (optional)
            - scope (optional)
            - session_cookie_name (optional)
            - session_timeout (optional)
            - token_endpoint (required)
            - user_info_endpoint (required)
        - fixed_response (optional, block):
            - content_type (required)
            - message_body (optional)
            - status_code (optional)
        - forward (optional, block):
            - stickiness (optional, block):
                - duration (required)
                - enabled (optional)
            - target_group (required, block):
                - arn (required)
                - weight (optional)
        - jwt_validation (optional, block):
            - additional_claim (optional, block):
                - format (required)
                - name (required)
                - values (required)
            - issuer (required)
            - jwks_endpoint (required)
        - order (optional)
        - redirect (optional, block):
            - host (optional)
            - path (optional)
            - port (optional)
            - protocol (optional)
            - query (optional)
            - status_code (required)
        - target_group_arn (optional)
        - type (required)
    - condition (block):
        - host_header (optional, block):
            - regex_values (optional)
            - values (optional)
        - http_header (optional, block):
            - http_header_name (required)
            - regex_values (optional)
            - values (optional)
        - http_request_method (optional, block):
            - values (required)
        - path_pattern (optional, block):
            - regex_values (optional)
            - values (optional)
        - query_string (optional, block):
            - key (optional)
            - value (required)
        - source_ip (optional, block):
            - values (required)
Optional:
    - priority
    - region
    - tags
    - tags_all
    - transform (block):
        - host_header_rewrite_config (optional, block):
            - rewrite (optional, block):
                - regex (required)
                - replace (required)
        - type (required)
        - url_rewrite_config (optional, block):
            - rewrite (optional, block):
                - regex (required)
                - replace (required)
EOT

  type = map(object({
    listener_arn = string
    priority     = optional(number)
    region       = optional(string)
    tags         = optional(map(string))
    tags_all     = optional(map(string))
    action = list(object({
      authenticate_cognito = optional(object({
        authentication_request_extra_params = optional(map(string))
        on_unauthenticated_request          = optional(string)
        scope                               = optional(string)
        session_cookie_name                 = optional(string)
        session_timeout                     = optional(number)
        user_pool_arn                       = string
        user_pool_client_id                 = string
        user_pool_domain                    = string
      }))
      authenticate_oidc = optional(object({
        authentication_request_extra_params = optional(map(string))
        authorization_endpoint              = string
        client_id                           = string
        client_secret                       = string
        issuer                              = string
        on_unauthenticated_request          = optional(string)
        scope                               = optional(string)
        session_cookie_name                 = optional(string)
        session_timeout                     = optional(number)
        token_endpoint                      = string
        user_info_endpoint                  = string
      }))
      fixed_response = optional(object({
        content_type = string
        message_body = optional(string)
        status_code  = optional(string)
      }))
      forward = optional(object({
        stickiness = optional(object({
          duration = number
          enabled  = optional(bool)
        }))
        target_group = list(object({
          arn    = string
          weight = optional(number)
        }))
      }))
      jwt_validation = optional(object({
        additional_claim = optional(list(object({
          format = string
          name   = string
          values = set(string)
        })))
        issuer        = string
        jwks_endpoint = string
      }))
      order = optional(number)
      redirect = optional(object({
        host        = optional(string)
        path        = optional(string)
        port        = optional(string)
        protocol    = optional(string)
        query       = optional(string)
        status_code = string
      }))
      target_group_arn = optional(string)
      type             = string
    }))
    condition = list(object({
      host_header = optional(object({
        regex_values = optional(set(string))
        values       = optional(set(string))
      }))
      http_header = optional(object({
        http_header_name = string
        regex_values     = optional(set(string))
        values           = optional(set(string))
      }))
      http_request_method = optional(object({
        values = set(string)
      }))
      path_pattern = optional(object({
        regex_values = optional(set(string))
        values       = optional(set(string))
      }))
      query_string = optional(list(object({
        key   = optional(string)
        value = string
      })))
      source_ip = optional(object({
        values = set(string)
      }))
    }))
    transform = optional(list(object({
      host_header_rewrite_config = optional(object({
        rewrite = optional(object({
          regex   = string
          replace = string
        }))
      }))
      type = string
      url_rewrite_config = optional(object({
        rewrite = optional(object({
          regex   = string
          replace = string
        }))
      }))
    })))
  }))
  validation {
    condition = alltrue([
      for k, v in var.alb_listener_rules : (
        length(v.action) >= 1
      )
    ])
    error_message = "Each action list must contain at least 1 items"
  }
  validation {
    condition = alltrue([
      for k, v in var.alb_listener_rules : (
        alltrue([for item in v.action : (item.forward == null || (length(item.forward.target_group) >= 1 && length(item.forward.target_group) <= 5))])
      )
    ])
    error_message = "Each target_group list must contain between 1 and 5 items"
  }
  validation {
    condition = alltrue([
      for k, v in var.alb_listener_rules : (
        alltrue([for item in v.action : (item.jwt_validation == null || (item.jwt_validation.additional_claim == null || (length(item.jwt_validation.additional_claim) <= 10)))])
      )
    ])
    error_message = "Each additional_claim list must contain at most 10 items"
  }
  validation {
    condition = alltrue([
      for k, v in var.alb_listener_rules : (
        length(v.condition) >= 1
      )
    ])
    error_message = "Each condition list must contain at least 1 items"
  }
  validation {
    condition = alltrue([
      for k, v in var.alb_listener_rules : (
        v.transform == null || (length(v.transform) <= 2)
      )
    ])
    error_message = "Each transform list must contain at most 2 items"
  }
  validation {
    condition = alltrue([
      for k, v in var.alb_listener_rules : (
        v.transform == null || alltrue([for item in v.transform : (item.host_header_rewrite_config == null || (item.host_header_rewrite_config.rewrite == null || (length(item.host_header_rewrite_config.rewrite.regex) >= 1 && length(item.host_header_rewrite_config.rewrite.regex) <= 1024)))])
      )
    ])
    error_message = "must be between 1 and 1024 characters"
  }
  validation {
    condition = alltrue([
      for k, v in var.alb_listener_rules : (
        v.transform == null || alltrue([for item in v.transform : (item.host_header_rewrite_config == null || (item.host_header_rewrite_config.rewrite == null || (length(item.host_header_rewrite_config.rewrite.replace) >= 0 && length(item.host_header_rewrite_config.rewrite.replace) <= 1024)))])
      )
    ])
    error_message = "must be between 0 and 1024 characters"
  }
  validation {
    condition = alltrue([
      for k, v in var.alb_listener_rules : (
        v.transform == null || alltrue([for item in v.transform : (item.url_rewrite_config == null || (item.url_rewrite_config.rewrite == null || (length(item.url_rewrite_config.rewrite.regex) >= 1 && length(item.url_rewrite_config.rewrite.regex) <= 1024)))])
      )
    ])
    error_message = "must be between 1 and 1024 characters"
  }
  validation {
    condition = alltrue([
      for k, v in var.alb_listener_rules : (
        v.transform == null || alltrue([for item in v.transform : (item.url_rewrite_config == null || (item.url_rewrite_config.rewrite == null || (length(item.url_rewrite_config.rewrite.replace) >= 0 && length(item.url_rewrite_config.rewrite.replace) <= 1024)))])
      )
    ])
    error_message = "must be between 0 and 1024 characters"
  }
  # Note: 33 additional provider-side validators are enforced at apply time but not mirrored as validation{} blocks here (bespoke or non-mechanically-translatable).
}

