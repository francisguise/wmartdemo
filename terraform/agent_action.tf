# ─────────────────────────────────────────────────────────────────────────────
# Security Patch AI Agent
#
# Port AI agents are stored as entities on the built-in _ai_agent blueprint.
# Creating one here is identical to creating any other entity — no separate
# resource type is needed.
#
# PREREQUISITE: AI Agents must be enabled on your Port account.
# If you don't see an _ai_agent blueprint in Builder, contact Port support
# or check Settings > AI Features.
#
# execution_mode options:
#   "Automatic" — agent acts immediately, no human approval step
#   "Manual"    — agent proposes actions, a human approves each one
#
# For the demo, "Manual" is recommended — it lets you show the approval
# step live and frame it as a governance control.
# ─────────────────────────────────────────────────────────────────────────────

resource "port_entity" "security_patch_agent" {
  identifier = "security-patch-agent"
  title      = "Security Patch Agent"
  blueprint  = "_ai_agent"
  icon       = "Shield"

  properties = {
    string_props = {
      "description" = "Analyses critical vulnerabilities on a service and creates a prioritised remediation PR or Jira ticket. Triggered via the 'Create Security Patch' self-service action."
      "status"      = "active"
      "execution_mode" = "Approval Required"

      # The system prompt defines the agent's persistent character and
      # constraints. The per-invocation prompt (in the action below) adds
      # the live entity context on top of this.
      "prompt" = <<-EOT
        You are a senior security engineer at Walmart. Your role is to analyse
        services with critical vulnerabilities in Port's catalog, construct a
        prioritised remediation plan, and deliver it as a GitHub PR and/or Jira
        ticket depending on the instructions you receive.

        Always:
        - Check the service's regulatory_scope — if PCI-DSS or HIPAA is present,
          always create a Jira ticket regardless of other instructions, as
          compliance requires tracked remediation with an audit trail
        - Group vulnerabilities by affected package before suggesting fixes;
          prioritise by CVSS score, then by exploitability
        - Never auto-merge PRs — open for human review only
        - If critical_vuln_count is 0, close the run as successful with a note
          that no critical vulnerabilities were found
        - Always report back to the Port action run log with a summary and
          direct links to anything created (PR, ticket, etc.)

        You have access to Port's catalog. Use it to retrieve the list of
        snykVulnerability entities related to the service before constructing
        your remediation plan.
      EOT
    }

    array_props = {
      string_items = {
        # Tool patterns — regex that controls what catalog data and actions
        # the agent can access:
        #   ^(list|search|track|describe)_.*  — read access to all catalog entities
        #   ^run_create_security_patch$        — allows the agent to log back to
        #                                        the action run that triggered it
        "tools" = [
          "^(list|search|track|describe)_.*",
          "^run_create_security_patch$"
        ]
      }
    }
  }
}

# ─────────────────────────────────────────────────────────────────────────────
# Self-Service Action — Create Security Patch
#
# A DAY-2 action on the service blueprint. When triggered, it POSTs to the
# agent's invoke endpoint with a prompt that includes live entity data
# injected via Port's template syntax.
# ─────────────────────────────────────────────────────────────────────────────

resource "port_action" "create_security_patch" {
  identifier  = "create_security_patch"
  title       = "Create Security Patch"
  icon        = "Shield"
  description = "Triggers the Security Patch AI agent to analyse this service's critical vulnerabilities and open a prioritised remediation PR or Jira ticket."

  self_service_trigger = {
    operation            = "DAY-2"
    blueprint_identifier = "service"

    user_properties = {
      string_props = {
        "priority" = {
          title       = "Remediation Priority"
          description = "How urgently should this be addressed?"
          required    = true
          default     = "high"
          enum        = ["critical", "high", "medium"]
          enum_colors = {
            critical = "red"
            high     = "orange"
            medium   = "yellow"
          }
        }
        "output_type" = {
          title       = "Output Type"
          description = "How should the agent deliver the remediation?"
          required    = true
          default     = "jira-ticket"
          enum        = ["github-pr", "jira-ticket", "both"]
          enum_colors = {
            "github-pr"   = "blue"
            "jira-ticket" = "purple"
            "both"        = "green"
          }
        }
        "additional_context" = {
          title       = "Additional Context"
          description = "Any extra context the agent should know (e.g. known constraints, affected packages, deployment freeze)"
        }
      }
    }
  }

  webhook_method = {
    url          = "https://api.port.io/v1/agent/${port_entity.security_patch_agent.identifier}/invoke"
    agent        = "false"
    synchronized = true
    method       = "POST"

    headers = {
      "RUN_ID"       = "{{ .run.id }}"
      "Content-Type" = "application/json"
    }

    body = jsonencode({
      prompt = <<-EOT
        A developer has triggered a security patch request. Here is the full
        context for the service you are remediating:

        Service Name:              {{ .entity.title }}
        Service Identifier:        {{ .entity.identifier }}
        Business Criticality:      {{ .entity.properties.business_criticality }}
        Tier:                      {{ .entity.properties.tier }}
        Owning Team:               {{ .entity.properties.owning_team }}
        Data Classification:       {{ .entity.properties.data_classification }}
        Regulatory Scope:          {{ .entity.properties.regulatory_scope }}
        Critical Vulnerability Count: {{ .entity.properties.critical_vuln_count }}
        Production Readiness Score: {{ .entity.properties.production_readiness_score }}
        GitHub Repository:         {{ .entity.relations.repository }}

        Remediation Priority Requested: {{ .inputs.priority }}
        Preferred Output:               {{ .inputs.output_type }}
        Additional Context:             {{ .inputs.additional_context }}

        Steps:
        1. Search Port's catalog for all snykVulnerability entities related
           to service identifier "{{ .entity.identifier }}" with status "open"
           and severity "critical".
        2. Group them by affected package and sort by CVSS score descending.
        3. Construct a prioritised remediation plan.
        4. Deliver the output as specified in "Preferred Output":
           - github-pr:   Open a pull request on {{ .entity.relations.repository }}
                          with patched dependency versions. Include CVE references
                          in the PR description. Do not merge.
           - jira-ticket: Create a Jira ticket in the owning team's project with
                          the full remediation plan, CVE references, and estimated
                          fix effort. Set Jira priority to match the requested
                          remediation priority.
           - both:        Do both of the above.
        5. If regulatory_scope includes PCI-DSS or HIPAA, always create a Jira
           ticket regardless of the preferred output type.
        6. Report back to the Port action run log with a summary and links to
           everything created.
      EOT

      labels = {
        source       = "security_patch_action"
        service      = "{{ .entity.identifier }}"
        priority     = "{{ .inputs.priority }}"
        triggered_by = "{{ .trigger.by.user.email }}"
      }
    })
  }

  depends_on = [port_entity.security_patch_agent]
}
