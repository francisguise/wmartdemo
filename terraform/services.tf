locals {
  # ─────────────────────────────────────────────────────────────────
  # Demo data design notes:
  #
  # VULNERABILITY SKEW
  #   Bangalore, Chennai, Shenzhen have higher counts — reflects
  #   rapid-growth hubs moving fast and accumulating security debt.
  #   This makes the cross-hub dashboard tell a story without narration.
  #
  # READINESS SKEW
  #   Regulated domains (payments, identity-and-access) score higher.
  #   Deprecated / legacy services score very low.
  #   This gives the domain dashboard an interesting, realistic shape.
  #
  # ORPHANED SERVICES
  #   hub = null, domain = null on ~10% of services.
  #   These represent the "dark matter" of the estate — services with
  #   no owner, high vuln counts, and low readiness. The exact problem
  #   Port is solving, visible immediately in the catalog.
  # ─────────────────────────────────────────────────────────────────
  services = {

    # ── Payments ────────────────────────────────────────────────────
    "svc-checkout-service" = {
      title                      = "checkout-service"
      hub                        = "san-bruno-hub"
      domain                     = "payments"
      critical_vuln_count        = 2
      production_readiness_score = 91
      tier                       = "customer-facing"
      business_criticality       = "critical"
      owning_team                = "checkout-team"
      slack_channel              = "#checkout-alerts"
      data_classification        = "restricted"
      regulatory_scope           = ["PCI-DSS", "CCPA"]
    }
    "svc-payment-gateway" = {
      title                      = "payment-gateway"
      hub                        = "san-bruno-hub"
      domain                     = "payments"
      critical_vuln_count        = 0
      production_readiness_score = 96
      tier                       = "customer-facing"
      business_criticality       = "critical"
      owning_team                = "payments-core-team"
      slack_channel              = "#payments-alerts"
      data_classification        = "restricted"
      regulatory_scope           = ["PCI-DSS"]
    }
    "svc-fraud-detector" = {
      title                      = "fraud-detector"
      hub                        = "bangalore-hub"
      domain                     = "payments"
      critical_vuln_count        = 14
      production_readiness_score = 72
      tier                       = "internal"
      business_criticality       = "critical"
      owning_team                = "fraud-team"
      slack_channel              = "#fraud-alerts"
      data_classification        = "confidential"
      regulatory_scope           = ["PCI-DSS"]
    }
    "svc-refund-processor" = {
      title                      = "refund-processor"
      hub                        = "chennai-hub"
      domain                     = "payments"
      critical_vuln_count        = 21
      production_readiness_score = 65
      tier                       = "internal"
      business_criticality       = "high"
      owning_team                = "payments-team-chn"
      slack_channel              = "#refunds-alerts"
      data_classification        = "restricted"
      regulatory_scope           = ["PCI-DSS"]
    }

    # ── Identity & Access ────────────────────────────────────────────
    "svc-auth-service" = {
      title                      = "auth-service"
      hub                        = "bentonville-hub"
      domain                     = "identity-and-access"
      critical_vuln_count        = 1
      production_readiness_score = 94
      tier                       = "customer-facing"
      business_criticality       = "critical"
      owning_team                = "iam-team"
      slack_channel              = "#iam-alerts"
      data_classification        = "restricted"
      regulatory_scope           = ["CCPA", "GDPR"]
    }
    "svc-user-profile-api" = {
      title                      = "user-profile-api"
      hub                        = "bangalore-hub"
      domain                     = "identity-and-access"
      critical_vuln_count        = 19
      production_readiness_score = 61
      tier                       = "customer-facing"
      business_criticality       = "high"
      owning_team                = "identity-team-blr"
      slack_channel              = "#user-profile-alerts"
      data_classification        = "confidential"
      regulatory_scope           = ["CCPA", "GDPR"]
    }
    "svc-session-manager" = {
      title                      = "session-manager"
      hub                        = "bentonville-hub"
      domain                     = "identity-and-access"
      critical_vuln_count        = 3
      production_readiness_score = 89
      tier                       = "internal"
      business_criticality       = "critical"
      owning_team                = "iam-team"
      slack_channel              = "#iam-alerts"
      data_classification        = "restricted"
      regulatory_scope           = ["CCPA"]
    }

    # ── Fulfillment ──────────────────────────────────────────────────
    "svc-order-processor" = {
      title                      = "order-processor"
      hub                        = "hoboken-hub"
      domain                     = "fulfillment"
      critical_vuln_count        = 5
      production_readiness_score = 83
      tier                       = "internal"
      business_criticality       = "critical"
      owning_team                = "fulfillment-team"
      slack_channel              = "#fulfillment-alerts"
      data_classification        = "internal"
      regulatory_scope           = ["none"]
    }
    "svc-shipping-worker" = {
      title                      = "shipping-worker"
      hub                        = "chennai-hub"
      domain                     = "fulfillment"
      critical_vuln_count        = 22
      production_readiness_score = 54
      tier                       = "internal"
      business_criticality       = "high"
      owning_team                = "logistics-team-chn"
      slack_channel              = "#shipping-alerts"
      data_classification        = "internal"
      regulatory_scope           = ["none"]
    }
    "svc-returns-handler" = {
      title                      = "returns-handler"
      hub                        = "bangalore-hub"
      domain                     = "fulfillment"
      critical_vuln_count        = 17
      production_readiness_score = 59
      tier                       = "customer-facing"
      business_criticality       = "medium"
      owning_team                = "returns-team-blr"
      slack_channel              = "#returns-alerts"
      data_classification        = "internal"
      regulatory_scope           = ["none"]
    }

    # ── Inventory ────────────────────────────────────────────────────
    "svc-inventory-api" = {
      title                      = "inventory-api"
      hub                        = "bentonville-hub"
      domain                     = "inventory"
      critical_vuln_count        = 3
      production_readiness_score = 88
      tier                       = "internal"
      business_criticality       = "high"
      owning_team                = "inventory-team"
      slack_channel              = "#inventory-alerts"
      data_classification        = "internal"
      regulatory_scope           = ["none"]
    }
    "svc-warehouse-sync" = {
      title                      = "warehouse-sync"
      hub                        = "bangalore-hub"
      domain                     = "inventory"
      critical_vuln_count        = 31
      production_readiness_score = 48
      tier                       = "internal"
      business_criticality       = "medium"
      owning_team                = "warehouse-team-blr"
      slack_channel              = "#warehouse-alerts"
      data_classification        = "internal"
      regulatory_scope           = ["none"]
    }

    # ── Pricing ──────────────────────────────────────────────────────
    "svc-pricing-engine" = {
      title                      = "pricing-engine"
      hub                        = "san-bruno-hub"
      domain                     = "pricing"
      critical_vuln_count        = 4
      production_readiness_score = 87
      tier                       = "internal"
      business_criticality       = "critical"
      owning_team                = "pricing-team"
      slack_channel              = "#pricing-alerts"
      data_classification        = "confidential"
      regulatory_scope           = ["none"]
    }
    "svc-dynamic-pricer" = {
      title                      = "dynamic-pricer"
      hub                        = "shenzhen-hub"
      domain                     = "pricing"
      critical_vuln_count        = 27
      production_readiness_score = 51
      tier                       = "internal"
      business_criticality       = "high"
      owning_team                = "pricing-team-shz"
      slack_channel              = "#pricing-shz-alerts"
      data_classification        = "internal"
      regulatory_scope           = ["none"]
    }

    # ── Customer Experience ──────────────────────────────────────────
    "svc-recommendation-engine" = {
      title                      = "recommendation-engine"
      hub                        = "bangalore-hub"
      domain                     = "customer-experience"
      critical_vuln_count        = 18
      production_readiness_score = 63
      tier                       = "customer-facing"
      business_criticality       = "medium"
      owning_team                = "personalisation-team"
      slack_channel              = "#recs-alerts"
      data_classification        = "internal"
      regulatory_scope           = ["CCPA"]
    }
    "svc-search-api" = {
      title                      = "search-api"
      hub                        = "san-bruno-hub"
      domain                     = "customer-experience"
      critical_vuln_count        = 6
      production_readiness_score = 80
      tier                       = "customer-facing"
      business_criticality       = "high"
      owning_team                = "search-team"
      slack_channel              = "#search-alerts"
      data_classification        = "public"
      regulatory_scope           = ["none"]
    }
    "svc-notification-handler" = {
      title                      = "notification-handler"
      hub                        = "sao-paulo-hub"
      domain                     = "customer-experience"
      critical_vuln_count        = 16
      production_readiness_score = 58
      tier                       = "internal"
      business_criticality       = "medium"
      owning_team                = "cx-team-bra"
      slack_channel              = "#notifications-alerts"
      data_classification        = "internal"
      regulatory_scope           = ["none"]
    }
    "svc-loyalty-processor" = {
      title                      = "loyalty-processor"
      hub                        = "mexico-city-hub"
      domain                     = "customer-experience"
      critical_vuln_count        = 12
      production_readiness_score = 69
      tier                       = "customer-facing"
      business_criticality       = "medium"
      owning_team                = "loyalty-team-mex"
      slack_channel              = "#loyalty-alerts"
      data_classification        = "confidential"
      regulatory_scope           = ["CCPA"]
    }

    # ── Supply Chain ─────────────────────────────────────────────────
    "svc-supplier-portal" = {
      title                      = "supplier-portal"
      hub                        = "toronto-hub"
      domain                     = "supply-chain"
      critical_vuln_count        = 9
      production_readiness_score = 74
      tier                       = "customer-facing"
      business_criticality       = "high"
      owning_team                = "supplier-team-tor"
      slack_channel              = "#supplier-alerts"
      data_classification        = "confidential"
      regulatory_scope           = ["none"]
    }
    "svc-procurement-api" = {
      title                      = "procurement-api"
      hub                        = "london-hub"
      domain                     = "supply-chain"
      critical_vuln_count        = 8
      production_readiness_score = 77
      tier                       = "internal"
      business_criticality       = "high"
      owning_team                = "procurement-team-lon"
      slack_channel              = "#procurement-alerts"
      data_classification        = "confidential"
      regulatory_scope           = ["GDPR"]
    }

    # ── Data Platform ────────────────────────────────────────────────
    "svc-data-pipeline-core" = {
      title                      = "data-pipeline-core"
      hub                        = "london-hub"
      domain                     = "data-platform"
      critical_vuln_count        = 11
      production_readiness_score = 66
      tier                       = "internal"
      business_criticality       = "high"
      owning_team                = "data-eng-team"
      slack_channel              = "#data-platform-alerts"
      data_classification        = "confidential"
      regulatory_scope           = ["GDPR"]
    }
    "svc-event-streaming" = {
      title                      = "event-streaming"
      hub                        = "bangalore-hub"
      domain                     = "data-platform"
      critical_vuln_count        = 24
      production_readiness_score = 55
      tier                       = "internal"
      business_criticality       = "high"
      owning_team                = "data-team-blr"
      slack_channel              = "#events-alerts"
      data_classification        = "internal"
      regulatory_scope           = ["none"]
    }

    # ── Orphaned — no hub, no domain ─────────────────────────────────
    # These are the "dark matter" of the estate. High vulns, low
    # readiness, no owner. The exact problem Port makes visible.
    "svc-legacy-tax-engine" = {
      title                      = "legacy-tax-engine"
      hub                        = null
      domain                     = null
      critical_vuln_count        = 43
      production_readiness_score = 29
      tier                       = "internal"
      business_criticality       = "high"
      owning_team                = ""
      slack_channel              = ""
      data_classification        = "confidential"
      regulatory_scope           = ["none"]
    }
    "svc-cart-service-v1" = {
      title                      = "cart-service-v1"
      hub                        = null
      domain                     = null
      critical_vuln_count        = 38
      production_readiness_score = 22
      tier                       = "deprecated"
      business_criticality       = "low"
      owning_team                = ""
      slack_channel              = ""
      data_classification        = "internal"
      regulatory_scope           = ["none"]
    }
    "svc-store-ops-legacy" = {
      title                      = "store-ops-legacy"
      hub                        = null
      domain                     = null
      critical_vuln_count        = 51
      production_readiness_score = 18
      tier                       = "deprecated"
      business_criticality       = "medium"
      owning_team                = ""
      slack_channel              = ""
      data_classification        = "internal"
      regulatory_scope           = ["none"]
    }
  }
}

resource "port_entity" "services" {
  for_each   = local.services
  identifier = each.key
  title      = each.value.title
  blueprint  = "service"

  properties = {
    number_props = {
      "critical_vuln_count"        = each.value.critical_vuln_count
      "production_readiness_score" = each.value.production_readiness_score
    }
    string_props = merge(
      {
        "tier"                 = each.value.tier
        "business_criticality" = each.value.business_criticality
        "data_classification"  = each.value.data_classification
      },
      each.value.owning_team != "" ? { "owning_team" = each.value.owning_team } : {},
      each.value.slack_channel != "" ? { "slack_channel" = each.value.slack_channel } : {}
    )
    array_props = {
      string_items = {
        "regulatory_scope" = each.value.regulatory_scope
      }
    }
  }

  relations = {
    single_relations = merge(
      each.value.hub != null ? { "hub" = each.value.hub } : {},
      each.value.domain != null ? { "domain" = each.value.domain } : {}
    )
  }

  depends_on = [
    port_entity.hubs,
    port_entity.domains,
  ]
}
