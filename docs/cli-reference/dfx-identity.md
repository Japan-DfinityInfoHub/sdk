# dfx identity

コマンドを実行したり、IC やローカルの Canister 実行環境と通信するために使用する Identity を管理するには、`dfx identity` コマンドとサブコマンド、フラグを使用します。 複数のユーザー Identity を作成することで、ユーザーベースのアクセス制御をテストすることができます。

`dfx identity` コマンドの基本的な構文は以下の通りです：

    dfx identity [subcommand] [flag]

指定する `dfx identity` サブコマンドによっては、追加の引数、オプション、フラグが適用されたり、要求されたりする場合があります。 特定の `dfx identity` サブコマンドの使用情報を表示するには、そのサブコマンドと `--help` フラグを指定します。 例えば、`dfx identity new` の使用情報を見るには、以下のコマンドを実行します：

``` bash
dfx identity new --help
```

`dfx identity` コマンドの使用方法を説明する参考情報と例については、適切なコマンドを選択してください。


|コマンド |説明|
|-------------------------------------------------|---------------------------------------------------------------------------------------------------------------------------|
| [`get-principal`](#dfx-identity-get-principal) | 現在の Identity に関連付けられた Principal のテキスト表現を表示します。|
| [`get-wallet`](#dfx-identity-get-wallet) | Identity に関連付けたウォレットの Canister ID を表示します。|
|`help` |この使用法のメッセージまたは指定されたサブコマンドのヘルプを表示します。|
| [`import`](#dfx-identity-import) | Principal の鍵情報またはセキュリティ証明書を含む PEM ファイルをインポートして、新しい Identity を作成します。|
| [`list`](#dfx-identity-list) |既存の Identity のリストを表示します。|
|　[`new`](#dfx-identity-new)  |新しい Identity を作成します。|
| [`remove`](#dfx-identity-remove) |既存の Identity を削除します。|
| [`rename`](#dfx-identity-rename) |既存の Identity の名前を変更します。|
| [`set-wallet`](#dfx-identity-set-wallet) | 現在の Identity の Principal を使用するためのウォレット Canister ID を設定します。|
| [`use`](#dfx-identity-use) |利用する Identity を指定します。|
| [`whoami`](#dfx-identity-whoami) |現在の Identity に紐づくユーザー名を表示します。|

## デフォルトの Identity を作成する

初めて `dfx canister create` コマンドを実行して Identity を登録するとき、公開鍵と秘密鍵のペアの認証情報が `default` ユーザー Identity として使用されます。 `default` ユーザーの認証情報は `$HOME/.dfinity/identity/creds.pem` から `$HOME/.config/dfx/identity/default/identity.pem` へ移行されます。

その後、`dfx identity new` を使用して新しいユーザー Identity を作成し、それらの Identity の認証情報を `$HOME/.config/dfx/identity/<identity_name>/identity.pem` ファイルに保存することができます。 例えば、以下のコマンドを実行して `ic_admin` という名前の Identity を作成することができます：

    dfx identity new ic_admin

このコマンドは `ic_admin` ユーザ Identity 用の秘密鍵を `~/.config/dfx/identity/ic_admin/identity.pem` ファイルに追加します。

## dfx identity get-principal

現在のユーザー Identity に関連付けられた Principal のテキスト表現を表示するには、`dfx identity get-principal` コマンドを使用します。

もし、ユーザー Identity をまだ作成していない場合は、このコマンドを使用して `default` ユーザーの Principal を表示することができます。 Principal のテキスト表現は、ロールベースの認証シナリオを構築してテストするのに便利です。

### 基本的な利用法

``` bash
dfx identity get-principal [flag]
```

### フラグ

`dfx identity get-principal` コマンドでは、以下のオプションフラグを使用することができます。

|フラグ |説明|
|-------------------|-------------------------------|
|`-h`, `--help` |利用情報を表示します。|
|`-V`, `--version` |バージョン情報を表示します。|

### 例

特定のユーザー Identity に関連付けられた Principal のテキスト表現を表示する場合、次のようなコマンドを実行してください：

``` bash
dfx identity use ic_admin
dfx identity get-principal
```

この例では、最初のコマンドで `ic_admin` という Identity を使用するようにユーザーの環境を設定しています。2番目のコマンドは `ic_admin` Identity に関連付けられた Principal を返します。

## dfx identity get-wallet

現在の Identity の Principal に関連付けられたウォレットの Canister ID を表示するには、`dfx identity get-wallet` コマンドを使用します。

このコマンドを実行するには、IC またはローカルの Canister 実行環境に接続されている必要があることに注意してください。 さらに、このコマンドを実行するには、プロジェクト・ディレクトリにいる必要があります。 例えば、プロジェクト名が `hello_world` の場合、`dfx identity get-wallet` コマンドを実行するには、現在の作業ディレクトリが `hello_world` トップレベルのプロジェクトディレクトリかそのサブディレクトリのいずれかになる必要があります。

### 基本的な利用法

``` bash
dfx identity get-wallet [flag]
```

### フラグ

`dfx identity get-wallet` コマンドでは、以下のオプションフラグを使用することができます。

|フラグ |説明|
|-------------------|-------------------------------|
|`-h`, `--help` |利用情報を表示します。|
|`-V`, `--version` |バージョン情報を表示します。|

### 例

自分の Identity に関連付けられたウォレット Canister の Canister ID を表示したい場合は、以下のコマンドを実行します：

``` bash
dfx identity get-wallet
```

特定のテストネットで自分の Identity に関連付けられたウォレット Canister の Canister ID を表示するには、次のようなコマンドを実行します。

``` bash
dfx identity --network=https://192.168.74.4 get-wallet
```

## dfx identity import

ユーザーの鍵情報またはセキュリティ証明書を PEM ファイルからインポートしてユーザー Identity を作成するには、`dfx identity import` コマンドを使用します。

### 基本的な利用法

``` bash
dfx identity import [options] identity-name pem_file-name
```

### フラグ

`dfx identity import` コマンドでは、以下のオプションフラグを使用することができます。

|フラグ |説明|
|-------------------|-------------------------------|
|`-h`, `--help` |利用情報を表示します。|
|`-V`, `--version` |バージョン情報を表示します。|

### オプション

`dfx identity import` コマンドでは、以下のオプションを使用することができます。

|引数|説明|
|--------|-----------|
|`--disable-encryption` |危険：デフォルトでは、PEM ファイルはディスクに書き込む際にパスワードで暗号化されます。このフラグで暗号化を無効にすることができます。パスワードを入力する必要がなく便利ですが、PEM ファイルが危険にさらされる危険性があります。|
|`--force` |もし Identity が既に存在していれば、削除して再度インポートを行います。|

### 例

`dfx identity import` コマンドを使用すると、Identity に使用するセキュリティ証明書を含む PEM ファイルをインポートすることができます。 例えば、以下のコマンドを実行して `generated-id.pem` ファイルをインポートし、ユーザー Identity である `alice` を作成することができます。

``` bash
dfx identity import alice generated-id.pem
```

このコマンドは `generated-id.pem` ファイルを `~/.config/dfx/identity/alice` ディレクトリに追加します。

## dfx identity list

利用可能なユーザー Identity のリストを表示するには、`dfx identity list` コマンドを使用します。 このコマンドを実行すると、リストには現在アクティブなユーザー環境を示すアスタリスク (\*) が表示されます。 Identity はグローバルであることに注意してください。特定のプロジェクトの環境に限定されるものではありません。 したがって、`dfx identity list` コマンドでリストアップされた Identity はどのプロジェクトでも使用することができます。

### 基本的な利用法

``` bash
dfx identity list [flag]
```

### フラグ

`dfx identity list` コマンドでは、以下のオプションフラグを使用することができます。

|フラグ |説明|
|-------------------|-------------------------------|
|`-h`, `--help` |利用情報を表示します。|
|`-V`, `--version` |バージョン情報を表示します。|

### 例

`dfx identity list` コマンドを使用すると、現在利用可能なすべての Identity をリストアップし、どの Identity が `dfx` コマンドを実行する際に現在アクティブなユーザー環境として使用されているかを判断することができます。 例えば、以下のコマンドを実行すると、利用可能な Identity をリストアップすることができます：

``` bash
dfx identity list
```

このコマンドは、次のように見つかった Identity の一覧を表示します：

``` bash
alice_auth
anonymous
bob_standard *
default
ic_admin
```

この例では、`bob_standard` Identity が現在アクティブなユーザー環境となります。 このコマンドを実行してアクティブなユーザーを決定した後、追加で実行する `dfx` コマンドは `bob_standard` Identity に関連付けられた Principal を使用して実行されることになります。

## dfx identity new

新しいユーザー Identity を追加するには、`dfx identity new` コマンドを使用します。 追加した Identity はグローバルなものであることに注意する必要があります。これらは特定のプロジェクトの環境に限定されるものではありません。 したがって、 `dfx identity new` コマンドで追加した Identity はどのプロジェクトでも使用することができます。

### 基本的な利用法

``` bash
dfx identity new [options] _identity-name_
```

### フラグ

`dfx identity new` コマンドでは、以下のオプションフラグを使用することができます。

|フラグ |説明|
|-------------------|-------------------------------|
|`-h`, `--help` |利用情報を表示します。|
|`-V`, `--version` |バージョン情報を表示します。|

### 引数

`dfx identity new` コマンドには、以下の引数を指定する必要があります。

|引数|説明|
|-------------------|-------------------------------|
|`<identity_name>` |作成する Identity の名前を指定します。この引数は必須です。|

### オプション

`dfx identity new` コマンドでは、以下のオプションを使用することができます。

|引数|説明|
|--------|-----------|
|`--disable-encryption` |危険：デフォルトでは、PEM ファイルはディスクに書き込む際にパスワードで暗号化されます。このフラグで暗号化を無効にすることができます。パスワードを入力する必要がなく便利ですが、PEM ファイルが危険にさらされる危険性があります。|
|`--force` |もし Identity が既に存在していれば、削除して再度インポートを行います。|
|`--hsm-key-id <hsm key id>` |16進数の数字の組のシーケンスを指定します。|
|`--hsm-pkcs11-lib-path <hsm pkcs11 lib path>` |  opensc-pkcs11 ライブラリへのパスを指定します。例えば、"/usr/local/lib/opensc-pkcs11.so" のようになります。|

### 例

その後、`dfx identity new` を使用して新しいユーザー Identity を作成し、それらの Identity の認証情報を `$HOME/.config/dfx/identity/<identity_name>/identity.pem` ファイルに保存することができます。 例えば、以下のコマンドを実行して `ic_admin` という名前の Identity を作成することができます：

    dfx identity new ic_admin

このコマンドは `ic_admin` ユーザー Identity 用の秘密鍵を `~/.config/dfx/identity/ic_admin/identity.pem` ファイル内に追加します。

新しい Identity 用の秘密鍵を追加した後、コマンドは Identity が作成されたことを確認するメッセージを表示します：

    Creating identity: "ic_admin".
    Created identity: "ic_admin".

## dfx identity remove

既存のユーザー Identity を削除するには、`dfx identity remove` コマンドを使用します。 あなたが追加した Identity はグローバルなものであることに注意してください。これらは特定のプロジェクトの環境に限定されるものではありません。 したがって、`dfx identity remove` コマンドを使用して削除した Identity は、どのプロジェクトでも使用することができなくなります。

### 基本的な利用法

``` bash
dfx identity remove [flag] _identity-name_
```

### フラグ

`dfx identity remove` コマンドでは、以下のオプションフラグを使用することができます。

|フラグ |説明|
|-------------------|-------------------------------|
|`-h`, `--help` |利用情報を表示します。|
|`-V`, `--version` |バージョン情報を表示します。|
| `--drop-wallets`  | ユーザーが誤ってウォレットへのアクセス権を失わないようにするため、Identity にウォレットが設定されている場合にこのフラグの設定が必要となります。|

### 引数

`dfx identity remove` コマンドには、以下の引数を指定する必要があります。

|引数|説明|
|-------------------|-------------------------------|
|`<identity_name>` |作成する Identity の名前を指定します。この引数は必須です。|

### 例

`dfx identity remove` コマンドを使用すると、`default` ユーザー Identity を含む、以前に作成された Identity を削除することができます。 例えば、名前付きユーザー Identity を追加していて、`default` ユーザー Identity を削除したい場合、以下のコマンドを実行します：

    dfx identity remove default

コマンドは、Identity が削除されたことの確認を表示します：

    Removing identity "default".
    Removed identity "default".

`default` Identity は、置き換えるために他の Identity を作成した場合、削除することができますが、常に少なくとも1つの Identity が利用可能である必要があります。 最後に残ったユーザー環境を削除しようとすると、 `dfx identity remove` コマンドは次のようなエラーを表示します：

    Identity error:
      Cannot delete the default identity

1つ以上のウォレットが設定された Identity の場合、`--drop-wallets` フラグを付与して呼び出した場合のみ、その Identity は削除されます。これは、ユーザーが誤って Cycle ウォレットへのアクセス権を失わないようにするためです。少なくとも1つのウォレットが設定されている Identity を削除しようとすると、設定されているウォレットが以下のように表示されます。

    This identity is connected to the following wallets:
        identity 'mainnet' on network 'ic' has wallet rwlgt-iiaaa-aaaaa-aaaaa-cai

## dfx identity rename

既存のユーザー Identity の名前を変更するには、`dfx identity rename` コマンドを使用します。 あなたが追加した Identity はグローバルなものであることに注意してください。これらは特定のプロジェクトの環境に限定されるものではありません。 したがって、`dfx identity rename` コマンドを使用して名前を変更した Identity は、どのプロジェクトでも新しい名前で利用することができます。

### 基本的な利用法

``` bash
dfx identity rename [flag] _from_identity-name_ _to_identity-name_
```

### フラグ

`dfx identity rename` コマンドでは、以下のオプションフラグを使用することができます。

|フラグ |説明|
|-------------------|-------------------------------|
|`-h`, `--help` |利用情報を表示します。|
|`-V`, `--version` |バージョン情報を表示します。|

### 引数

`dfx identity rename` コマンドには、以下の引数を指定する必要があります。

|引数 |説明|
|-------------------|-------------------------------|
|`<from_identity_name>` |名前を変更したい Identity の現在の名前を指定します。この引数は必須です。|
|`<to_identity_name>` |名前を変更したい Identity の新しい名前を指定します。この引数は必須です。|

### 例

`default` ユーザー、または以前に作成した Identity の名前は `dfx identity rename` コマンドを使用して変更することができます。 例えば、以前に作成した `test_admin` という Identity の名前を変更したい場合、以下のようなコマンドを実行して、変更したい現在の Identity 名を **from**、変更したい新しい名前を **to** に指定します：

    dfx identity rename test_admin devops

## dfx identity set-wallet

ユーザー Identity に使用するウォレット Canister ID を指定するには、`dfx identity set-wallet` コマンドを使用します。

### 基本的な利用法

``` bash
dfx identity set-wallet [flag] [--canister-name canister-name]
```

### フラグ

`dfx identity set-wallet` コマンドでは、以下のオプションフラグを使用することができます。

|フラグ |説明|
|-------------------|-------------------------------|
| `--force`           | 指定した Canister が有効なウォレット Canister であるかどうかの検証をスキップします。このオプションは、ローカルで動作している IC に接続する場合にのみ有効です。 |
|`-h`, `--help` |利用情報を表示します。|
|`-V`, `--version` |バージョン情報を表示します。|

### 例

ユーザー Identity に複数の Principal を使用している場合、複数のウォレット Canister ID にアクセスすることができます。 `dfx identity set-wallet` コマンドを使用すると、与えられた Identity に使用するウォレット Canister の ID を指定することができます。

例えば、ウォレット Canister の ID を環境変数に保存し、次のように実行して `dfx identity set-wallet` コマンドを呼び出し、追加の操作にそのウォレット Canister を使用することができます：

    export WALLET_CANISTER_ID=$(dfx identity get-wallet)
    dfx identity --network=https://192.168.74.4 set-wallet --canister-name ${WALLET_CANISTER_ID}

## dfx identity use

`dfx identity use` コマンドを使用して、アクティブにしたいユーザー Identity を指定します。 使用可能な Identity はグローバルなものであることに注意してください。特定のプロジェクトの環境に限定されるものではありません。 したがって、以前に作成した Identity はどのプロジェクトでも使用することができます。

### 基本的な利用法

``` bash
dfx identity use [flag] _identity-name_
```

### フラグ

`dfx identity use` コマンドでは、以下のオプションフラグを使用することができます。

|フラグ |説明|
|-------------------|-------------------------------|
|`-h`, `--help` |利用情報を表示します。|
|`-V`, `--version` |バージョン情報を表示します。|

### 引数

`dfx identity use` コマンドには、以下の引数を指定する必要があります。

|引数|説明|
|-------------------|-------------------------------|
|`<identity_name>` |作成する Identity の名前を指定します。この引数は必須です。|


### 例

同じユーザー Identity の環境で複数のコマンドを実行したい場合は、次のようなコマンドを実行します：

    dfx identity use ops

このコマンドを実行した後、以降のコマンドは `ops` ユーザに関連する認証情報およびアクセス制御を使用します。

## dfx identity whoami

現在アクティブなユーザー Identity　環境の名前を表示するには、`dfx identity whoami` コマンドを使用します。

### 基本的な利用法

``` bash
dfx identity whoami [flag]
```

### フラグ

`dfx identity whoami` コマンドでは、以下のオプションフラグを使用することができます。

|フラグ |説明|
|-------------------|-------------------------------|
|`-h`, `--help` |利用情報を表示します。|
|`-V`, `--version` |バージョン情報を表示します。|

### 例

現在アクティブなユーザー Identity の名前を表示したい場合は、次のコマンドを実行します：

    dfx identity whoami

コマンドはユーザー Identity の名前を表示します。 例えば、以前に `dfx identity use bob_standard` というコマンドを実行していた場合、コマンドは次のように表示します。

    bob_standard

<!--
# dfx identity

Use the `dfx identity` command with subcommands and flags to manage the identities used to execute commands and communicate with the IC or the local canister execution environment. Creating multiple user identities enables you to test user-based access controls.

The basic syntax for running `dfx identity` commands is:

``` bash
dfx identity [subcommand] [flag]
```

Depending on the `dfx identity` subcommand you specify, additional arguments, options, and flags might apply or be required. To view usage information for a specific `dfx identity` subcommand, specify the subcommand and the `--help` flag. For example, to see usage information for `dfx identity new`, you can run the following command:

``` bash
dfx identity new --help
```

For reference information and examples that illustrate using `dfx identity` commands, select an appropriate command.

| Command                                         | Description                                                                                                               |
|-------------------------------------------------|---------------------------------------------------------------------------------------------------------------------------|
| [`get-principal`](#dfx-identity-get-principal) | Shows the textual representation of the principal associated with the current identity.                                   |
| [`get-wallet`](#dfx-identity-get-wallet)       | Shows the canister identifier for the wallet associated with your current identity principal.                             |
| `help`                                          | Displays this usage message or the help of the given subcommand(s).                                                       |
| [`import`](#dfx-identity-import)               | Creates a new identity by importing a PEM file that contains the key information or security certificate for a principal. |
| [`list`](#dfx-identity-list)                   | Lists existing identities.                                                                                                |
| [`new`](#dfx-identity-new)                     | Creates a new identity.                                                                                                   |
| [`remove`](#dfx-identity-remove)               | Removes an existing identity.                                                                                             |
| [`rename`](#dfx-identity-rename)               | Renames an existing identity.                                                                                             |
| [`set-wallet`](#dfx-identity-set-wallet)       | Sets the wallet canister identifier to use for your current identity principal.                                           |
| [`use`](#dfx-identity-use)                     | Specifies the identity to use.                                                                                            |
| [`whoami`](#dfx-identity-whoami)               | Displays the name of the current identity user context.                                                                   |

## Creating a default identity

The first time you run the `dfx canister create` command to register an identifier, your public/private key pair credentials are used to create a `default` user identity. The credentials for the `default` user are migrated from `$HOME/.dfinity/identity/creds.pem` to `$HOME/.config/dfx/identity/default/identity.pem`.

You can then use `dfx identity new` to create new user identities and store credentials for those identities in `$HOME/.config/dfx/identity/<identity_name>/identity.pem` files. For example, you can create an identity named `ic_admin` by running the following command:

    dfx identity new ic_admin

This command adds a private key for the `ic_admin` user identity in the `~/.config/dfx/identity/ic_admin/identity.pem` file.

## dfx identity get-principal

Use the `dfx identity get-principal` command to display the textual representation of a principal associated with the current user identity context.

If you haven’t created any user identities, you can use this command to display the principal for the `default` user. The textual representation of a principal can be useful for establishing and testing role-based authorization scenarios.

### Basic usage

``` bash
dfx identity get-principal [flag]
```

### Flags

You can use the following optional flags with the `dfx identity get-principal` command.

| Flag              | Description                   |
|-------------------|-------------------------------|
| `-h`, `--help`    | Displays usage information.   |
| `-V`, `--version` | Displays version information. |

### Example

If you want to display the textual representation of a principal associated with a specific user identity context, you can run commands similar to the following:

``` bash
dfx identity use ic_admin
dfx identity get-principal
```

In this example, the first command sets the user context to use the `ic_admin` identity. The second command then returns the principal associated with the `ic_admin` identity.

## dfx identity get-wallet

Use the `dfx identity get-wallet` command to display the canister identifier for the wallet associated with your current identity principal.

Note that you must be connected to the IC or the local canister execution environment to run this command. In addition, you must be in a project directory to run the command. For example, if your project name is `hello_world`, your current working directory must be the `hello_world` top-level project directory or one of its subdirectories to run the `dfx identity get-wallet` command.

### Basic usage

``` bash
dfx identity get-wallet [flag]
```

### Flags

You can use the following optional flags with the `dfx identity get-wallet` command.

| Flag              | Description                   |
|-------------------|-------------------------------|
| `-h`, `--help`    | Displays usage information.   |
| `-V`, `--version` | Displays version information. |

### Example

If you want to display the canister identifier for the wallet canister associated with your identity, you can run the following command:

``` bash
dfx identity get-wallet
```

To display the canister identifier for the wallet canister associated with your identity on a specific testnet, you might run a command similar to the following:

``` bash
dfx identity get-wallet --network=https://192.168.74.4
```

## dfx identity import

Use the `dfx identity import` command to create a user identity by importing the user’s key information or security certificate from a PEM file.

### Basic usage

``` bash
dfx identity import [options] identity-name pem_file-name
```

### Flags

You can use the following optional flags with the `dfx identity import` command.

| Flag              | Description                   |
|-------------------|-------------------------------|
| `-h`, `--help`    | Displays usage information.   |
| `-V`, `--version` | Displays version information. |

### Options

You can specify the following options for the `dfx identity import` command.

|Argument|Description|
|--------|-----------|
|`--disable-encryption` |DANGEROUS: By default, PEM files are encrypted with a password when writing them to disk. If you want the convenience of not having to type your password (but at the risk of having your PEM file compromised), you can disable the encryption with this flag.|
|`--force` |If the identity already exists, remove and re-import it.|

### Examples

You can use the `dfx identity import` command to import a PEM file that contains the security certificate to use for an identity. For example, you can run the following command to import the `generated-id.pem` file to create the user identity `alice`:

``` bash
dfx identity import alice generated-id.pem
```

The command adds the `generated-id.pem` file to the `~/.config/dfx/identity/alice` directory.

## dfx identity list

Use the `dfx identity list` command to display the list of user identities available. When you run this command, the list displays an asterisk (\*) to indicate the currently active user context. You should note that identities are global. They are not confined to a specific project context. Therefore, you can use any identity listed by the `dfx identity list` command in any project.

### Basic usage

``` bash
dfx identity list [flag]
```

### Flags

You can use the following optional flags with the `dfx identity list` command.

| Flag              | Description                   |
|-------------------|-------------------------------|
| `-h`, `--help`    | Displays usage information.   |
| `-V`, `--version` | Displays version information. |

### Examples

You can use the `dfx identity list` command to list all of the identities you have currently available and to determine which identity is being used as the currently-active user context for running `dfx` commands. For example, you can run the following command to list the identities available:

``` bash
dfx identity list
```

This command displays the list of identities found similar to the following:

``` bash
alice_auth
anonymous
bob_standard *
default
ic_admin
```

In this example, the `bob_standard` identity is the currently-active user context. After you run this command to determine the active user, you know that any additional `dfx` commands you run are executed using the principal associated with the `bob_standard` identity.

## dfx identity new

Use the `dfx identity new` command to add new user identities. You should note that the identities you add are global. They are not confined to a specific project context. Therefore, you can use any identity you add using the `dfx identity new` command in any project.

### Basic usage

``` bash
dfx identity new [options] _identity-name_
```

### Flags

You can use the following optional flags with the `dfx identity new` command.

| Flag              | Description                   |
|-------------------|-------------------------------|
| `-h`, `--help`    | Displays usage information.   |
| `-V`, `--version` | Displays version information. |

### Arguments

You must specify the following argument for the `dfx identity new` command.

| Argument          | Description                                                              |
|-------------------|--------------------------------------------------------------------------|
| `<identity_name>` | Specifies the name of the identity to create. This argument is required. |

### Options

You can specify the following options for the `dfx identity new` command.

|Argument|Description|
|--------|-----------|
|`--disable-encryption` |DANGEROUS: By default, PEM files are encrypted with a password when writing them to disk. If you want the convenience of not having to type your password (but at the risk of having your PEM file compromised), you can disable the encryption with this flag.|
|`--force` |If the identity already exists, remove and re-import it.|
|`--hsm-key-id <hsm key id>` |A sequence of pairs of hex digits.|
|`--hsm-pkcs11-lib-path <hsm pkcs11 lib path>` |The file path to the opensc-pkcs11 library e.g. "/usr/local/lib/opensc-pkcs11.so"|

### Examples

You can then use `dfx identity new` to create new user identities and store credentials for those identities in `$HOME/.config/dfx/identity/<identity_name>/identity.pem` files. For example, you can create an identity named `ic_admin` by running the following command:

    dfx identity new ic_admin

This command adds a private key for the `ic_admin` user identity in the `~/.config/dfx/identity/ic_admin/identity.pem` file.

After adding the private key for the new identity, the command displays confirmation that the identity has been created:

    Creating identity: "ic_admin".
    Created identity: "ic_admin".

## dfx identity remove

Use the `dfx identity remove` command to remove an existing user identity. You should note that the identities you add are global. They are not confined to a specific project context. Therefore, any identity you remove using the `dfx identity remove` command will no longer be available in any project.

### Basic usage

``` bash
dfx identity remove [flag] _identity-name_
```

### Flags

You can use the following optional flags with the `dfx identity remove` command.

| Flag              | Description                   |
|-------------------|-------------------------------|
| `-h`, `--help`    | Displays usage information.   |
| `-V`, `--version` | Displays version information. || `--drop-wallets`  | Required if the identity has wallets configured so that users do not accidentally lose access to wallets.   |

### Arguments

You must specify the following argument for the `dfx identity remove` command.

| Argument          | Description                                                              |
|-------------------|--------------------------------------------------------------------------|
| `<identity_name>` | Specifies the name of the identity to remove. This argument is required. |

### Examples

You can use the `dfx identity remove` command to remove any previously-created identity, including the `default` user identity. For example, if you have added named user identities and want to remove the `default` user identity, you can run the following command:

    dfx identity remove default

The command displays confirmation that the identity has been removed:

    Removing identity "default".
    Removed identity "default".

Although you can delete the `default` identity if you have created other identities to replace it, you must always have at least one identity available. If you attempt to remove the last remaining user context, the `dfx identity remove` command displays an error similar to the following:

    Identity error:
      Cannot delete the default identity

If you have an identity with one or more wallets configured, it will only be deleted if you call it with `--drop-wallets`. This is made so that users don't accidentally lose access to their cycles wallets. If you try to delete an identity with at least one wallet configured, it will display the attached wallets like this:

    This identity is connected to the following wallets:
        identity 'mainnet' on network 'ic' has wallet rwlgt-iiaaa-aaaaa-aaaaa-cai

## dfx identity rename

Use the `dfx identity rename` command to rename an existing user identity. You should note that the identities you add are global. They are not confined to a specific project context. Therefore, any identity you rename using the `dfx identity rename` command is available using the new name in any project.

### Basic usage

``` bash
dfx identity rename [flag] _from_identity-name_ _to_identity-name_
```

### Flags

You can use the following optional flags with the `dfx identity rename` command.

| Flag              | Description                   |
|-------------------|-------------------------------|
| `-h`, `--help`    | Displays usage information.   |
| `-V`, `--version` | Displays version information. |

### Arguments

You must specify the following arguments for the `dfx identity rename` command.

| Argument               | Description                                                                               |
|------------------------|-------------------------------------------------------------------------------------------|
| `<from_identity_name>` | Specifies the current name of the identity you want to rename. This argument is required. |
| `<to_identity_name>`   | Specifies the new name of the identity you want to rename. This argument is required.     |

### Example

You can rename the `default` user or any identity you have previously created using the `dfx identity rename` command. For example, if you want to rename a `test_admin` identity that you previously created, you would specify the current identity name you want to change **from** and the new name you want to change **to** by running a command similar to the following:

    dfx identity rename test_admin devops

## dfx identity set-wallet

Use the `dfx identity set-wallet` command to specify the wallet canister identifier to use for your identity.

### Basic usage

``` bash
dfx identity set-wallet [flag] [--canister-name canister-name]
```

### Flags

You can use the following optional flags with the `dfx identity set-wallet` command.

| Flag              | Description                                                                                                                                                |
|-------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `force`           | Skips verification that the canister you specify is a valid wallet canister. This option is only useful if you are connecting to the IC running locally. |
| `-h`, `--help`    | Displays usage information.                                                                                                                                |
| `-V`, `--version` | Displays version information.                                                                                                                              |

### Example

If you use more than one principal for your identity, you might have access to more than one wallet canister identifier. You can use the `dfx identity set-wallet` command to specify the wallet canister identifier to use for a given identity.

For example, you might store the wallet canister identifier in an environment variable, then invoke the `dfx identity set-wallet` command to use that wallet canister for additional operations by running the following:

    export WALLET_CANISTER_ID=$(dfx identity get-wallet)
    dfx identity set-wallet --canister-name ${WALLET_CANISTER_ID} --network=https://192.168.74.4

## dfx identity use

Use the `dfx identity use` command to specify the user identity you want to active. You should note that the identities you have available to use are global. They are not confined to a specific project context. Therefore, you can use any identity you have previously created in any project.

### Basic usage

``` bash
dfx identity use [flag] _identity-name_
```

### Flags

You can use the following optional flags with the `dfx identity use` command.

| Flag              | Description                   |
|-------------------|-------------------------------|
| `-h`, `--help`    | Displays usage information.   |
| `-V`, `--version` | Displays version information. |

### Arguments

You must specify the following argument for the `dfx identity use` command.

| Argument          | Description                                                                                                    |
|-------------------|----------------------------------------------------------------------------------------------------------------|
| `<identity_name>` | Specifies the name of the identity you want to make active for subsequent commands. This argument is required. |

### Examples

If you want to run multiple commands with the same user identity context, you can run a command similar to the following:

    dfx identity use ops

After running this command, subsequent commands use the credentials and access controls associated with the `ops` user.

## dfx identity whoami

Use the `dfx identity whoami` command to display the name of the currently-active user identity context.

### Basic usage

``` bash
dfx identity whoami [flag]
```

### Flags

You can use the following optional flags with the `dfx identity whoami` command.

| Flag              | Description                   |
|-------------------|-------------------------------|
| `-h`, `--help`    | Displays usage information.   |
| `-V`, `--version` | Displays version information. |

### Example

If you want to display the name of the currently-active user identity, you can run the following command:

``` bash
dfx identity whoami
```

The command displays the name of the user identity. For example, you had previously run the command `dfx identity use bob_standard`, the command would display:

    bob_standard

-->