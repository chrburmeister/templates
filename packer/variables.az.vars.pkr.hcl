tenant_id           = ""
subscription_id     = ""
location            = "germanywestcentral"
az_builder = {
    resource_group_name = "azureimagebuilder"
    vm_size         = "Standard_B4ms"
    os_type         = "Linux"
    image_publisher = "Canonical"
    image_offer     = "ubuntu-24_04-lts"
    image_sku       = "server"
}
