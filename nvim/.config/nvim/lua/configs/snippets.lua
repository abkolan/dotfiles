local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node

-- DevOps specific snippets
ls.add_snippets("yaml", {
  -- Kubernetes Deployment
  s("k8s-deploy", {
    t({"apiVersion: apps/v1", "kind: Deployment", "metadata:", "  name: "}), i(1, "app-name"), t({"", "  labels:", "    app: "}), i(2, "app-name"),
    t({"", "spec:", "  replicas: "}), i(3, "3"), t({"", "  selector:", "    matchLabels:", "      app: "}), i(4, "app-name"),
    t({"", "  template:", "    metadata:", "      labels:", "        app: "}), i(5, "app-name"),
    t({"", "    spec:", "      containers:", "      - name: "}), i(6, "container-name"), t({"", "        image: "}), i(7, "image:tag"),
    t({"", "        ports:", "        - containerPort: "}), i(8, "8080")
  }),
  
  -- Kubernetes Service
  s("k8s-svc", {
    t({"apiVersion: v1", "kind: Service", "metadata:", "  name: "}), i(1, "service-name"),
    t({"", "spec:", "  selector:", "    app: "}), i(2, "app-name"),
    t({"", "  ports:", "  - protocol: TCP", "    port: "}), i(3, "80"), t({"", "    targetPort: "}), i(4, "8080"),
    t({"", "  type: "}), i(5, "ClusterIP")
  }),

  -- Docker Compose Service
  s("docker-compose", {
    t({"version: '3.8'", "services:", "  "}), i(1, "service-name"), t({":","    image: "}), i(2, "image:tag"),
    t({"", "    ports:", "      - \""}), i(3, "8080"), t(":"), i(4, "8080"), t({"\"", "    environment:", "      - "}), i(5, "ENV_VAR=value"),
    t({"", "    volumes:", "      - "}), i(6, "./:/app"), t({"", "    restart: unless-stopped"})
  }),

  -- Helm Chart values
  s("helm-values", {
    t({"replicaCount: "}), i(1, "1"), t({"", "", "image:", "  repository: "}), i(2, "nginx"), t({"", "  tag: "}), i(3, "latest"),
    t({"", "  pullPolicy: IfNotPresent", "", "service:", "  type: "}), i(4, "ClusterIP"), t({"", "  port: "}), i(5, "80")
  })
})

ls.add_snippets("terraform", {
  -- Terraform Resource
  s("tf-resource", {
    t("resource \""), i(1, "resource_type"), t("\" \""), i(2, "resource_name"), t({"\" {", "  "}), i(3, "# Configuration"), t({"", "}"})
  }),
  
  -- Terraform Variable
  s("tf-var", {
    t("variable \""), i(1, "variable_name"), t({"\" {", "  description = \""}), i(2, "Description"), t({"\"", "  type        = "}), i(3, "string"),
    t({"", "  default     = "}), i(4, "null"), t({"", "}"})
  }),
  
  -- Terraform Output  
  s("tf-output", {
    t("output \""), i(1, "output_name"), t({"\" {", "  description = \""}), i(2, "Description"), t({"\"", "  value       = "}), i(3, "value"), t({"", "}"})
  }),

  -- AWS Provider
  s("tf-aws-provider", {
    t({"terraform {", "  required_providers {", "    aws = {", "      source  = \"hashicorp/aws\"", "      version = \"~> "}), i(1, "5.0"), t({"\"", "    }", "  }", "}", "", "provider \"aws\" {", "  region = \""}), i(2, "us-west-2"), t({"\"", "}"})
  })
})

ls.add_snippets("python", {
  -- Python main guard
  s("main", {
    t({"if __name__ == \"__main__\":", "    "}), i(1, "main()")
  }),
  
  -- Python docstring
  s("docstring", {
    t("\"\"\""), i(1, "Brief description"), t({"", "", "Args:", "    "}), i(2, "arg: Description"), t({"", "", "Returns:", "    "}), i(3, "Description"), t({"", "", "Raises:", "    "}), i(4, "Exception: Description"), t({"", "\"\"\""})
  }),

  -- Pytest test function
  s("pytest", {
    t("def test_"), i(1, "function_name"), t("():"), t({"", "    \"\"\""}), i(2, "Test description"), t({"\"\"\""," ", "    # Arrange", "    "}), i(3, "# Setup test data"),
    t({"", "", "    # Act", "    "}), i(4, "result = function_to_test()"), t({"", "", "    # Assert", "    assert "}), i(5, "result == expected")
  })
})

ls.add_snippets("go", {
  -- Go error handling
  s("iferr", {
    t("if err != nil {"), t({"", "\t"}), i(1, "return err"), t({"", "}"})
  }),
  
  -- Go struct
  s("struct", {
    t("type "), i(1, "StructName"), t({" struct {", "\t"}), i(2, "Field string"), t({"", "}"})
  }),

  -- Go test function
  s("test", {
    t("func Test"), i(1, "FunctionName"), t("(t *testing.T) {"), t({"", "\t"}), i(2, "// Test implementation"), t({"", "}"})
  })
})

-- Load friendly-snippets
require("luasnip.loaders.from_vscode").lazy_load()