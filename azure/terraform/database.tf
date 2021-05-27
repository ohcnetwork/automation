
resource "azurerm_postgresql_server" "care" {
  name                = "care-server"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name

  administrator_login          = "psqladminun"
  administrator_login_password = "H@Sh1CoR3!"

  sku_name   = "GP_Gen5_2"
  version    = "11"
  storage_mb = 10240

  backup_retention_days        = 7
  geo_redundant_backup_enabled = false
  auto_grow_enabled            = true

  public_network_access_enabled    = false
  ssl_enforcement_enabled          = true
  ssl_minimal_tls_version_enforced = "TLS1_2"
}

resource "azurerm_postgresql_database" "care-db" {
  name                = "care-db"
  resource_group_name = data.azurerm_resource_group.rg.name
  server_name         = azurerm_postgresql_server.care.name
  charset             = "UTF8"
  collation           = "English_United States.1252"
}

resource "azurerm_postgresql_virtual_network_rule" "pg_rule" {
  name                                 = "postgresql-vnet-rule"
  resource_group_name                  = data.azurerm_resource_group.rg.name
  server_name                          = azurerm_postgresql_server.care.name
  subnet_id                            = azurerm_subnet.postgres-subnet.id
  ignore_missing_vnet_service_endpoint = true
}

resource "azurerm_postgresql_firewall_rule" "caredbfirewall" {
  name                = "care-firewall"
  resource_group_name = data.azurerm_resource_group.rg.name
  server_name         = azurerm_postgresql_database.care-db.name
  start_ip_address    = "10.0.0.0"
  end_ip_address      = "10.0.255.255"
}

output "postgresql_server_id" {
  value = azurerm_postgresql_server.care.id
}