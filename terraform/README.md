# Port Walmart Demo — Terraform Seed Data

Terraform configuration to seed a Port catalog with realistic Walmart-scale
demo data for the "Fragmented Visibility" use case.

## What this creates

| Resource | Count | Notes |
|---|---|---|
| Hub entities | 10 | All of Walmart's global engineering hubs |
| Domain entities | 8 | Business capability groupings |
| Service entities | 25 | Varied metrics, ownership, and compliance data |

### Data design

- **Vulnerability skew** — Bangalore, Chennai, and Shenzhen hubs have higher
  critical vulnerability counts, reflecting rapid-growth hubs accumulating
  security debt.
- **Readiness skew** — Regulated domains (Payments, Identity) score higher.
  Deprecated/legacy services score very low.
- **Orphaned services** — 3 services have no hub and no domain assigned.
  These have the highest vuln counts and lowest readiness scores. This is
  the "dark matter" of the estate that Port makes immediately visible.

## Prerequisites

- [Terraform CLI](https://developer.hashicorp.com/terraform/install) >= 1.3.0
- A Port account — [sign up free](https://app.getport.io)
- The following blueprints must exist in your Port account before applying:
  - `hub` (custom — create from the provided JSON)
  - `domain` (custom — create from the provided JSON)
  - `service` (built-in — extended with `hub` and `domain` relations,
    plus `critical_vuln_count` and `production_readiness_score` properties)

## Setup

1. Copy the example vars file:
   ```bash
   cp terraform.tfvars.example terraform.tfvars
   ```

2. Fill in your Port credentials in `terraform.tfvars`:
   ```hcl
   port_client_id     = "your-client-id"
   port_client_secret = "your-client-secret"
   ```
   Find these under **Settings > Credentials** in your Port account.

3. Initialise and apply:
   ```bash
   terraform init
   terraform plan   # review what will be created
   terraform apply
   ```

## Teardown

To remove all seeded entities from Port:
```bash
terraform destroy
```

## File structure

```
.
├── providers.tf              # Provider and version requirements
├── variables.tf              # Input variable declarations
├── hubs.tf                   # 10 global engineering hub entities
├── domains.tf                # 8 business domain entities
├── services.tf               # 25 service entities with full properties
├── terraform.tfvars.example  # Credentials template
├── .gitignore                # Excludes state files and tfvars
└── README.md
```
