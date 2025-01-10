packer {
  required_plugins {
    azure = {
      version = "=2.2.0"
      source  = "github.com/hashicorp/azure"
    }
  }
}


variable "subscription_id" {
  type = string
}

variable "client_id" {
  type = string
}

variable "client_secret" {
  type = string
}

variable "tenant_id" {
  type = string
}

variable "location" {
  type = string
}

variable "commit_hash" {
  type = string
}

variable "build_time_utc" {
  type = string
}

variable "az_builder" {
  type = object({
    resource_group_name = string
    vm_size             = string
    os_type             = string
    image_publisher     = string
    image_offer         = string
    image_sku           = string
  })
}


source "azure-arm" "builder" {
  managed_image_name = "base-image"
  location           = var.location
  
  subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
  
  vm_size                           = var.az_builder.vm_size
  os_type                           = var.az_builder.os_type
  image_publisher                   = var.az_builder.image_publisher
  image_offer                       = var.az_builder.image_offer
  image_sku                         = var.az_builder.image_sku
  managed_image_resource_group_name = var.az_builder.resource_group_name

  azure_tags = {
    app             = "demo-app"
    commit_hash     = var.commit_hash
    build_time_utc  = var.build_time_utc
  }
}

build {
  sources = ["source.azure-arm.builder"]

  provisioner "file" {
    source      = "../"
    destination = "/tmp/git-repo"
  }

  provisioner "shell" {
    inline = [
      "echo 'adding apt repo ppa:deadsnakes/ppa'",
      "sudo add-apt-repository ppa:deadsnakes/ppa",
      "echo 'upgrading packakges'",
      "sudo apt-get update -y",
      "sudo apt-get upgrade -y",
      "echo 'install python 3.12'",
      "sudo apt install python3.12 -y",
      "echo 'install pip'",
      "sudo apt-get install python3-pip -y",
      "echo 'install nodejs/npm'",
      "curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -",
      "sudo apt install -y nodejs",
      "sudo npm install -g pnpm@latest-10",
      "sleep 10",
      "echo 'install pipenv'",
      "sudo pip install pipenv --break-system-packages",
      
      "echo 'install go 1.23.4'",
      "wget https://go.dev/dl/go1.23.4.linux-amd64.tar.gz",
      "sudo tar -C /usr/local -xzf go1.23.4.linux-amd64.tar.gz",
      "echo 'export GOROOT=/usr/local/go' | sudo tee -a /etc/profile",
      "echo 'export GOPATH=$HOME/go' | sudo tee -a /etc/profile",
      "echo 'export PATH=$PATH:$GOROOT/bin:$GOPATH/bin' | sudo tee -a /etc/profile",
      ". /etc/profile",
      "sudo chmod -R 777 /usr/local/go",
      "go version",
      
      "echo 'install Ollama'",
      "curl -fsSL https://ollama.com/install.sh | sh",
      "sleep 10",

      "echo 'pulling Ollama models'",
      "ollama pull llama3.2",
      "ollama pull mistral",
      "ollama pull tulu3",
      "ollama pull nomic-embed-text",
      "ollama pull mxbai-embed-large",
    ]
  }
}
