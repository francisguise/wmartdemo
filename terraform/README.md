# Port Walmart Demo — Terraform Seed Data

Terraform configuration to seed a Port catalog with realistic Walmart-scale
demo data for the "Fragmented Visibility" use case.

## What this creates

| Resource | Count | Notes |
|---|---|---|
| Hub entities | 10 | All of Walmart's global engineering hubs |
| Domain entities | 8 | Business capability groupings |
| Service entities | 25 | Varied metrics, ownership, and compliance data |
| Hub Dashboard | 1 | Org-wide KPIs + full hub table |
| Domain Dashboard | 1 | Domain KPIs + orphaned services + domain table |
| Security Patch Action | 1 | AI agent action on Service blueprint |

---

## Prerequisites

- Terraform CLI >= 1.3.0 (https://developer.hashicorp.com/terraform/install)
- A Port account (https://app.getport.io)
- The following blueprints must exist in Port BEFORE applying:
  - hub        (custom — create from the provided JSON)
  - domain     (custom — create from the provided JSON)
  - service    (built-in — extended with hub and domain relations, plus
                critical_vuln_count and production_readiness_score number properties)

---

## Setup

1. Copy credentials template:
   cp terraform.tfvars.example terraform.tfvars

2. Fill in your Port credentials (Settings > Credentials in Port):
   port_client_id     = "your-client-id"
   port_client_secret = "your-client-secret"

3. Enable beta features (required for dashboards):
   export PORT_BETA_FEATURES_ENABLED=true

4. Apply:
   terraform init
   terraform plan
   terraform apply

---

## AI Agent Action — Additional Setup

The create_security_patch action requires Port's AI Agents feature.

1. Enable AI Agents on your Port account (Settings > AI Agents).
2. Create a general-purpose coding agent and note its identifier.
3. Update the webhook URL in agent_action.tf:
      url = "https://api.port.io/v1/agent/YOUR_AGENT_IDENTIFIER/invoke"
4. Re-run terraform apply.

The agent uses these integrations to fulfil the prompt:
  - Port catalog access  — reads snykVulnerability entities
  - GitHub integration   — opens PRs
  - Jira integration     — creates tickets

The output_type user input (github-pr / jira-ticket / both) means partial
setups still produce useful output.

---

## Data design

VULNERABILITY SKEW
  Bangalore, Chennai, and Shenzhen have higher critical vuln counts.
  Reflects rapid-growth hubs accumulating security debt.

READINESS SKEW
  Regulated domains (Payments, Identity) score higher.
  Deprecated services score very low.

ORPHANED SERVICES
  legacy-tax-engine, cart-service-v1, store-ops-legacy have no hub and no
  domain. Highest vulns, lowest readiness. Visible immediately in the Domain
  dashboard's "Unowned Services" widget — the exact problem being solved.

---

## Teardown

   terraform destroy

---

## File structure

  providers.tf              Provider and version requirements
  variables.tf              Input variable declarations
  hubs.tf                   10 global engineering hub entities
  domains.tf                8 business domain entities
  services.tf               25 service entities with full properties
  dashboards.tf             Hub and Domain dashboard pages
  agent_action.tf           Security Patch AI agent self-service action
  terraform.tfvars.example  Credentials template
  .gitignore                Excludes state files and tfvars
  README.md                 This file
