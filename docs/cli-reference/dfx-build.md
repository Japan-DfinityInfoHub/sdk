# dfx build

IC にデプロイできるようにプログラムを WebAssembly モジュールにコンパイルするには `dfx build` コマンドを使用します。 このコマンドはプロジェクトの `dfx.json` 設定ファイルや特定の Canister に定義されているすべてのプログラムをコンパイルするために使用することができます。

このコマンドはプロジェクトのディレクトリ構造内からのみ実行できることに注意してください。 例えばプロジェクト名が `hello_world` の場合、現在の作業ディレクトリは `hello_world` のトップレベルのプロジェクトディレクトリかそのサブディレクトリのいずれかでなければなりません。

`dfx build` コマンドは設定ファイル `dfx.json` の `canisters` セクションで設定された情報を元に、コンパイルするソースコードを探します。

## 基本的な利用法

``` bash
dfx build [flag] [option] [--all | canister_name]
```

## フラグ

`dfx build` コマンドでは、以下のオプションフラグを使用することができます。

|フラグ |説明|
|-------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------|
|`--check` |{platform}に接続せずにプログラムのコンパイルをテストします。一時的なハードコードされたローカル定義の Canister id を使用して Canister を構築します。|
|`-h`, `--help` |利用情報を表示します。|
|`-V`, `--version` |バージョン情報を表示します。|

## オプション

`dfx build` コマンドには以下のオプションを指定することができます。

|オプション |説明|
|-----------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------|
|`--network <network>` |接続したいネットワークのエイリアスまたは URL を指定します。このオプションを使用すると `dfx.json` 設定ファイルで指定されたネットワークを上書きします。|

## 引数

`dfx build` コマンドには以下の引数を指定することができます。

|引数 |説明|
|-----------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
|`--all` |プロジェクトの `dfx.json` ファイルで設定されたすべての Canister をビルドします。|
|`canister_name` |ビルドしたい Canister の名前を指定します。`--all` オプションをもし使用しない場合、引数なしの `dfx build` を使用するか、引数に Canister 名を指定します（ Canister 名はプロジェクトの `dfx.json` 設定ファイルの `canisters` セクションで設定した名前と少なくともひとつは一致しなければなりません）。|


## 例

`dfx build` コマンドを使うと `dfx.json` 設定ファイルの `canisters` キーで指定したプログラムからひとつまたは複数の WebAssembly モジュールをビルドすることができます。 例えば、[こちら](../_attachments/sample-dfx.json)のように `dfx.json` 設定ファイルに `hello_world` Canister と `hello_world_assets` Canister がひとつずつ定義されている場合、 `dfx build` を実行すると二つの WebAssembly モジュールがコンパイルされます。

ファイルシステム上のプログラムのファイル名とパスは、`dfx.json` 設定ファイルで指定された情報と一致する必要があることに注意してください。

この例では、 `hello_world` Canister にメインプログラムのコードが `hello_world_assets` Canister にフロントエンドのコードとアセットが格納されています。 もし、`dfx.json` ファイルで定義された `hello_world_assets` Canister はそのままにして、バックエンドのプログラムだけをビルドしたい場合は、以下のコマンドを実行すれば可能です：

``` bash
dfx build hello_world
```

特定の Canister をビルドすることは dfx.json ファイルに複数の Canister が定義されていて、Canister に対する操作を個別にテストおよびデバッグしたい場合に便利です。

{platform}やローカルの Canister 実行環境に接続せずに Canister がコンパイルされるかどうかをテストするには、以下のコマンドを実行します：

``` bash
dfx build --check
```

<!--
# dfx build

Use the `dfx build` command to compile your program into a WebAssembly module that can be deployed on the IC. You can use this command to compile all of the programs that are defined for a project in the project’s `dfx.json` configuration file or a specific canister.

Note that you can only run this command from within the project directory structure. For example, if your project name is `hello_world`, your current working directory must be the `hello_world` top-level project directory or one of its subdirectories.

The `dfx build` command looks for the source code to compile using the information you have configured under the `canisters` section in the `dfx.json` configuration file.

## Basic usage

``` bash
dfx build [flag] [option] [--all | canister_name]
```

## Flags

You can use the following optional flags with the `dfx build` command.

| Flag              | Description                                                                                                                                                      |
|-------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `--check`         | Builds canisters using a temporary, hard-coded, locally-defined canister identifier for testing that your program compiles without connecting to the IC. |
| `-h`, `--help`    | Displays usage information.                                                                                                                                      |
| `-V`, `--version` | Displays version information.                                                                                                                                    |

## Options

You can specify the following option for the `dfx build` command.

| Option                | Description                                                                                                                                                |
|-----------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `--network <network>` | Specifies the network alias or URL you want to connect to. You can use this option to override the network specified in the `dfx.json` configuration file. |

## Arguments

You can specify the following arguments for the `dfx build` command.

| Argument        | Description                                                                                                                                                                                                                                                                                                                              |
|-----------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `--all`         | Builds all of the canisters configured in the project’s `dfx.json` file.                                                                                                                                                                                                                                                                 |
| `canister_name` | Specifies the name of the canister you want to build. If you are not using the `--all` option, you can continue to use `dfx build` or provide a canister name as an argument (the canister name must match at least one name that you have configured in the `canisters` section of the `dfx.json` configuration file for your project.) |

## Examples

You can use the `dfx build` command to build one or more WebAssembly modules from the programs specified in the `dfx.json` configuration file under the `canisters` key. For example, if your `dfx.json` configuration file defines one `hello_world_backend` canister and one `hello_world_frontend` canister [like this](../_attachments/sample-dfx.json), then running `dfx build` compiles two WebAssembly modules.

Note that the file name and path to the programs on your file system must match the information specified in the `dfx.json` configuration file.

In this example, the `hello_world_backend` canister contains the main program code and the `hello_world_frontend` canister store frontend code and assets. If you want to keep the `hello_world_frontend` canister defined in the `dfx.json` file, but only build the backend program, you could run the following command:

``` bash
dfx build hello_world_backend
```

Building a specific canister is useful when you have multiple canisters defined in the dfx.json file, but want to test and debug operations for canisters independently.

To test whether a canister compiles without connecting to the IC or the local canister execution environment, you would run the following command:

``` bash
dfx build --check
```

-->