locals {
  domains = {
    "payments" = {
      title             = "Payments"
      domain_lead_email = "payments-lead@walmart.com"
      status            = "Active"
    }
    "fulfillment" = {
      title             = "Fulfillment"
      domain_lead_email = "fulfillment-lead@walmart.com"
      status            = "Active"
    }
    "supply-chain" = {
      title             = "Supply Chain"
      domain_lead_email = "supplychain-lead@walmart.com"
      status            = "Active"
    }
    "identity-and-access" = {
      title             = "Identity & Access"
      domain_lead_email = "iam-lead@walmart.com"
      status            = "Active"
    }
    "pricing" = {
      title             = "Pricing"
      domain_lead_email = "pricing-lead@walmart.com"
      status            = "Active"
    }
    "inventory" = {
      title             = "Inventory"
      domain_lead_email = "inventory-lead@walmart.com"
      status            = "Active"
    }
    "customer-experience" = {
      title             = "Customer Experience"
      domain_lead_email = "cx-lead@walmart.com"
      status            = "Active"
    }
    "data-platform" = {
      title             = "Data Platform"
      domain_lead_email = "data-lead@walmart.com"
      status            = "Incubating"
    }
  }
}

resource "port_entity" "domains" {
  for_each   = local.domains
  identifier = each.key
  title      = each.value.title
  blueprint  = "domain"

  properties = {
    string_props = {
      "domain_lead_email" = each.value.domain_lead_email
      "status"            = each.value.status
    }
  }
}
