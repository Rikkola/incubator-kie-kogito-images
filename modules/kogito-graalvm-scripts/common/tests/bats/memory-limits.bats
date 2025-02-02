#!/usr/bin/env bats

export KOGITO_HOME=/tmp/kogito
export JBOSS_CONTAINER_JAVA_JVM_MODULE=${KOGITO_HOME}/launch
mkdir -p "${KOGITO_HOME}"/launch
cp $BATS_TEST_DIRNAME/../../../../kogito-logging/added/logging.sh "${KOGITO_HOME}"/launch/
cp $BATS_TEST_DIRNAME/../../../../kogito-dynamic-resources/added/container-limits "${KOGITO_HOME}"/launch/

# imports
source $BATS_TEST_DIRNAME/../../added/memory-limit.sh

@test "test a valid memory limit value" {
    export LIMIT_MEMORY="1342177280"
    local expected=" -Dquarkus.native.native-image-xmx=1073741824" # 80% of LIMIT_MEMORY, top expected by JVM
    configure
    echo "Expected: ${expected}"
    echo "Result: ${KOGITO_OPTS}"
    [ "${expected}" = "${KOGITO_OPTS}" ]
}

@test "test a result jvm memory with float points" {
    export LIMIT_MEMORY="2147483648" # 80% is 1717986918.4
    local expected=" -Dquarkus.native.native-image-xmx=1717986918"
    configure
    echo "Expected: ${expected}"
    echo "Result: ${KOGITO_OPTS}"
    [ "${expected}" = "${KOGITO_OPTS}" ]
}

@test "test a small memory limit value" {
    export LIMIT_MEMORY="1073741600"
    local expected="Available memory (1073741600) limit is too small"
    run configure
    local result="${lines[1]}"
    echo "Expected: ${expected}"
    echo "Result is ${result}"
    [[ "${result}" == *"${expected}"* ]]
}

@test "test a invalid memory limit value" {
    function log_warning() { echo "WARN ${1}"; }
    export LIMIT_MEMORY="1024m"
    local expected="WARN Not able to determine the available memory. Using all memory available."
    run configure
    echo "Expected: ${expected}"
    echo "Result: ${lines[@]}"
    [ "${lines[0]}" = "INFO Using backwards compatibility with LIMIT_MEMORY env, if you want to rely com cgroups, unset this env." ]
    [ "${lines[1]}" = "WARN Not able to determine the available memory. Using all memory available." ]
}
