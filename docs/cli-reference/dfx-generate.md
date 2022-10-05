# dfx generate

サポートされているプログラミング言語用の Canister 型宣言を生成するには、 `dfx generate` コマンドを使用します。 `dfx generate` は、現在、4つの言語（ Motoko、Candid、JavaScript、TypeScript ）をサポートしています。

このコマンドを使うと、プロジェクトの `dfx.json` 設定ファイルで定義されているすべての Canister または特定の Canister の型宣言を生成することができます。

このコマンドはプロジェクトのディレクトリ構造内からのみ実行出来ることに注意してください。 例えば、プロジェクト名が `hello_world` の場合、現在の作業ディレクトリは `hello_world` のトップレベルのプロジェクトディレクトリかそのサブディレクトリのいずれかである必要があります。

`dfx generate` コマンドは、`dfx.json` 設定ファイル内、 Canister の `declarations` セクション下の設定を探しにいきます。

## 基本的な利用法

``` bash
dfx generate [canister_name]
```

## フラグ

`dfx generate` コマンドでは、以下のオプションフラグを使用することができます。

|フラグ |説明|
|-------------------|-------------------------------|
|`-h`, `--help` |利用情報を表示します。|
|`-V`, `--version` |バージョン情報を表示します。|

## 引数

`dfx generate` コマンドには以下の引数を指定することができます。

|引数 |説明|
|-------------------|-------------------------------|
|`canister_name` |型宣言を生成するための Canister の名前を指定します。この Canister 名はプロジェクトの `dfx.json` 設定ファイルの `canisters` セクションで設定した名前と少なくとも1つは一致している必要があります。この引数を指定しない場合、`dfx generate` は `dfx.json` で宣言されたすべての Canister に対して型宣言を生成します。|

## 設定

`dfx generate` の動作は `dfx.json` 設定ファイルによって制御されます。 `dfx.json` → `canisters` → `<canister_name>` の下に、 `declarations` セクションを追加することができます。 このセクションでは、以下のフィールドを指定することができます。

|フィールド|説明|
|-------------------|-------------------------------|
|`output` |Canister の宣言を配置するディレクトリで、デフォルトは `src/declarations/<canister_name>` です。|
|`bindings` |型宣言を生成するための言語のリストで、オプションは `"js", "ts", "did", "mo "` です。デフォルトは `["js", "ts", "did"]` です。|
|`env_override` |`src/dfx/assets/language_bindings/canister.js` テンプレート内の `process.env.{canister_name_uppercase}_CANISTER_ID` を置き換えるための文字列です。|

`dfx generate` からの出力は以下の通りです。

|言語 |ファイル|
|-------------------|-------------------------------|
|`JavaScript(js)` |`index.js` と `<canister_name>.did.js`|
|`TypeScript(ts)` |`<canister_name>.did.ts`|
|`Candid(did)` |`<canister_name>.did`|
|`Motoko(mo)` |`<canister_name>.mo`|

## 例

`dfx generate` の出力例は [こちら](../_attachments/sample-generate-dfx.json) です。

ファイルシステム上のプログラムのファイル名とパスは設定ファイル `dfx.json` で指定された情報と一致している必要があることに注意してください。

この例では、`hello_world` Canister そのものは Motoko で書かれています。`declarations` セクションでは、4つの言語の型宣言が生成、保存される `src/declarations/` が指定されています。

``` bash
dfx generate hello_world
```

`dfx.json` には Canister が一つしかないので、引数なしで `dfx generate` を呼び出すと、上記のコマンドと同じ効果が得られます。 もし、`dfx.json` に複数の Canister が定義されていた場合、定義されているすべての Canister の型宣言を生成することになります。

``` bash
dfx generate
```

<!--
# dfx generate

Use the `dfx generate` command to generate canister type declarations for supported programming languages. Currently, `dfx generate` supports four languages: Motoko, Candid, JavaScript, and TypeScript.

You can use this command to generate type declarations for all canisters that are defined for a project in the project’s `dfx.json` configuration file or a specific canister.

Note that you can only run this command from within the project directory structure. For example, if your project name is `hello_world`, your current working directory must be the `hello_world` top-level project directory or one of its subdirectories.

The `dfx generate` command looks for the configuration under the `declarations` section of a canister in the `dfx.json` configuration file.

## Basic usage

``` bash
dfx generate [canister_name]
```

## Flags

You can use the following optional flags with the `dfx generate` command.

| Flag              | Description                   |
|-------------------|-------------------------------|
| `-h`, `--help`    | Displays usage information.   |
| `-V`, `--version` | Displays version information. |

## Arguments

You can specify the following arguments for the `dfx generate` command.

| Argument        | Description                                                                                                                                                                                                                                                                                                                                                        |
|-----------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `canister_name` | Specifies the name of the canister for which to generate type declarations. The canister name must match at least one name that you have configured in the `canisters` section of the `dfx.json` configuration file for your project. If you don’t specify this argument, `dfx generate` will generate type declarations for all canisters declared in `dfx.json`. |

## Configuration

The behavior of `dfx generate` is controlled by the `dfx.json` configuration file. Under `dfx.json` → `canisters` → `<canister_name>`, you can add a `declarations` section. In this section, you can specify the following fields:

| Field          | Description                                                                                                                                  |
|----------------|----------------------------------------------------------------------------------------------------------------------------------------------|
| `output`       | Directory to place declarations for the canister. Default is `src/declarations/<canister_name>`.                                             |
| `bindings`     | List of languages to generate type declarations. Options are `"js", "ts", "did", "mo"`. Default is `["js", "ts", "did"]`.                    |
| `env_override` | String that will replace `process.env.{canister_name_uppercase}_CANISTER_ID` in the `src/dfx/assets/language_bindings/canister.js` template. |

Outputs from `dfx generate`:

| Language         | File                                     |
|------------------|------------------------------------------|
| `JavaScript(js)` | `index.js` and `<canister_name>.did.js`  |
| `TypeScript(ts)` | `index.d.ts` and `<canister_name>.did.ts`|
| `Candid(did)`    | `<canister_name>.did`                    |
| `Motoko(mo)`     | `<canister_name>.mo`                     |

## Examples

[This](../_attachments/sample-generate-dfx.json) is a sample output of `dfx generate`.

Note that the file name and path to the programs on your file system must match the information specified in the `dfx.json` configuration file.

In this example, the `hello_world` canister itself is written in Motoko. The `declarations` section specifies that type declarations for all four languages will be generated and stored at `src/declarations/`.

``` bash
dfx generate hello_world
```

Since there is only one canister in `dfx.json`, calling `dfx generate` without an argument will have the same effect as the above command. If there were multiple canisters defined in `dfx.json`, this would generate type declarations for all defined canisters.

``` bash
dfx generate
```

-->