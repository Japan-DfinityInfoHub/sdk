load ${BATSLIB}/load.bash
load ../utils/assertions

# Takes a name of the asset folder, and copy those files to the current project.
install_asset() {
    ASSET_ROOT=${BATS_TEST_DIRNAME}/../assets/$1/
    cp -R $ASSET_ROOT/* .

    [ -f ./patch.bash ] && source ./patch.bash
}

install_shared_asset() {
    mkdir -p "$(dirname "$E2E_NETWORK_DFX_JSON")"

    ASSET_ROOT=${BATS_TEST_DIRNAME}/../assets/$1/
    cp -R $ASSET_ROOT/* "$(dirname "$E2E_NETWORK_DFX_JSON")"
}

standard_setup() {
    [ ! -f ${BATS_PARENT_TMPNAME}.skip ] || skip "skip remaining tests"

    # We want to work from a temporary directory, different for every test.
    x=$(mktemp -d -t dfx-e2e-XXXXXXXX)
    export E2E_TEMP_DIR="$x"

    mkdir "$x/working-dir"
    mkdir "$x/cache-root"
    mkdir "$x/config-root"
    mkdir "$x/home-dir"

    cd "$x/working-dir" || exit

    export HOME="$x/home-dir"
    export DFX_CACHE_ROOT="$x/cache-root"
    export DFX_CONFIG_ROOT="$x/config-root"
    export RUST_BACKTRACE=1
}

standard_teardown() {
    echo rm -rf "$E2E_TEMP_DIR" || echo rm -rf "$E2E_TEMP_DIR"

    [ -n "$BATS_TEST_COMPLETED" ] || touch ${BATS_PARENT_TMPNAME}.skip
}

dfx_new_frontend() {
    local project_name=${1:-e2e_project}
    dfx new ${project_name} --frontend
    test -d ${project_name}
    test -f ${project_name}/dfx.json
    cd ${project_name}

    echo PWD: $(pwd) >&2
}

dfx_new() {
    local project_name=${1:-e2e_project}
    dfx new ${project_name} --no-frontend
    test -d ${project_name}
    test -f ${project_name}/dfx.json
    cd ${project_name}

    echo PWD: $(pwd) >&2
}

dfx_new_rust() {
    local project_name=${1:-e2e_project}
    rustup default stable
    rustup target add wasm32-unknown-unknown
    dfx new ${project_name} --type=rust --no-frontend
    test -d ${project_name}
    test -f ${project_name}/dfx.json
    test -f ${project_name}/Cargo.toml
    cd ${project_name}

    echo PWD: $(pwd) >&2
}

dfx_patchelf() {
    # Don't run this function during github actions
    [ "$GITHUB_ACTIONS" ] && return 0

    # Only run this function on Linux
    (uname -a | grep Linux) || return 0
    echo dfx = $(which dfx)
    local CACHE_DIR="$(dfx cache show)"

    dfx cache install

    # Both ldd and iconv are providedin glibc.bin package
    local LD_LINUX_SO=$(ldd $(which iconv)|grep ld-linux-x86|cut -d' ' -f3)
    for binary in ic-starter icx-proxy replica; do
        local BINARY="${CACHE_DIR}/${binary}"
        test -f "$BINARY" || continue
        local IS_STATIC=$(ldd "${BINARY}" | grep 'not a dynamic executable')
        local USE_LIB64=$(ldd "${BINARY}" | grep '/lib64/ld-linux-x86-64.so.2')
        chmod +rw "${BINARY}"
        test -n "$IS_STATIC" || test -z "$USE_LIB64" || patchelf --set-interpreter "${LD_LINUX_SO}" "${BINARY}"
    done
}

determine_network_directory() {
    # not perfect: dfx.json can actually exist in a parent
    if [ -f dfx.json ] && [ "$(jq .networks.local dfx.json)" != "null" ]; then
        echo "found dfx.json with local network in $(pwd)"
        x="$(pwd)/.dfx/network/local"
        y="$(pwd)/dfx.json"
        export E2E_NETWORK_DATA_DIRECTORY="$x"
        export E2E_NETWORK_DFX_JSON="$y"
    else
        echo "no dfx.json"
        if [ "$(uname)" == "Darwin" ]; then
            echo "is darwin"
            export E2E_NETWORK_DATA_DIRECTORY="$HOME/Library/Application Support/org.dfinity.dfx/network/local"
        elif [ "$(uname)" == "Linux" ]; then
            echo "is linux"
            export E2E_NETWORK_DATA_DIRECTORY="$HOME/.local/share/dfx/network/local"
        fi
        export E2E_NETWORK_DFX_JSON="$DFX_CONFIG_ROOT/.config/dfx/dfx.json"
    fi
}

# Start the replica in the background.
dfx_start() {
    dfx_patchelf

    if [ "$GITHUB_WORKSPACE" ]; then
        # no need for random ports on github workflow; even using a random port we sometimes
        # get 'address in use', so the hope is to avoid that by using a fixed port.
        FRONTEND_HOST="127.0.0.1:8000"
    else
        # Start on random port for parallel test execution (needed on nix/hydra)
        FRONTEND_HOST="127.0.0.1:0"
    fi

    determine_network_directory
    if [ "$USE_IC_REF" ]
    then
        if [[ "$@" == "" ]]; then
            dfx start --emulator --background --host "$FRONTEND_HOST" 3>&-
        else
            batslib_decorate "no arguments to dfx start --emulator supported yet"
            fail
        fi

        test -f "$E2E_NETWORK_DATA_DIRECTORY/ic-ref.port"
        local port=$(cat "$E2E_NETWORK_DATA_DIRECTORY/ic-ref.port")

#        # Overwrite the default networks.local.bind 127.0.0.1:8000 with allocated port
        local webserver_port=$(cat "$E2E_NETWORK_DATA_DIRECTORY/webserver-port")
#        cat <<<$(jq .networks.local.bind=\"127.0.0.1:${webserver_port}\" "$E2E_NETWORK_DFX_JSON") >"$E2E_NETWORK_DFX_JSON"
    else
        # Bats creates a FD 3 for test output, but child processes inherit it and Bats will
        # wait for it to close. Because `dfx start` leaves child processes running, we need
        # to close this pipe, otherwise Bats will wait indefinitely.
        if [[ "$@" == "" ]]; then
            dfx start --background --host "$FRONTEND_HOST" 3>&- # Start on random port for parallel test execution
        else
            dfx start --background "$@" 3>&-
        fi

        local dfx_config_root="$E2E_NETWORK_DATA_DIRECTORY/replica-configuration"
        printf "Configuration Root for DFX: %s\n" "${dfx_config_root}"
        test -f "${dfx_config_root}/replica-1.port"
        local port=$(cat "${dfx_config_root}/replica-1.port")

#        # Overwrite the default networks.local.bind 127.0.0.1:8000 with allocated port
        local webserver_port=$(cat "$E2E_NETWORK_DATA_DIRECTORY/webserver-port")
#        cat <<<$(jq .networks.local.bind=\"127.0.0.1:${webserver_port}\" dfx.json) >dfx.json
    fi

    printf "Replica Configured Port: %s\n" "${port}"
    printf "Webserver Configured Port: %s\n" "${webserver_port}"

    timeout 5 sh -c \
        "until nc -z localhost ${port}; do echo waiting for replica; sleep 1; done" \
        || (echo "could not connect to replica on port ${port}" && exit 1)
}

wait_until_replica_healthy() {
    echo "waiting for replica to become healthy"
    dfx ping --wait-healthy
    echo "replica became healthy"
}

# Start the replica in the background.
dfx_start_replica_and_bootstrap() {
    dfx_patchelf
    determine_network_directory
    if [ "$USE_IC_REF" ]
    then
        # Bats creates a FD 3 for test output, but child processes inherit it and Bats will
        # wait for it to close. Because `dfx start` leaves child processes running, we need
        # to close this pipe, otherwise Bats will wait indefinitely.
        dfx replica --emulator --port 0 "$@" 3>&- &
        export DFX_REPLICA_PID=$!

        timeout 60 sh -c \
            "until test -s \"$E2E_NETWORK_DATA_DIRECTORY/ic-ref.port\"; do echo waiting for ic-ref port; sleep 1; done" \
            || (echo "replica did not write to \"$E2E_NETWORK_DATA_DIRECTORY/ic-ref.port\" file" && exit 1)

        test -f "$E2E_NETWORK_DATA_DIRECTORY/ic-ref.port"
        local replica_port=$(cat "$E2E_NETWORK_DATA_DIRECTORY/ic-ref.port")

    else
        # Bats creates a FD 3 for test output, but child processes inherit it and Bats will
        # wait for it to close. Because `dfx start` leaves child processes running, we need
        # to close this pipe, otherwise Bats will wait indefinitely.
        dfx replica --port 0 "$@" 3>&- &
        export DFX_REPLICA_PID=$!

        timeout 60 sh -c \
            "until test -s \"$E2E_NETWORK_DATA_DIRECTORY/replica-configuration/replica-1.port\"; do echo waiting for replica port; sleep 1; done" \
            || (echo "replica did not write to port file" && exit 1)

        local dfx_config_root="$E2E_NETWORK_DATA_DIRECTORY/replica-configuration"
        test -f "${dfx_config_root}/replica-1.port"
        local replica_port=$(cat "${dfx_config_root}/replica-1.port")

    fi

    printf "Replica Configured Port: %s\n" "${replica_port}"

    timeout 5 sh -c \
        "until nc -z localhost ${replica_port}; do echo waiting for replica; sleep 1; done" \
        || (echo "could not connect to replica on port ${replica_port}" && exit 1)

    # ping the replica directly, because the bootstrap (that launches icx-proxy, which dfx ping usually connects to)
    # is not running yet
    dfx ping --wait-healthy "http://127.0.0.1:${replica_port}"

    # This only works because we use the network by name
    #    (implicitly: --network local)
    # If we passed --network http://127.0.0.1:${replica_port}
    # we would get errors like this:
    #    "Cannot find canister ryjl3-tyaaa-aaaaa-aaaba-cai for network http___127_0_0_1_54084"
    dfx bootstrap --port 0 3>&- &
    export DFX_BOOTSTRAP_PID=$!

    timeout 5 sh -c \
        "until nc -z localhost \$(cat \"$E2E_NETWORK_DATA_DIRECTORY/webserver-port\"); do echo waiting for webserver; sleep 1; done" \
        || (echo "could not connect to webserver on port $(get_webserver_port)" && exit 1)

    webserver_port=$(cat "$E2E_NETWORK_DATA_DIRECTORY/webserver-port")
    proxy_port=$(cat "$E2E_NETWORK_DATA_DIRECTORY/proxy-port")

    # We have to overwrite the webserver port in the network bind so that dfx knows where
    # the bootstrap server is listening
    local webserver_port=$(cat .dfx/webserver-port)
    cat <<<"$(jq .networks.local.bind=\"127.0.0.1:${webserver_port}\" dfx.json)" >dfx.json

    printf "Webserver Configured Port: %s\n", "${webserver_port}"
}

# Start the replica in the background.
dfx_stop_replica_and_bootstrap() {
    [ "$DFX_REPLICA_PID" ] && kill -TERM "$DFX_REPLICA_PID"

    [ "$DFX_BOOTSTRAP_PID" ] && kill -TERM "$DFX_BOOTSTRAP_PID"
}

# Stop the replica and verify it is very very stopped.
dfx_stop() {
    # to help tell if other icx-proxy processes are from this test:
    echo "pwd: $(pwd)"
    # A suspicion: "address already is use" errors are due to an extra icx-proxy process.
    echo "icx-proxy processes:"
    ps aux | grep icx-proxy || echo "no ps/grep/icx-proxy output"

    dfx stop
    local dfx_root=.dfx/
    echo rm -rf $dfx_root

    # Verify that processes are killed.
    assert_no_dfx_start_or_replica_processes
}

dfx_set_wallet() {
  export WALLET_CANISTER_ID=$(dfx identity get-wallet)
  assert_command dfx identity  --network actuallylocal set-wallet ${WALLET_CANISTER_ID} --force
  assert_match 'Wallet set successfully.'
}

setup_actuallylocal_network() {
    webserver_port=$(get_webserver_port)
    [ ! -f "$E2E_NETWORK_DFX_JSON" ] && echo "{}" >"$E2E_NETWORK_DFX_JSON"
    # shellcheck disable=SC2094
    cat <<<"$(jq '.networks.actuallylocal.providers=["http://127.0.0.1:'"$webserver_port"'"]' "$E2E_NETWORK_DFX_JSON")" >"$E2E_NETWORK_DFX_JSON"
}

setup_local_network() {
    if [ "$USE_IC_REF" ]
    then
        local replica_port=$(get_ic_ref_port)
    else
        local replica_port=$(get_replica_port)
    fi

    [ ! -f "$E2E_NETWORK_DFX_JSON" ] && echo "{}" >"$E2E_NETWORK_DFX_JSON"

    # shellcheck disable=SC2094
    cat <<<"$(jq .networks.local.bind=\"127.0.0.1:${replica_port}\" "$E2E_NETWORK_DFX_JSON")" >"$E2E_NETWORK_DFX_JSON"
}

use_wallet_wasm() {
    # shellcheck disable=SC2154
    export DFX_WALLET_WASM="${archive}/wallet/$1/wallet.wasm"
}

get_webserver_port() {
  cat "$E2E_NETWORK_DATA_DIRECTORY/webserver-port"
}
overwrite_webserver_port() {
  echo "$1" >"$E2E_NETWORK_DATA_DIRECTORY/webserver-port"
}

get_replica_pid() {
  cat "$E2E_NETWORK_DATA_DIRECTORY/replica-configuration/replica-pid"
}

get_ic_ref_port() {
  cat "$E2E_NETWORK_DATA_DIRECTORY/ic-ref.port"

}
get_replica_port() {
  cat "$E2E_NETWORK_DATA_DIRECTORY/replica-configuration/replica-1.port"
}

get_btc_adapter_pid() {
  cat "$E2E_NETWORK_DATA_DIRECTORY/ic-btc-adapter-pid"
}

get_canister_http_adapter_pid() {
  cat "$E2E_NETWORK_DATA_DIRECTORY/ic-canister-http-adapter-pid"
}

get_icx_proxy_pid() {
  cat "$E2E_NETWORK_DATA_DIRECTORY/icx-proxy-pid"
}
