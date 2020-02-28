resource "kubernetes_namespace" "so1-prod-namespace" {
  metadata {
    name = var.prod_namespace
  }
}

resource "kubernetes_namespace" "so1-dev-namespace" {
  metadata {
    name = var.dev_namespace
  }
}

resource "kubernetes_namespace" "so1-qa-namespace" {
  metadata {
    name = var.qa_namespace
  }
}
