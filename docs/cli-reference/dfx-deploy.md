# dfx deploy

ローカルの Canister 実行環境、IC または指定したテストネットにアプリを登録、ビルド、デプロイするには `dfx deploy` コマンドを使用します。 プロジェクトの `dfx.json` 設定ファイルで定義された全ての Canister がデフォルトでデプロイされます。

以下のコマンドを別々の手順で実行する代わりに、このコマンド1つを実行することで、開発者のワークフローを簡素化します：

    dfx canister create --all
    dfx build
    dfx canister install --all

このコマンドはプロジェクトのディレクトリ構造内からのみ実行できることに注意してください。 例えば、プロジェクト名が `hello_world` の場合、現在の作業ディレクトリは `hello_world` のトップレベルのプロジェクトディレクトリかそのサブディレクトリのいずれかである必要があります。

## 基本的な利用法

``` bash
dfx deploy [flag] [option] [canister_name]
```

## フラグ

`dfx deploy` コマンドでは、以下のオプションフラグを使用することができます。

|フラグ |説明|
|-------------------|-------------------------------|
|`-h`, `--help` |利用情報を表示します。
|`-V`, `--version` |バージョン情報を表示します。

## オプション

`dfx deploy` コマンドでは、以下のオプションを使用することができます。

|オプション |説明|
|-------------------|-------------------------------|
|`--network <network>` |接続先の環境をオーバーライドします。ローカル Canister の実行環境がデフォルトで使用されます。|
|`--argument <argument>` |デプロイ時に Canister に渡す Candid 構文を使用した引数を指定します。このオプションでは {proglang} プログラムで Actor クラスを定義する必要があることに注意してください。|
|`--with-cycles <number-of-cycles>` |プロジェクト内の Canister の初期 Cycle 数を指定します。|

## 引数

`dfx deploy` コマンドには以下の引数を指定することができます。

|引数 |説明|
|-------------------|-------------------------------|
|`canister_name` |登録、ビルド、およびデプロイする Canister の名前を指定します。指定する Canister 名はプロジェクトの `dfx.json` 設定ファイルの `canisters` セクションにある名前と少なくとも1つは一致する必要があることに注意してください。もし、Canister 名を指定しなかった場合、`dfx deploy` は `dfx.json` ファイルに定義されている全ての Canister をデプロイします。|

## 例

`dfx deploy` コマンドを使用すると、ローカルな Canister 実行環境、{platform} または指定したテストネット上に、全てまたは特定の Canister をデプロイすることができます。

例えば、`dfx.json` 設定ファイルで設定された仮想的な `ic-pubs` テストネット上に `hello` プロジェクトをデプロイするには、以下のコマンドを実行します：

``` bash
dfx deploy hello --network ic-pubs
```

ローカル Canister 実行環境上にプロジェクトをデプロイし、インストールの手順に単一の引数を渡すには、次のようなコマンドを実行します：

``` bash
dfx deploy hello_actor_class --argument '("from DFINITY")'
```

現在、{proglang} Dapp で Actor クラスを使用しなければならないことに注意してください。 この例では、`dfx deploy` コマンドは `hello_actor_class` Canister に渡す引数を指定します。 `hello_actor_class` Canister のメインプログラムは以下のようなものです：

    actor class Greet(name: Text) {
        public query func greet() : async Text {
            return "Hello, " # name # "!";
        };
    };

`dfx deploy` コマンドで `--with-cycles` オプションを指定すると、ウォレットで作成される Canister の初期残高を指定することができます。Canister を指定しない場合、指定した Cycle 数がデフォルトで全ての Canister に追加されます。これを避けるには特定の Canister を名前で指定します。例えば、hello-assets という名前の Canister に8000000000000 Cycle の初期残高を追加するには、次のコマンドを実行します。

``` bash
dfx deploy --with-cycles 8000000000000 hello-assets
```


<!--
# dfx deploy

Use the `dfx deploy` command to register, build, and deploy a dapp on the local canister execution environment, on the IC or on a specified testnet. By default, all canisters defined in the project `dfx.json` configuration file are deployed.

This command simplifies the developer workflow by enabling you to run one command instead of running the following commands as separate steps:

    dfx canister create --all
    dfx build
    dfx canister install --all

Note that you can only run this command from within the project directory structure. For example, if your project name is `hello_world`, your current working directory must be the `hello_world` top-level project directory or one of its subdirectories.

## Basic usage

``` bash
dfx deploy [flag] [option] [canister_name]
```

## Flags

You can use the following optional flags with the `dfx deploy` command.

| Flag              | Description                   |
|-------------------|-------------------------------|
| `-h`, `--help`    | Displays usage information.   |
| `-V`, `--version` | Displays version information. |

## Options

You can use the following options with the `dfx deploy` command.

| Option                             | Description                                                                                                                                                                 |
|------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `--network <network>`              | Overrides the environment to connect to. By default, the local canister execution environment is used.                                                                      |
| `--argument <argument>`            | Specifies an argument using Candid syntax to pass to the canister during deployment. Note that this option requires you to define an actor class in the Motoko program. |
| `--with-cycles <number-of-cycles>` | Enables you to specify the initial number of cycles for a canister in a project.                                                                                            |

### Arguments

You can specify the following arguments for the `dfx deploy` command.

| Argument        | Description                                                                                                                                                                                                                                                                                                                                    |
|-----------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `canister_name` | Specifies the name of the canister you want to register, build, and deploy. Note that the canister name you specify must match at least one name in the `canisters` section of the `dfx.json` configuration file for the project. If you don’t specify a canister name, `dfx deploy` will deploy all canisters defined in the `dfx.json` file. |

## Examples

You can use the `dfx deploy` command to deploy all or specific canisters on the local canister execution environment, on the IC or on a specified testnet.

For example, to deploy the `hello` project on the hypothetical `ic-pubs` testnet configured in the `dfx.json` configuration file, you can run the following command:

``` bash
dfx deploy hello_backend --network ic-pubs
```

To deploy a project on the local canister execution environment and pass a single argument to the installation step, you can run a command similar to the following:

``` bash
dfx deploy hello_actor_class --argument '("from DFINITY")'
```

Note that currently you must use an actor class in your Motoko dapp. In this example, the `dfx deploy` command specifies an argument to pass to the `hello_actor_class` canister. The main program for the `hello_actor_class` canister looks like this:

    actor class Greet(name: Text) {
        public query func greet() : async Text {
            return "Hello, " # name # "!";
        };
    };

You can use the `dfx deploy` command with the `--with-cycles` option to specify the initial balance of a canister created by your wallet. If you don’t specify a canister, the number of cycles you specify will be added to all canisters by default. To avoid this, specify a specific canister by name. For example, to add an initial balance of 8000000000000 cycles to a canister called "hello-assets", run the following command:

``` bash
dfx deploy --with-cycles 8000000000000 hello-assets
```

-->