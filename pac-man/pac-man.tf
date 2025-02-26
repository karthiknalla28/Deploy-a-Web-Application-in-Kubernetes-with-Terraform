terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
    }
  }
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}

resource "kubernetes_namespace" "pac-man" {
  metadata {
    annotations = {
      name = "pac-man_web_app"
    }

    labels = {
      namespace = "pac-man"
    }

    name = "pac-man"
  }
}

