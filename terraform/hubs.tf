locals {
  hubs = {
    "bentonville-hub" = {
      title           = "Bentonville"
      region          = "North America"
      hub_lead_email  = "eng-lead-bentonville@walmart.com"
      developer_count = 2400
      status          = "Active"
    }
    "san-bruno-hub" = {
      title           = "San Bruno"
      region          = "North America"
      hub_lead_email  = "eng-lead-sanbrano@walmart.com"
      developer_count = 1800
      status          = "Active"
    }
    "hoboken-hub" = {
      title           = "Hoboken"
      region          = "North America"
      hub_lead_email  = "eng-lead-hoboken@walmart.com"
      developer_count = 800
      status          = "Active"
    }
    "bangalore-hub" = {
      title           = "Bangalore"
      region          = "APAC"
      hub_lead_email  = "eng-lead-bangalore@walmart.com"
      developer_count = 3200
      status          = "Scaling"
    }
    "chennai-hub" = {
      title           = "Chennai"
      region          = "APAC"
      hub_lead_email  = "eng-lead-chennai@walmart.com"
      developer_count = 1200
      status          = "Scaling"
    }
    "toronto-hub" = {
      title           = "Toronto"
      region          = "North America"
      hub_lead_email  = "eng-lead-toronto@walmart.com"
      developer_count = 600
      status          = "Active"
    }
    "london-hub" = {
      title           = "London"
      region          = "EMEA"
      hub_lead_email  = "eng-lead-london@walmart.com"
      developer_count = 500
      status          = "Active"
    }
    "sao-paulo-hub" = {
      title           = "Sao Paulo"
      region          = "LATAM"
      hub_lead_email  = "eng-lead-saopaulo@walmart.com"
      developer_count = 700
      status          = "Scaling"
    }
    "mexico-city-hub" = {
      title           = "Mexico City"
      region          = "LATAM"
      hub_lead_email  = "eng-lead-mexicocity@walmart.com"
      developer_count = 400
      status          = "Active"
    }
    "shenzhen-hub" = {
      title           = "Shenzhen"
      region          = "APAC"
      hub_lead_email  = "eng-lead-shenzhen@walmart.com"
      developer_count = 400
      status          = "Under Restructure"
    }
  }
}

resource "port_entity" "hubs" {
  for_each   = local.hubs
  identifier = each.key
  title      = each.value.title
  blueprint  = "hub"

  properties = {
    string_props = {
      "region"         = each.value.region
      "hub_lead_email" = each.value.hub_lead_email
      "status"         = each.value.status
    }
    number_props = {
      "developer_count" = each.value.developer_count
    }
  }
}
