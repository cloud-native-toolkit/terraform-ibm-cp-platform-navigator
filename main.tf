locals {
  tmp_dir           = "${path.cwd}/.tmp"
  gitops_dir        = var.gitops_dir != "" ? "${var.gitops_dir}/platform-navigator" : "${path.cwd}/gitops/app-connect"
  subscription_file = "${local.gitops_dir}/subscription.yaml"
  instance_file     = "${local.gitops_dir}/instance.yaml"
  instance_name     = "integration-navigator"
  subscription      = {
    apiVersion = "operators.coreos.com/v1alpha1"
    kind = "Subscription"
    metadata = {
      name = "ibm-integration-platform-navigator"
      namespace = "openshift-operators"
    }
    spec = {
      channel = "v4.0"
      installPlanApproval = "Automatic"
      name = "ibm-integration-platform-navigator"
      source = var.catalog_name
      sourceNamespace = "openshift-marketplace"
    }
  }
  instance = {
    apiVersion = "integration.ibm.com/v1beta1"
    kind = "PlatformNavigator"
    metadata = {
      name = local.instance_name
    }
    spec = {
      license = {
        accept = true
      }
      mqDashboard = true
      replicas = 3
      version = "2020.3.1"
    }
  }
}

resource "null_resource" "create_dirs" {
  provisioner "local-exec" {
    command = "mkdir -p ${local.tmp_dir}"
  }

  provisioner "local-exec" {
    command = "mkdir -p ${local.gitops_dir}"
  }
}

resource local_file subscription_yaml {
  depends_on = [null_resource.create_dirs]

  filename = local.subscription_file

  content = yamlencode(local.subscription)
}

resource "null_resource" "create_subscription" {
  depends_on = [local_file.subscription_yaml]

  provisioner "local-exec" {
    command = "cat ${local.subscription_file}"
  }

  triggers = {
    KUBECONFIG = var.cluster_config_file
    file = local.subscription_file
    namespace = var.namespace
  }

  provisioner "local-exec" {
    command = "kubectl apply -f ${self.triggers.file} && ${path.module}/scripts/wait-for-csv.sh ${self.triggers.namespace} ibm-integration-platform-navigator"

    environment = {
      KUBECONFIG = self.triggers.KUBECONFIG
    }
  }

  provisioner "local-exec" {
    when = destroy
    command = "kubectl delete -f ${self.triggers.file}"

    environment = {
      KUBECONFIG = self.triggers.KUBECONFIG
    }
  }
}

resource local_file instance_yaml {
  depends_on = [null_resource.create_dirs]

  filename = local.instance_file

  content = yamlencode(local.instance)
}

resource "null_resource" "create_instance" {
  depends_on = [null_resource.create_subscription, local_file.instance_yaml]

  triggers = {
    KUBECONFIG = var.cluster_config_file
    namespace = var.namespace
    file = local.instance_file
  }

  provisioner "local-exec" {
    command = "kubectl apply -n ${self.triggers.namespace} -f ${self.triggers.file}"

    environment = {
      KUBECONFIG = self.triggers.KUBECONFIG
    }
  }

  provisioner "local-exec" {
    when = destroy
    command = "kubectl delete -n ${self.triggers.namespace} -f ${self.triggers.file}"

    environment = {
      KUBECONFIG = self.triggers.KUBECONFIG
    }
  }
}
