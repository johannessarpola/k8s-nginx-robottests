*** Settings ***
Resource       ./kubernetes_resource.robot

*** Variables ***
${namespace}  %{NAMESPACE=default}
${label}  %{LABEL=app=nginx}

*** Test Cases ***
Pods in "${namespace}" with label "${label}" are running or succeeded
    Given kubernetes API responds
    When list all pods in namespace  ${namespace}  ${label}
    Then all pods are running or succeeded

Pods in "${namespace}" with label "${label}" have not been restarted
    Given waited for pods with label "${label}" in namespace "${namespace}" to be READY
    When list all pods in namespace  ${namespace}  ${label}
    Then no pods have restarted

