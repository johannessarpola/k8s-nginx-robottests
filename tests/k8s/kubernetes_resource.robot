*** Settings ***
Library           Collections
Library           String
Library           RequestsLibrary
# Settings to run 'in-cluster'
Library           KubeLibrary    None    None    None    None    None    True    False

*** Variables ***
${KLIB_POD_TIMEOUT}                 %{KLIB_POD_TIMEOUT=2min}
${KLIB_POD_RETRY_INTERVAL}          %{KLIB_POD_RETRY_INTERVAL=5sec}


*** Keywords ***
kubernetes API responds
    [Documentation]  Check if API response code is 200
    ${ping}=    k8s_api_ping
    Should Be Equal As integers  ${ping}[1]  200

all pods are running or succeeded
    Should Not Be Empty  ${namespace_pods}
    FOR    ${pod}    IN    @{namespace_pods}
         ${status}=    Read Namespaced Pod Status  ${pod.metadata.name}  ${namespace}
         Should Be True     '${status.phase}'=='Running' or '${status.phase}'=='Succeeded'
    END

pods with label "${label}" status in namespace "${namespace}" is READY
    @{namespace_pods}=  List Namespaced Pod By Pattern  .*  ${namespace}  ${label}
    @{namespace_pods_names}=    Filter Names    ${namespace_pods}
    ${num_of_pods}=    Get Length    ${namespace_pods_names}
    Should Be True    ${num_of_pods} >= 1    No pods with label "${label}" found
    FOR    ${pod}    IN    @{namespace_pods_names}
        ${status}=    read_namespaced_pod_status    ${pod}    ${namespace}
        ${conditions}=    Filter by Key    ${status.conditions}    type    Ready
        Should Be True     '${conditions[0].status}'=='True'
    END

waited for pods with label "${label}" in namespace "${namespace}" to be READY
    Wait Until Keyword Succeeds    ${KLIB_POD_TIMEOUT}    ${KLIB_POD_RETRY_INTERVAL}   pods with label "${label}" status in namespace "${namespace}" is READY

no pods have restarted
    Should Not Be Empty  ${namespace_pods}
    @{containers_statuses}=    filter_pods_containers_statuses_by_name    ${namespace_pods}    .*
    FOR    ${container_status}    IN    @{containers_statuses}
        Should Be True    ${container_status.restart_count} == 0  pod ${container_status.name} has restarted ${container_status.restart_count} times
    END

list all pods in namespace
    [Arguments]  ${namespace}  ${label}
    @{namespace_pods}=  List Namespaced Pod By Pattern  .*  ${namespace}  ${label}
    Set Test Variable    ${namespace_pods}
    Log  \nPods in namespace ${namespace}:  console=True
    FOR  ${pod}  IN  @{namespace_pods}
        ${status}=  Read Namespaced Pod Status  ${pod.metadata.name}  ${namespace}
        Log  ${pod.metadata.name} Status:${status.phase}  console=True
    END