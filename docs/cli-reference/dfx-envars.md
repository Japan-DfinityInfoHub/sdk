# 環境変数

環境変数を使って SDK の実行環境の特定のプロパティを設定することができます。

このセクションでは現在サポートされている環境変数とその使い方の例を挙げています。 ほとんどの場合、ターミナルでコマンドを実行するか、`.profile` ファイルに以下のような行を追加することで、セッションの環境変数を設定することができます：

    export DFX_NETWORK=ic

## CANISTER\_CANDID\_PATH\_{canister.name}

`CANISTER_CANDID_PATH` というプレフィックスの環境変数を使って、プロジェクトの `dfx.json` ファイルで依存関係にある Canister の Candid 記述ファイルへのパスを参照することができます。

例えば、 `whoami_assets` Canister があり、 `dependencies` キーに `whoami` がリストされている場合、 `CANISTER_CANDID_PATH_whoami_assets` という 環境変数を使って、ローカル開発で `whoami.did` と記載されるファイルの場所を参照することができます：

    $PROJECT_ROOT/.dfx/local/canisters/whoami/whoami.did

## CANISTER\_ID\_{canister.name}

`CANISTER_ID` というプレフィックスの環境変数を使って、プロジェクトの `dfx.json` ファイルにある各 Canister の識別子を参照することができます。

例えば、`linkedup` と `connectd` Canister からなる `linkedup` プロジェクトがある場合、 `CANISTER_ID_linkedup` と `CANISTER_ID_connectd` 環境変数を使って、プロジェクトで作成した `ryjl3-tyaaaa-aaaaaaa-cai` と `rrkah-fqaaa-aaaaq-cai` など、Canister の識別子を指定することが可能です。

## DFX\_CONFIG\_ROOT

環境変数 `DFX_CONFIG_ROOT` を使用して、`dfx` の `.cache` と `.config` サブディレクトリを格納する場所を指定します。

デフォルトでは、`.cache` と `.config` ディレクトリは開発環境のホームディレクトリに配置されます。 例えば、macOS の場合、デフォルトの場所は `/Users/<YOUR-USER-NAME>` ディレクトリです。 環境変数 `DFX_CONFIG_ROOT` を使用して、これらのディレクトリを別の場所に指定します。

    DFX_CONFIG_ROOT=~/ic-root

## DFX\_INSTALLATION\_ROOT

お使いのオペレーティングシステムのデフォルトの場所を使用しない場合、環境変数 `DFX_INSTALLATION_ROOT` を使用して、`dfx` バイナリを別の場所に指定します。

`.cache/dfinity/uninstall.sh` スクリプトはこの環境変数を使用して SDK インストールのルートディレクトリを特定します。

## DFX\_VERSION

インストールしたい SDK の特定バージョンを指定するには、`DFX_VERSION` 環境変数を使用します。

    DFX_VERSION=0.10.0 sh -ci "$(curl -fsSL https://smartcontracts.org/install.sh)"

<!--
# Environment variables

You can configure certain properties for your SDK execution environment using environment variables.

This section lists the environment variables that are currently supported with examples of how to use them. In most cases, you can set environment variables for a session by executing an command in the terminal or by adding a line similar to the following to your `.profile` file:

    export DFX_NETWORK=ic

## CANISTER_CANDID_PATH\_{canister.name}

Use environment variables with the `CANISTER_CANDID_PATH` prefix to reference the path to the Candid description file for the canisters that are listed as dependencies in the `dfx.json` file for your project.

For example, if you have a `whoami_frontend` canister that lists `whoami` under the `dependencies` key, you could use the `CANISTER_CANDID_PATH_whoami_frontend` environment variable to refer to the location of the `whoami.did` file, which for local development might be:

    $PROJECT_ROOT/.dfx/local/canisters/whoami/whoami.did

## CANISTER_ID\_{canister.name}

Use environment variables with the `CANISTER_ID` prefix to reference the canister identifier for each canister in the `dfx.json` file for your project.  Hyphens are invalid in environment variables and are replaced by underscores.

For example, if you have a `linkedup` project that consists of the `linkedup` and `connect-d` canisters, you could use the `CANISTER_ID_linkedup` and `CANISTER_ID_connect_d` environment variables to refer to the canister identifiers—for example `ryjl3-tyaaa-aaaaa-aaaba-cai` and `rrkah-fqaaa-aaaaa-aaaaq-cai`—created for your project.

## DFX_CONFIG_ROOT

Use the `DFX_CONFIG_ROOT` environment variable to specify a different location for storing the `.cache` and `.config` subdirectories for `dfx`.

By default, the `.cache` and `.config` directories are located in the home directory for your development environment. For example, on macOS the default location is in the `/Users/<YOUR-USER-NAME>` directory. Use the `DFX_CONFIG_ROOT` environment variable to specify a different location for these directories.

    DFX_CONFIG_ROOT=~/ic-root

## DFX_INSTALLATION_ROOT

Use the `DFX_INSTALLATION_ROOT` environment variable to specify a different location for the `dfx` binary if you are not using the default location for your operating system.

The `.cache/dfinity/uninstall.sh` script uses this environment variable to identify the root directory for your SDK installation.

## DFX_VERSION

Use the `DFX_VERSION` environment variable to identify a specific version of the SDK that you want to install.

    DFX_VERSION=0.10.0 sh -ci "$(curl -fsSL https://smartcontracts.org/install.sh)"

-->