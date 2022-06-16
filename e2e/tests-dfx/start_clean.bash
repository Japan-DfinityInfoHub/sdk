#!/usr/bin/env bats

load ../utils/_

setup() {
    standard_setup
}

teardown() {
    dfx_stop

    standard_teardown
}

@test "project data is cleared after dfx start --clean from outside the project" {

    dfx_start

    (
        dfx_new hello
        dfx deploy
    )

    dfx_stop
    dfx_start --clean

    (
        cd hello
        assert_command_fail dfx canister id hello
    )
}
