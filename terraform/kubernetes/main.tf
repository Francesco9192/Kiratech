terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "2.7.1"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.18.0"
    }
  }

  required_version = ">= 1.0.0"
}

provider "kubernetes" {
  config_path = "~/.kube/config" 
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}


resource "kubernetes_namespace" "kiratech_test" {
  metadata {
    name = "kiratech-test"
  }
}


resource "helm_repository" "k_rail" {
  name = "k-rail"
  url  = "https://k-rail.github.io/helm-charts"
}


resource "helm_release" "k_rail" {
  name       = "k-rail"
  repository = helm_repository.k_rail.name
  chart      = "k-rail"
  version    = "0.1.0"
  namespace  = kubernetes_namespace.kiratech_test.metadata[0].name
}