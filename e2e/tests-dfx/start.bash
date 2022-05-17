#!/usr/bin/env bats

load ../utils/_

setup() {
    standard_setup
}

teardown() {
    dfx_stop

    standard_teardown
}

@test "dfx start outside of a project" {
    dfx_start
    dfx_new hello

    assert_command dfx deploy

    # cd "$E2E_TEMP_DIR"
}

@test "dfx restarts the replica" {
    [ "$USE_IC_REF" ] && skip "skip for ic-ref"

    dfx_new hello
    dfx_start

    install_asset greet
    assert_command dfx deploy
    assert_command dfx canister call hello greet '("Alpha")'
    assert_eq '("Hello, Alpha!")'

    REPLICA_PID=$(get_replica_pid)

    echo "replica pid is $REPLICA_PID"

    kill -KILL "$REPLICA_PID"
    assert_process_exits "$REPLICA_PID" 15s

    timeout 15s sh -c \
      'until dfx ping; do echo waiting for replica to restart; sleep 1; done' \
      || (echo "replica did not restart" && ps aux && exit 1)
    wait_until_replica_healthy

    # Sometimes initially get an error like:
    #     IC0304: Attempt to execute a message on canister <>> which contains no Wasm module
    # but the condition clears.
    timeout 30s sh -c \
      "until dfx canister call hello greet '(\"wait\")'; do echo waiting for any canister call to succeed; sleep 1; done" \
      || (echo "canister call did not succeed") # but continue, for better error reporting

    assert_command dfx canister call hello greet '("Omega")'
    assert_eq '("Hello, Omega!")'
}

@test "dfx restarts icx-proxy" {
    [ "$USE_IC_REF" ] && skip "skip for ic-ref"

    dfx_new hello
    dfx_start

    install_asset greet
    assert_command dfx deploy
    assert_command dfx canister call hello greet '("Alpha")'
    assert_eq '("Hello, Alpha!")'

    ICX_PROXY_PID=$(get_icx_proxy_pid)

    echo "icx-proxy pid is $ICX_PROXY_PID"

    kill -KILL "$ICX_PROXY_PID"
    assert_process_exits "$ICX_PROXY_PID" 15s

    ID=$(dfx canister id hello_assets)

    timeout 15s sh -c \
      "until curl --fail http://localhost:\$(cat \"$E2E_NETWORK_DATA_DIRECTORY\"/webserver-port)/sample-asset.txt?canisterId=$ID; do echo waiting for icx-proxy to restart; sleep 1; done" \
      || (echo "icx-proxy did not restart" && ps aux && exit 1)

    assert_command curl --fail http://localhost:"$(get_webserver_port)"/sample-asset.txt?canisterId="$ID"
}

@test "dfx restarts icx-proxy when the replica restarts" {
    [ "$USE_IC_REF" ] && skip "skip for ic-ref"

    dfx_new hello
    dfx_start

    install_asset greet
    assert_command dfx deploy
    assert_command dfx canister call hello greet '("Alpha")'
    assert_eq '("Hello, Alpha!")'

    REPLICA_PID=$(get_replica_pid)
    ICX_PROXY_PID=$(get_icx_proxy_pid)

    echo "replica pid is $REPLICA_PID"
    echo "icx-proxy pid is $ICX_PROXY_PID"

    kill -KILL "$REPLICA_PID"
    assert_process_exits "$REPLICA_PID" 15s
    assert_process_exits "$ICX_PROXY_PID" 15s

    timeout 15s sh -c \
      'until dfx ping; do echo waiting for replica to restart; sleep 1; done' \
      || (echo "replica did not restart" && ps aux && exit 1)
    wait_until_replica_healthy

    # Sometimes initially get an error like:
    #     IC0304: Attempt to execute a message on canister <>> which contains no Wasm module
    # but the condition clears.
    timeout 30s sh -c \
      "until dfx canister call hello greet '(\"wait\")'; do echo waiting for any canister call to succeed; sleep 1; done" \
      || (echo "canister call did not succeed") # but continue, for better error reporting

    assert_command dfx canister call hello greet '("Omega")'
    assert_eq '("Hello, Omega!")'

    ID=$(dfx canister id hello_assets)

    timeout 15s sh -c \
      "until curl --fail http://localhost:\$(cat \"$E2E_NETWORK_DATA_DIRECTORY/webserver-port\")/sample-asset.txt?canisterId=$ID; do echo waiting for icx-proxy to restart; sleep 1; done" \
      || (echo "icx-proxy did not restart" && ps aux && exit 1)

    assert_command curl --fail http://localhost:"$(get_webserver_port)"/sample-asset.txt?canisterId="$ID"
}

set_default_subnet_type() {
    subnet_type="$1"
    echo "E2E_NETWORK_DFX_JSON is $E2E_NETWORK_DFX_JSON"
    mkdir -p "$(dirname "$E2E_NETWORK_DFX_JSON")"
    [ ! -f "$E2E_NETWORK_DFX_JSON" ] && echo "{}" >"$E2E_NETWORK_DFX_JSON"
    # shellcheck disable=SC2094
    cat <<<"$(jq ".networks.local.replica.subnet_type=\"$subnet_type\"" "$E2E_NETWORK_DFX_JSON")" >"$E2E_NETWORK_DFX_JSON"

}

@test "dfx starts replica with subnet_type application" {
    determine_network_directory
    # set_default_subnet_type "verifiedapplication"
    install_shared_asset subnet_type/application

    assert_command dfx start --background
    assert_match "subnet_type: Application"

}


@test "dfx starts replica with subnet_type verifiedapplication" {
    #set_default_subnet_type "verifiedapplication"
    determine_network_directory

    install_shared_asset subnet_type/verified_application

    assert_command dfx start --background
    assert_match "subnet_type: VerifiedApplication"

}

@test "dfx starts replica with subnet_type system" {
    install_asset subnet_type/system

    assert_command dfx start --background
    assert_match "subnet_type: System"

}

@test "dfx start detects if dfx is already running" {
    dfx_new hello
    dfx_start

    assert_command_fail dfx start
    assert_match "dfx is already running"
}
