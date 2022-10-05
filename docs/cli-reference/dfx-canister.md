# dfx canister

`dfx canister` コマンドとフラグおよびサブコマンドを使用して Canister の操作と {platform} またはローカルの Canister 実行環境との対話を管理します。
ほとんどの場合、プログラムをコンパイルした後に `dfx canister` サブコマンドを使用して Canister のライフサイクルを管理し、プログラムの関数を呼び出すなどの重要なタスクを実行します。

`dfx canister` コマンドを実行するための基本的な構文は以下の通りです：

```bash
dfx canister [subcommand] [flag]
```

指定する `dfx canister` サブコマンドによっては、追加の引数、オプション、およびフラグが適用され、または必要になる場合があります。
特定の `dfx canister` サブコマンドの使用情報を表示するにはそのサブコマンドと `--help` フラグを指定します。
例えば `dfx canister call` の利用情報を見るには以下のコマンドを実行します：

```bash
dfx canister call --help
```

`dfx canister` コマンドを使用する際の利用情報および例を参考にして、適切なコマンドを選択してください。

| コマンド                                           | 説明                                                                                                                                                                                                                                                                                                  |
| -------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [`call`](#dfx-canister-call)                       | デプロイされた Canister で指定されたメソッドを呼び出します。                                                                                                                                                                                                                                          |
| [`create`](#dfx-canister-create)                   | {platform} またはローカルの Canister 実行環境に Canister ID を登録することで、新しい「空」の Canister を作成します。                                                                                                                                                                                  |
| [`delete`](#dfx-canister-delete)                   | 現在停止している Canister を削除します。                                                                                                                                                                                                                                                              |
| [`deposit-cycles`](#dfx-canister-deposit-cycles)   | 指定された Canister に Cycle をデポジットします。                                                                                                                                                                                                                                                     |
| `help`                                             | 指定されたサブコマンドの利用情報を表示します。                                                                                                                                                                                                                                                        |
| [`id`](#dfx-canister-id)                           | Canister ID を表示します。                                                                                                                                                                                                                                                                            |
| [`info`](#dfx-canister-info)                       | Canister の WASM モジュールと現在のコントローラのハッシュを認証で取得する。                                                                                                                                                                                                                           |
| [`install`](#dfx-canister-install)                 | コンパイルされたコードを {platform} またはローカルの Canister 実行環境上に Canister としてインストールします。                                                                                                                                                                                        |
| [`request-status`](#dfx-canister-request-status)   | Canister への呼び出しの状況をリクエストします。                                                                                                                                                                                                                                                       |
| [`send`](#dfx-canister-send)                       | 事前に署名された `message.json` を、指定された Canister ID に送信します。例えば、Neuron を管理するために Network Nervous System (NNS) のガバナンス Canister を呼び出すメッセージを送信したい場合、セキュリティ上の理由からメッセージの署名をメッセージから分離したいときに使用します。                |
| [`sign`](#dfx-canister-send)                       | 指定された Canister の ID を呼び出す前に、署名付きの `message.json` ファイルを作成します。例えば、Neuron を管理するために Network Nervous System (NNS) のガバナンス Canister を呼び出すメッセージを送信する場合、セキュリティ上の理由からメッセージの署名をメッセージから分離したいときに使用します。 |
| [`start`](#dfx-canister-start)                     | 停止している Canister をリスタートします。                                                                                                                                                                                                                                                            |
| [`status`](#dfx-canister-status)                   | Canister の動作状況をリクエストします。                                                                                                                                                                                                                                                               |
| [`stop`](#dfx-canister-stop)                       | 現在動作中の Canister を停止します。                                                                                                                                                                                                                                                                  |
| [`uninstall-code`](#dfx-canister-uninstall-code)   | Internet Computer ネットワーク上の Canister をアンインストールし、そのコードとステートを削除します。                                                                                                                                                                                                  |
| [`update-settings`](#dfx-canister-update-settings) | 1 つまたは複数の Canister の設定を更新します (コントローラ・計算量割り当て・メモリ割り当てなど。)。                                                                                                                                                                                                   |

## デフォルトのデプロイ環境をオーバーライドする

デフォルトでは `dfx canister` コマンドは `dfx.json` ファイルで指定されたローカルの Canister 実行環境上で実行されます。
もし `dfx.json` 設定ファイルの設定を変更せずに `dfx canister` サブコマンドを {platform} やテストネットで実行したい場合、 `--network` オプションを用いて接続先 URL を明示的に指定することで可能になります。

例えば、ローカルの Canister 実行環境上でプロジェクトに一意の Canister ID を登録するには、以下のコマンドを実行します：

```bash
dfx canister create --all
```

同一プロジェクトに対して {platform} 上で一意の Canister ID を登録したい場合は、以下のコマンドを実行します：

```bash
dfx canister --network ic create --all
```

SDK には `ic` というエイリアスが付属しており、{platform} を指すように設定されます。また、ネットワークオプションとして URL を渡すこともできますし、`dfx.json` の `networks` 設定で、追加のエイリアスを設定することも可能です。

例として、以下のようなコマンドを使用して、テストネット上で動作している Canister と関数を呼び出すことができます。

```bash
dfx canister --network \http://192.168.3.1:5678 call counter get
```

Canister の操作（`create` または `call`）や、Canister 名（`counter`）や関数 （`get`）などの追加の引数の前に `--network` パラメータを指定しなければならないことに注意してください。

## dfx canister call

デプロイされた Canister で指定されたメソッドを呼び出すには、 `dfx canister call` コマンドを使用します。

### 基本的な利用法

```bash
dfx canister call [option] canister_name _method_name_ [argument] [flag]
```

### フラグ

`dfx canister call` コマンドでは、以下のオプションフラグを使用することができます。

| フラグ         | 説明                                                                                                                         |
| -------------- | ---------------------------------------------------------------------------------------------------------------------------- |
| `--async`      | ローカル Canister 実行環境、または {platform} をポーリングして、呼び出しの結果が返されるのを待たずに続行できるようにします。 |
| `-h`, `--help` | 利用情報を表示します。                                                                                                       |
| `--query`      | デプロイされた Canister にクエリ・リクエストを送信できるようにします。                                                       |

明示的にクエリ・メソッドを使用して効率よく情報を取得する場合に、このフラグを使用する必要があります。
クエリコールとアップデートコールの違いについては [Canister はプログラムとステートを包含する](../../concepts/canisters-code#canister-state) を参照してください。|
|`--update` |デプロイされた Canister にアップデートリクエストを送信できるようにします。
デフォルトでは Canister の呼び出しは アップデートメソッドが使用されます。|
|`-V`, `--version` |バージョン情報を表示します。|

### オプション

`dfx canister call` コマンドでは、以下のオプションを使用することができます。

| オプション          | 説明                                                                                           |
| ------------------- | ---------------------------------------------------------------------------------------------- |
| `--output <output>` | メソッドの戻り値を表示する際に使用する出力形式を指定します。有効な値は `idl` と `raw` です。   |
| `--type <type>`     | 引数を用いて呼び出しを行う場合の引数のデータ形式を指定します。有効な値は `idl` と `raw` です。 |

### 引数

`dfx canister call` コマンドでは、以下の引数を指定することができます。

| 引数            | 説明                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
| --------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `canister_name` | 呼び出す Canister の名前を指定します。Canister 名は必須の引数で `dfx.json` 設定ファイルの `canisters` セクションでプロジェクトに設定した名前と一致する必要があります。                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
| `method_name`   | Canister 内の呼び出すメソッド名を指定します。Canister メソッドは必須引数です。                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
| `argument`      | メソッドに渡す引数を指定します。プログラム・ロジックに応じて、引数は必須引数、またはオプション引数にすることができます。Canister に引数を渡す場合は `--type` オプションを使用してデータフォーマットのタイプを指定することができます。デフォルトでは、データ値に [Candid](../../developer-docs/build/candid/candid-intro.md) (`idl`) 構文を使用して引数を指定します。Candid の使い方やサポートされている型については[Interact with a service in a terminal](../../developer-docs/build/candid/candid-howto.md#idl-syntax) と[Supported types](../candid-ref.md) をご覧ください。Canister に生のバイトを渡したい場合は、引数の型として `raw` を使用することができます。 |

### 例

`dfx canister call` コマンドを使用すると `dfx canister install` コマンドを使用して Canister をデプロイした後に、引数付き、または引数なしで特定のメソッドを起動することができます。
例えば、`canister_name` が `counter` である Canister に対して `get` メソッドを呼び出すには、以下のコマンドを実行してください。

```bash
dfx canister call counter get --async
```

この例では、コマンドに `--async` オプションが含まれており、ローカルの Canister 実行環境や {platform} をポーリングして結果を待つのではなく、個別に `request-status` を呼び出したいことを表しています。
`--async` オプションはオペレーションを完了するまでに時間がかかる場合に便利です。
このオプションにより、他の操作を続けてながら別の `dfx canister request-status` コマンドを使用して結果を確認することができます。
返された結果は IDL のテキストフォーマットで表示されます。

#### IDL 構文を使用する

Text データ型に対して以下のようなコマンドを実行することで、IDL 構文で引数を渡すことを明示的に指定することができます：

```bash
dfx canister call hello greet --type idl '("Lisa")'
("Hello, Lisa!")

dfx canister call hello greet '("Lisa")' --type idl
("Hello, Lisa!")
```

また、以下のようなコマンドを実行することで IDL を暗黙的に利用することができます：

```bash
dfx canister call hello greet '("Lisa")'
("Hello, Lisa!")
```

IDL 構文で複数の引数を指定する場合は、引数の間にカンマ(,)を使用します。

例：

```bash
dfx canister call contacts insert '("Amy Lu","01 916-335-2042")'

dfx canister call hotel guestroom '("Deluxe Suite",42,true)'
```

以下のようなコマンドを実行することで、バイト単位の生データを渡すことができます：

```bash
dfx canister call hello greet --type raw '4449444c00017103e29883'
```

この例では、raw データ型を使って、`hello` Canister の `greet` 関数に 16 進数を渡しています。

## dfx canister create

コンパイルされたコードなしにひとつ、または複数の Canister ID を登録するには、`dfx canister create` コマンドを使用します。
このコマンドを実行するには、ローカルの Canister 実行環境、または {platform} に接続されている必要があります。

このコマンドはプロジェクトのディレクトリ構造内からのみ実行できることに注意してください。
例えば、プロジェクト名が `hello_world` の場合、現在の作業ディレクトリは `hello_world` のトップレベルのプロジェクトディレクトリかそのサブディレクトリのいずれかである必要があります。

(Canister) ID を登録するため、初めて `dfx canister create` コマンドを実行すると、公開鍵と秘密鍵のペアの認証情報が `default` ユーザー（開発者） Identity に作成されます。
`default` ユーザー（開発者）の認証情報は `$HOME/.dfinity/identity/creds.pem` から `$HOME/.config/dfx/identity/default/identity.pem` へ移行されます。

### 基本的な利用法

```bash
dfx canister create [option] [flag] [--all | canister_name]
```

### フラグ

`dfx canister create` コマンドでは、以下のオプションフラグを使用することができます。

| フラグ            | 説明                         |
| ----------------- | ---------------------------- |
| `-h`, `--help`    | 利用情報を表示します。       |
| `-V`, `--version` | バージョン情報を表示します。 |

### オプション

`dfx canister create` コマンドでは、以下のオプションを使用することができます。

| オプション                         | 説明                                                                         |
| ---------------------------------- | ---------------------------------------------------------------------------- |
| `--with-cycles <number-of-cycles>` | Canister を作成する際の初期 Cycle 数をウォレットで指定できるようになります。 |

### 引数

`dfx canister create` コマンドでは、以下の引数を使用することができます。

| 引数            | 説明                                                                                                                                                                                                                                                |
| --------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `--all`         | 複数の Canister を定義した `dfx.json` ファイルがプロジェクトにある場合、複数の Canister ID を一度に作成できるようにします。`--all` または、個々の Canister 名を指定する必要があることに注意してください。                                           |
| `canister_name` | (Canister) ID を登録する Canister の名前を指定します。`--all` オプションを使用しない場合、Canister 名は必須の引数であり、プロジェクトの `dfx.json` 設定ファイルの `canisters` セクションで設定した名前と少なくとも 1 つは一致しなければなりません。 |

### 例

`dfx canister create` コマンドを使用すると、最初にコードをコンパイルすることなく、Canister ID を登録することができます。
例えば、プログラムを書く前にプロジェクト `my_counter` の Canister ID を作成したい場合、以下のコマンドを実行します：

```bash
dfx canister create my_counter
```

`dfx canister create` コマンドに `--with-cycles` オプションを付けて使用すると、プロジェクト内の 1 つまたはすべての Canister の作成時に初期残高を指定することができます。例えば、すべての Canister の初期残高を 8000000000000 Cycle に指定するには、次のコマンドを実行します。

```bash
dfx canister create --with-cycles 8000000000000 --all
```

## dfx canister delete

停止した Canister をローカルの Canister 実行環境または {platform} から削除するには、`dfx canister delete` コマンドを使用します。

このコマンドはプロジェクトのディレクトリ構造内からのみ実行できることに注意してください。
例えば、プロジェクト名が `hello_world` の場合、現在の作業ディレクトリは `hello_world` のトップレベルのプロジェクトディレクトリかそのサブディレクトリのいずれかである必要があります。

### 基本的な利用法

```bash
dfx canister delete [flag] [--all | canister_name]
```

### フラグ

`dfx canister delete` コマンドでは、以下のオプションフラグを使用することができます。

| フラグ            | 説明                         |
| ----------------- | ---------------------------- |
| `-h`, `--help`    | 利用情報を表示します。       |
| `-V`, `--version` | バージョン情報を表示します。 |

### 引数

`dfx canister delete` コマンドでは、以下の引数を使用することができます。

| 引数            | 説明                                                                                                                                              |
| --------------- | ------------------------------------------------------------------------------------------------------------------------------------------------- |
| `--all`         | `dfx.json` ファイルに設定されているすべての Canister を削除します。`--all` または、個々の Canister 名を指定する必要があることに注意してください。 |
| `canister_name` | 削除する Canister の名前を指定します。Canister 名、または `--all` オプションのいずれかを指定する必要があることに注意してください。                |

### 例

`dfx canister delete` コマンドを使うと、特定の Canister またはすべての Canister を削除することができます。

`hello_world` の Canister を削除するには、以下のコマンドを実行します：

```bash
dfx canister delete hello_world
```

`IC` {platform} にデプロイしたすべての Canister を削除するには、次のコマンドを実行します：

```bash
dfx canister --network=ic delete --all
```

## dfx canister deposit-cycles

Use the `dfx canister deposit-cycles` command to deposit cycles from your configured wallet into a canister.

Note that you must have your cycles wallet configured for this to work.

### Basic usage

```bash
dfx canister deposit-cycles [amount of cycles] [--all | canister_name]
```

### Flags

You can use the following optional flags with the `dfx canister deposit-cycles` command.

| Flag              | Description                   |
| ----------------- | ----------------------------- |
| `-h`, `--help`    | Displays usage information.   |
| `-V`, `--version` | Displays version information. |

### Arguments

You can use the following arguments with the `dfx canister deposit-cycles` command.

| Argument        | Description                                                                                                                                             |
| --------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `--all`         | Deposits the specified amount of cycles into all canisters configured in `dfx.json`. Note that you must specify `--all` or an individual canister name. |
| `canister_name` | Specifies the name of the canister you want to deposit cycles into. Note that you must specify either a canister name or the `--all` option.            |

### Examples

You can use the `dfx canister deposit-cycles` command to add cycles to a specific canister or all canisters.

To add 1T cycles to the canister called `hello`, you can run the following command:

```bash
dfx canister deposit-cycles 1000000000000 hello
```

To add 2T cycles to each individual canister specified in `dfx.json`, you can run the following command:

```bash
dfx canister deposit-cycles 2000000000000 --all
```

## dfx canister id

特定の Canister 名の Canister ID を出力するには、`dfx canister id` コマンドを使用します。

このコマンドはプロジェクトのディレクトリ構造内からのみ実行できることに注意してください。
例えば、プロジェクト名が `hello_world` の場合、現在の作業ディレクトリは `hello_world` のトップレベルのプロジェクトディレクトリかそのサブディレクトリのいずれかである必要があります。

### 基本的な利用法

```bash
dfx canister id [flag] canister_name
```

### フラグ

`dfx canister id` コマンドでは、以下のオプションフラグを使用することができます。

| フラグ            | 説明                         |
| ----------------- | ---------------------------- |
| `-h`, `--help`    | 利用情報を表示します。       |
| `-V`, `--version` | バージョン情報を表示します。 |

### 引数

`dfx canister id` コマンドでは、以下の引数を使用することができます。

| 引数            | 説明                                                   |
| --------------- | ------------------------------------------------------ |
| `canister_name` | (Canister) ID を表示する Canister の名前を指定します。 |

### 例

特定の Canister 名の Canister ID を表示するには、`dfx canister id` コマンドを使用することができます。

`hello_world` Canister の Canister ID を表示するには、次のコマンドを実行します。

```bash
dfx canister id hello_world
```

このコマンドは次のような出力を表示します：

```bash
75hes-oqbaa-aaaaa-aaaaa-aaaaa-aaaaa-aaaaa-q
```

## dfx canister install

コンパイルされたコードを {platform} またはローカルの Canister 実行環境にインストールするには `dfx canister install` コマンドを使用します。

### 基本的な利用法

```bash
dfx canister install [flag] [option] [--all | canister_name]
```

### フラグ

`dfx canister install` コマンドでは、以下のオプションフラグを使用することができます。

| フラグ            | 説明                                                                                                                            |
| ----------------- | ------------------------------------------------------------------------------------------------------------------------------- |
| `--async`         | {platform} またはローカルの Canister 実行環境をポーリングして、インストールの結果が返されるのを待たずに続行できるようにします。 |
| `-h`, `--help`    | 利用情報を表示します。                                                                                                          |
| `-V`, `--version` | バージョン情報を表示します。                                                                                                    |

### オプション

`dfx canister install` コマンドでは、以下のオプションを使用することができます。

| オプション                                        | 説明                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
| ------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `--argument <argument>`                           | インストール時に Canister に渡す引数を指定します。                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
| `--argument-type <argument-type>`                 | `--argument` オプションを使用してインストールする際に、引数のデータフォーマットを指定します。有効な値は `idl` と `raw` です。デフォルトでは、データ値に [Candid](../../developer-docs/build/candid/candid-intro.md) (`idl`) 構文を使用して引数を指定します。Candid の使い方やサポートされている型については、[Interact with a service in a terminal](../../developer-docs/build/candid/candid-howto.md) と[Supported types](../candid-ref.md) を見てみてください。Canister に生バイナリデータを渡したい場合は、引数の型として `raw` を使用することができます。 |
| `-c`, `--compute-allocation <compute-allocation>` | Canister 実行のための計算割り当て（実質的に CPU 割り当ての設定に相当）を定義します。この値は 0 ～ 100 の範囲でパーセンテージとして設定できます。                                                                                                                                                                                                                                                                                                                                                                                                                                        |
| `--memory-allocation <memory-allocation>`         | Canister で使用できる総メモリ数を指定します。この値は 0 ～ 8 MB の範囲で設定できます。                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
| `-m`, `--mode <mode>`                             | Canister を `install`, `reinstall`, または `upgrade` のいずれでインストールするかを指定します。インストールモードと Canister 管理の詳細については、[Canister を管理する](../../developer-docs/build/project-setup/manage-canisters) を参照してください。                                                                                                                                                                                                                                                                                                                                |

### 引数

`dfx canister install` コマンドでは、以下の引数を使用することができます。

| 引数                                                                                                   | 説明                                                                                                                                                                                                         |
| ------------------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `--all`                                                                                                | プロジェクトの `dfx.json` ファイルに複数の Canister が含まれている場合、複数の Canister を一度にインストールできるようにします。`--all` または個々の Canister 名を指定する必要があることに注意してください。 |
| `canister_name`                                                                                        | デプロイする Canister の名前を指定します。                                                                                                                                                                   |
| `dfx.json` 設定ファイルの `canisters` セクションでプロジェクトに設定した名前と一致する必要があります。 |

### 例

`dfx canister install` コマンドを使用すると、`dfx build` コマンドでコンパイルした WebAssembly を {platform} またはローカルの Canister 実行環境上にデプロイすることができます。
最も一般的な使用方法は、以下のコマンドを実行してすべての Canister をインストールすることです：

```bash
dfx canister install --all
```

#### 特定の Canister をインストールする

また、`dfx canister install` コマンドを使用すると、プロジェクト内のすべての Canister ではなく、特定の Canister をデプロイすることができます。
例えば、`hello_world` Canister と `hello_world_assets` Canister を持つプロジェクトで、 `hello_world` Canister だけをデプロイしたい場合、以下のコマンドを実行してその Canister だけをデプロイすることが可能です：

```bash
dfx canister install hello_world
```

#### 非同期リクエストを送信する

Canister のインストールのリクエストを行い、そのリクエストの識別子を返すことで、コマンドの完了を待つのではなく後でリクエストの状況を確認したい場合には、次のようなコマンドを実行します：

```bash
dfx canister install hello_world --async
```

このコマンドは Canister をインストールするリクエストを送信し、次のようなリクエスト識別子を返します：

```bash
0x58d08e785445dcab4ff090463b9e8b12565a67bf436251d13e308b32b5058608
```

リクエスト識別子を使用して、後でリクエストのステータスを確認することができます。これは荷物を発送するときの追跡番号のようなものです。

#### デフォルトのデプロイオプションを上書きする

もし、`dfx.json` 設定ファイルの設定を変更せずに、テストネット上に Canister をデプロイしたい場合は、`--network` オプションを使って接続するテストネットを明示的に指定することができます。

例えば、以下のようなコマンドを実行することで、テストネットの URL を指定することができます：

```bash
dfx canister --network \http://192.168.3.1:5678 install --all
```

ネットワークのパラメータは Canister オペレーション (`install`) の前に、かつ Canister 名または `--all` フラグの前に指定する必要があることに注意してください。

#### メッセージ処理のアロケーション

`compute-allocation` オプションでは、0 から 100 の範囲で計算資源をパーセンテージで割り当て、Canister の実行をどの程度の頻度でスケジュールするかを指定できます。

例えば、以下のようなコマンドを実行したとします：

```bash
dfx canister install --all --compute-allocation 50
```

この設定では、現在のプロジェクト内のすべての Canister に 50% の割り当てが行われます。プロジェクト内の Canister が処理する入力メッセージを受信すると、そのメッセージは実行のためにスケジュールされます。
100 回の実行サイクルの間に、各 Canister のメッセージは少なくとも 50 回処理されるようスケジュールされます。

このオプションの既定値は 0 で、特定の割り当てやスケジューリングが有効でないことを示します。
すべての Canister が既定の設定を使用する場合、処理はラウンドロビン方式で行われます。

## dfx canister request-status

`dfx canister request-status` コマンドでは、Canister への指定された呼び出しのステータスをリクエストすることができます。
このコマンドでは Canister のメソッドを呼び出した後に受け取ったリクエストの識別子を指定する必要があります。
リクエストの識別子は `0x` で始まる 16 進数の文字列です。

### 基本的な利用法

```bash
dfx canister request-status request_id
```

### フラグ

`dfx canister request-status` コマンドでは、以下のオプションフラグを 使用することができます。

| フラグ            | 説明                         |
| ----------------- | ---------------------------- |
| `-h`, `--help`    | 利用情報を表示します。       |
| `-V`, `--version` | バージョン情報を表示します。 |

### 引数

`dfx canister request-status` コマンドには、以下の引数を指定できます。

| 引数         | 説明                                                                                                                                                             |
| ------------ | ---------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `request_id` | `dfx canister call` または `dfx canister install` コマンドのレスポンスとして返される 16 進数の文字列を指定します。この識別子は 0x で始まる 16 進数の文字列です。 |

### 例

`dfx canister request-status` コマンドを使用して、Canister のステータス変更の状況を確認したり、次のようなコマンドを実行して、呼び出しが拒否されなかったことを確認することができます：

```bash
dfx canister request-status 0x58d08e785445dcab4ff090463b9e8b12565a67bf436251d13e308b32b5058608
```

このコマンドはリクエスト識別子が無効であるか、Canister によって拒否された場合、エラーメッセージを表示します。

## dfx canister set-controller

`dfx canister set-controller` コマンドでは、{platform} 上の指定された Canister の新しい **コントローラー** として Identity 名 または Principal を指定することができます。
コントローラーは制御対象の Canister を管理する特別な権限を持ちます。
例えば、コントローラー（の Identity ）だけがその制御下にある Canister のインストール、アップグレード、または削除をすることができます。

コントローラーとして、ユーザー（開発者）Identity または Canister のいずれかを指定できることに注意してください。
また、コントローラーは（ Identity の）名前、または Principal を使用して指定することもできます。

### 基本的な利用法

```bash
dfx canister set-controller [flag] canister new-controller
```

### フラグ

`dfx canister set-controller` コマンドでは、以下のオプションフラグを 使用することができます。

| フラグ            | 説明                         |
| ----------------- | ---------------------------- |
| `-h`, `--help`    | 利用情報を表示します。       |
| `-V`, `--version` | バージョン情報を表示します。 |

### 引数

`dfx canister set-controller` コマンドでは、以下の引数を使用する必要があります。

| 引数               | 説明                                                                                                                       |
| ------------------ | -------------------------------------------------------------------------------------------------------------------------- |
| `<canister>`       | _new_controller_ 引数で指定したコントローラー（の ID ）が制御する対象である Canister 名、または Canister ID を指定します。 |
| `<new_controller>` | （新規）コントローラーの Identity 名または Principal を指定します。                                                        |

### 例

`dfx canister set-controller` コマンドを使用すると、特定の Canister を制御する コントローラーとして、（ユーザー）identity、または Canister を指定することができます。

例えば、`dfx canister set-controller` を実行して新しい Identity `pubsadmin` を作成し `hello_world` Canister のコントローラーとして指定するには、以下のコマンドを実行するとよいでしょう。

        dfx identity new pubsadmin
        dfx canister set-controller hello_world pubsadmin

Principal ID のテキスト表現を使用してコントローラーを設定するには、次のようなコマンドを実行します。

        dfx canister set-controller hello_world wcp5u-pietp-k5jz4-sdaaz-g3x4l-zjzxa-lxnly-fp2mk-j3j77-25qat-pqe

Identity 名や Principal を指定するのも 1 つの使用例ですが、より一般的なシナリオは Cycle を送信するために使用するウォレット Canister を指定することです。
次の手順はローカル開発をしている場合のこのシナリオを説明するものです。この例では、 `open_sf` というプロジェクトを作成し、2 つの Canister をローカルの Canister 実行環境上にデプロイしたと仮定します。

1.  コントローラーとして動作するように `sf-controller` という名前の Identity を作成します。

        dfx identity new sf-controller

        Creating identity: "sf-controller".
        Created identity: "sf-controller".

2.  新しい Identity をアクティブ Identity にします。

        dfx identity use sf-controller

        Using identity: "sf-controller".

3.  新しい Identity のウォレット Canister ID を生成します。

        dfx identity get-wallet

        Creating a wallet canister on the local canister execution environment.
        r7inp-6aaaa-aaaaa-aaabq-cai
        The wallet canister on the  the local canister execution environment for user "sf-controller" is "r7inp-6aaaa-aaaaa-aaabq-cai"

4.  アクティブ Identity を Canister の現在のコントローラーに切り替えます。例えば、Canister の作成に default の Identity が使用された場合、以下のコマンドを実行します。

        dfx identity use default

        Using identity: "default".

5.  指定された Canister のコントローラーにウォレットを使用するようにした sf-controller Identity に設定します。

        dfx canister set-controller open_sf_assets r7inp-6aaaa-aaaaa-aaabq-cai

        Set "r7inp-6aaaa-aaaaa-aaabq-cai" as controller of "open_sf_assets".

    これで、ウォレット Canister `r7inp-6aaaa-aaabq-cai` を使って Cycle を送ったり、`open_sf_assets` Canister にカストディアンを追加することができるようになります。

## dfx canister send

`dfx canister call` コマンドを使うのではなく、 `dfx canister sign` コマンドでメッセージに署名をした後に `dfx canister send` コマンドを使うことで、これらのステップを分離させることができます。別々の呼び出しを使うことで、トランザクションにセキュリティを加えることが可能です。

例えば、Neuron のステーキングを作成するときに `dfx canister sign` コマンドを使用して、エアギャップされたコンピュータを使用して署名済みの `message.json` ファイルを作成し、次に `dfx canister send` コマンドを使用して署名済みのメッセージを配信することができます。

### 基本的な利用法

```bash
dfx canister send file_name
```

### フラグ

`dfx canister request-status` コマンドでは、以下のオプションフラグを使用することができます。

| フラグ            | 説明                         |
| ----------------- | ---------------------------- |
| `-h`, `--help`    | 利用情報を表示します。       |
| `-V`, `--version` | バージョン情報を表示します。 |

### 引数

`dfx canister send` コマンドには、以下の引数を指定することができます。

| 引数        | 説明                                 |
| ----------- | ------------------------------------ | --- |
| `file_name` | メッセージのファイル名を指定します。 | 　  |

### 例

`dfx canister send` コマンドを使用して作成した署名付きメッセージを genesis token canister (GTC) に送信し、以下のコマンドを実行することであなたに代わって Neuron を作成します：

`dfx canister send message.json`

## dfx canister sign

`dfx canister call` コマンドを一度に使うのではなく、 `dfx canister send` コマンドでメッセージを送信する前に `dfx canister sign` コマンドを使うことで、これらのステップを分離することができます。別々の呼び出しを使うことで、トランザクションにセキュリティを加えることが可能です。
例えば、Neuron ステーキングを作成する際に `dfx canister sign` コマンドを使用して、エアギャップされたコンピュータを使用して署名された `message.json` ファイルを作成し、`dfx canister send` コマンドを使用して {platform} に接続されているコンピュータから署名されたメッセージを配信することが考えられます。

### 基本的な利用法

```bash
dfx canister sign [flag] [option] _canister-name_ _method-name_ [argument]
```

### フラグ

`dfx canister sign` コマンドでは、以下のオプションフラグを使用することができます。

| フラグ            | 説明                                                                                                                     |
| ----------------- | ------------------------------------------------------------------------------------------------------------------------ |
| `-h`, `--help`    | 利用情報を表示します。                                                                                                   |
| `--query`         | Canister にクエリ・リクエストを送信します。                                                                              |
| `--update`        | Canister にアップデート・リクエストを送信します。これは `--query` メソッドが使用されない場合のデフォルト・メソッドです。 |
| `-V`, `--version` | バージョン情報を表示します。                                                                                             |

### オプション

`dfx canister sign` コマンドには、以下のオプションを指定することができます。

| Option                     | Description                                                                                                                 |
| -------------------------- | --------------------------------------------------------------------------------------------------------------------------- |
| `--expire-after <seconds>` | 有効期限が切れて送信できなくなるまでの時間を指定します。秒単位で指定します。未定義の場合、デフォルトは 300 秒（5 分）です。 |
| `--file <output>`          | 出力ファイル名を指定します。デフォルトは `message.json` です。                                                              |
| `--random <random>`        | ランダムな引数を生成するための設定を指定します。                                                                            |
| `--type <type>`            | S 引数を用いた呼び出しを行う際に、引数のデータ型を指定します。 `idl` と `raw` を指定可能です。                              |

### 引数

`dfx canister sign` コマンドには、以下の引数を指定することができます。

| 引数            | 説明                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
| --------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `canister_name` | 呼び出す Canister の名前を指定します。Canister 名は必須の引数で `dfx.json` 設定ファイルの `canisters` セクションでプロジェクトに対して設定した名前と一致する必要があります。                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
| `method_name`   | Canister で呼び出すメソッド名を指定します。Canister のメソッドは必須引数です。                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
| `argument`      | メソッドに渡す引数を指定します。プログラム・ロジックに応じて、引数は必須引数またはオプション引数にすることができます。Canister に引数を渡す場合は `--type` オプションを使用してデータフォーマットのタイプを指定することができます。デフォルトでは、データ値に [Candid](../../developer-docs/build/candid/candid-intro.md) (`idl`) 構文を使って引数を指定することができます。Candid の使い方やサポートされている型については [Interact with a service in a terminal](../../developer-docs/build/candid/candid-howto.md#idl-syntax) と[Supported types](../candid-ref.md) を見てみてください。生バイナリ（データ）を渡したい場合は、引数の型として `raw` を指定することができます。 |

### 例

`dfx canister sign` コマンドを使用して、以下のようなコマンドを Privacy Enhanced Mail (PEM) ファイルを使用して作成した Identity に関連付けられた Principal を使用して実行し、署名付き `message.json` ファイルを作成します：

`dfx canister --network=ic sign --expire-after=1h rno2w-sqaaa-aaaaa-aaacq-cai create_neurons ‘(“PUBLIC_KEY”)’`

このコマンドでは、署名された `message.json` ファイルを作成する方法を説明します。
このコマンドは `message.json` ファイルを作成して、`ic` エイリアスで指定した {platform} 上に Neuron を作成する方法を示しています。このファイルはメッセージの送信者としてあなたの Principal ID を使い、1 時間で終了する有効期限を設定して署名されています。

署名されたメッセージの送信に割り当てられる時間は 5 分という固定されたウィンドウであることに注意してください。`expire-after` オプションは署名されたメッセージを送るための 5 分のウィンドウを終了させる時点を指定することができます。例えば、`--expire-after` オプションを 1 時間（`1h`）に設定すると、生成されたメ ッセージを送る前に少なくとも 55 分待たなければならず、メッセージの署名は 60 分で終わる 5 分間のウィンドウの間だけ有効になります。

したがって、この例では、55 分後にメッセージを送信し、60 分前にメッセージを送信しないと、メッセージが有効であると認識されません。

もし、`--expire-after` オプションを指定しなければ、デフォルトの有効期限は 5 分です。

以下のコマンドを実行して、署名されたメッセージを genesis token canister (GTC) に送信し、あなたの代わりに Neuron を作成します：

`dfx canister send message.json`

## dfx canister start

`dfx canister start` コマンドを使用すると、{platform} または、ローカルの Canister 実行環境上で停止している Canister を再起動できます。

ほとんどの場合、Canister のアップグレードの前提条件に保留中のリクエストを適切に中断するために Canister を停止した後、このコマンドを実行します。

このコマンドは、プロジェクトのディレクトリ構造内からのみ実行できることに注意してください。
例えば、プロジェクト名が `hello_world` の場合、現在の作業ディレクトリは `hello_world` トップレベルのプロジェクトディレクトリか、そのサブディレクトリのいずれかである必要があります。

### 基本的な利用法

```bash
dfx canister start [flag] [--all | canister_name]
```

### フラグ

`dfx canister start` コマンドでは、以下のオプションフラグを使用することができます。

| フラグ            | 説明                         |
| ----------------- | ---------------------------- |
| `-h`, `--help`    | 利用情報を表示します。       |
| `-V`, `--version` | バージョン情報を表示します。 |

### 引数

`dfx canister start` コマンドでは、以下の引数を使用することができます。

| 引数            | 説明                                                                                                                                              |
| --------------- | ------------------------------------------------------------------------------------------------------------------------------------------------- |
| `--all`         | `dfx.json` ファイルで設定されているすべての Canister を起動します。`--all` または、個々の Canister 名を指定する必要があることに注意してください。 |
| `canister_name` | 起動する canister の名前を指定します。Canister 名、または `--all` オプションのいずれかを指定する必要があることに注意してください。                |

### 例

`dfx canister start` コマンドを使用すると、特定の Canister またはすべての Canister を起動することができます。

`hello_world` Canister を起動するためには、以下のコマンドを実行します。

```bash
dfx canister start hello_world
```

{platform} 上にデプロイした全ての Canister を起動するには、以下のコマンドを実行します。

```bash
dfx canister --network=ic start --all
```

## dfx canister status

`dfx canister status` コマンドでは、{platform} またはローカルの Canister 実行環境において Canister が現在実行中か、停止中か、または現在停止しているかを確認できます。

このコマンドは、プロジェクト・ディレクトリ構造内からのみ実行できることに注意してください。
例えば、プロジェクト名が `hello_world` の場合、現在の作業ディレクトリは `hello_world` のトップレベルのプロジェクトディレクトリかそのサブディレクトリのいずれかである必要があります。

### 基本的な利用法

```bash
dfx canister status [flag] [--all | canister_name]
```

### フラグ

`dfx canister status` コマンドでは、以下のオプションフラグを使用することができます。

| フラグ            | 説明                         |
| ----------------- | ---------------------------- |
| `-h`, `--help`    | 利用情報を表示します。       |
| `-V`, `--version` | バージョン情報を表示します。 |

### 引数

`dfx canister status` コマンドでは、以下の引数を使用できます。

| 引数            | 説明                                                                                                                                                          |
| --------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `--all`         | `dfx.json` ファイルに設定されているすべての Canister のステータス情報を返します。`--all` または個々の Canister 名を指定する必要があることに注意してください。 |
| `canister_name` | データを返したい Canister の名前を指定します。Canister 名、または `--all` オプションのいずれかを指定する必要があることに注意してください。                    |

### 例

`dfx canister status` コマンドを使用することで、特定の Canister または全ての Canister のステータスを確認することができます。

`hello_world` Canister のステータスを確認するには、以下のコマンドを実行します。

```bash
dfx canister status hello_world
```

{platform} にデプロイしたすべての Canister のステータスを確認するには、次のコマンドを実行します。

```bash
dfx canister --network=ic status --all
```

## dfx canister stop

`dfx canister stop` コマンドでは、{platform} またはローカルの Canister 実行環境上で現在実行中の Canister を停止できます。

ほとんどの場合、Canister をアップグレードする前提条件に、保留中のリクエストを適切に中断させるためにこのコマンドを実行します。

このコマンドは、プロジェクト・ディレクトリ構造内からのみ実行できることに注意してください。
例えば、プロジェクト名が `hello_world` の場合、現在の作業ディレクトリは `hello_world` トップレベルのプロジェクトディレクトリか、そのサブディレクトリのいずれかである必要があります。

### 基本的な利用法

```bash
dfx canister stop [flag] [--all | canister_name]
```

### フラグ

`dfx canister stop` コマンドでは、以下のオプションフラグを使用することができます。

| フラグ            | 説明                         |
| ----------------- | ---------------------------- |
| `-h`, `--help`    | 利用情報を表示します。       |
| `-V`, `--version` | バージョン情報を表示します。 |

### 引数

`dfx canister stop` コマンドでは、以下の引数を使用することができます。

| 引数            | 説明                                                                                                                                              |
| --------------- | ------------------------------------------------------------------------------------------------------------------------------------------------- |
| `--all`         | `dfx.json` ファイルで設定されているすべての Canister を停止します。`--all` または、個々の Canister 名を指定する必要があることに注意してください。 |
| `canister_name` | 停止したい Canister の名前を指定します。Canister 名または `--all` オプションのいずれかを指定する必要があることに注意してください。                |

### 例

`dfx canister stop` コマンドを使用することで、特定の Canister またはすべての Canister を停止することができます。

`hello_world` Canister を停止させるには、以下のコマンドを実行します：

```bash
dfx canister stop hello_world
```

{platform} にデプロイしたすべての Canister を停止するには、次のコマンドを実行します：

```bash
dfx canister --network=ic stop --all
```

<!--
# dfx canister

Use the `dfx canister` command with flags and subcommands to manage canister operations and interaction with the {platform} or the local canister execution environment. In most cases, you use `dfx canister` subcommands after you compile a program to manage the canister lifecycle and to perform key tasks such as calling program functions.

The basic syntax for running `dfx canister` commands is:

``` bash
dfx canister <subcommand> [flags]
```

Depending on the `dfx canister` subcommand you specify, additional arguments, options, and flags might apply or be required. To view usage information for a specific `dfx canister` subcommand, specify the subcommand and the `--help` flag. For example, to see usage information for `dfx canister call`, you can run the following command:

``` bash
dfx canister call --help
```

For reference information and examples that illustrate using `dfx canister` commands, select an appropriate command.

| Command                                            | Description                                       |
|----------------------------------------------------|---------------------------------------------------|
| [`call`](#dfx-canister-call)                       | Calls a specified method on a deployed canister.  |
| [`create`](#dfx-canister-create)                   | Creates an empty canister and associates the assigned Canister ID to the canister name.  |
| [`delete`](#dfx-canister-delete)                   | Deletes a currently stopped canister.  |
| [`deposit-cycles`](#dfx-canister-deposit-cycles)   | Deposit cycles into the specified canister.  |
| `help`                                             | Displays usage information message for a specified subcommand.  |
| [`id`](#dfx-canister-id)                           | Displays the identifier of a canister.  |
| [`info`](#dfx-canister-info)                       | Get the hash of a canister’s WASM module and its current controller.  |
| [`install`](#dfx-canister-install)                 | Installs compiled code in a canister.  |
| [`metadata`](#dfx-canister-metadata)               | Displays metadata in a canister.                  |
| [`request-status`](#dfx-canister-request-status)   | Requests the status of a call to a canister.  |
| [`send`](#dfx-canister-send)                       | Send a previously-signed message.  |
| [`sign`](#dfx-canister-send)                       | Sign a canister call and generate message file.  |
| [`start`](#dfx-canister-start)                     | Starts a stopped canister.  |
| [`status`](#dfx-canister-status)                   | Returns the current status of a canister as defined [here](https://internetcomputer.org/docs/current/references/ic-interface-spec#ic-canister_status).  |
| [`stop`](#dfx-canister-stop)                       | Stops a currently running canister.  |
| [`uninstall-code`](#dfx-canister-uninstall-code)   | Uninstalls a canister, removing its code and state. Does not delete the canister.  |
| [`update-settings`](#dfx-canister-update-settings) | Update one or more of a canister's settings (i.e its controller, compute allocation, or memory allocation.).  |

## Overriding the default deployment environment

By default, `dfx canister` commands run on the local canister execution environment specified in the `dfx.json` file. If you want to send a `dfx canister` subcommand to the Internet Computer or a testnet without changing the settings in your `dfx.json` configuration file, you can explicitly specify the URL to connect to using the `--network` option.

For example, to register unique canister identifiers for a project on the local canister execution environment, you can run the following command:

``` bash
dfx canister create --all
```

If you want to register unique canister identifiers for the same project on the Internet Computer, you can run the following command:

``` bash
dfx canister create --all --network ic
```

The SDK comes with an alias of `ic`, which is configured to point to the Internet Computer. You can also pass a URL as a network option, or you can configure additional aliases in `dfx.json` under the `networks` configuration, or in `$HOME/.config/dfx/networks.json`.

To illustrate, you can call a canister and function running on a testnet using a command similar to the following:

``` bash
dfx canister call counter get --network http://192.168.3.1:5678
```

## Performing a call through the wallet

By default, most `dfx canister` commands to the Internet Computer are signed by and sent from your own principal. (Exceptions are commands that require cycles: `dfx canister create` and `dfx canister deposit-cycles`. Those automatically go through the wallet.) Occasionally, you may want to make a call from your wallet, e.g. when only your wallet is allowed to call a certain function. To send a call through your wallet, you can use the `--wallet` flag like this:

``` bash
dfx canister status <canister name> --wallet <wallet id>
```

As a concrete example, if you want to request the status of a canister on the ic that is only controlled by your wallet, you would do the following:

``` bash
dfx identity get-wallet --network ic
```

This command outputs your wallet's principal (e.g. `22ayq-aiaaa-aaaai-qgmma-cai`) on the `ic` network. Using this id, you can then query the status of the canister (let's assume the canister is called `my_canister_name`) as follows:

``` bash
dfx canister status --network ic --wallet 22ayq-aiaaa-aaaai-qgmma-cai
```

## dfx canister call

Use the `dfx canister call` command to call a specified method on a deployed canister.

### Basic usage

``` bash
dfx canister call [option] canister_name method_name [argument] [flag]
```

### Flags

You can use the following optional flags with the `dfx canister call` command.

| Flag              | Description     |
|-------------------|-----------------|
| `--async`         | Specifies not to wait for the result of the call to be returned by polling the replica. Instead return a response ID.  |
| `-h`, `--help`    | Displays usage information.  |
| `--query`         | Sends a query request instead of an update request. For information about the difference between query and update calls, see [Canisters include both program and state](../../concepts/canisters-code.md#canister-state).  |
| `--update`        | Sends an update request to a canister. This is the default if the method is not a query method.  |

### Options

You can use the following options with the `dfx canister call` command.

| Option                  | Description  |
|-------------------------|--------------|
| `--argument-file`       | Specifies the file from which to read the argument to pass to the method.  Stdin may be referred to as `-`.  |
| `--candid <file.did>`   | Provide the .did file with which to decode the response. Overrides value from dfx.json for project canisters.  |
| `--output <output>`     | Specifies the output format to use when displaying a method’s return result. The valid values are `idl`, `pp` and `raw`. The `pp` option is equivalent to `idl`, but is pretty-printed.  |
| `--random <random>`     | Specifies the config for generating random arguments.  |
| `--type <type>`         | Specifies the data format for the argument when making the call using an argument. The valid values are `idl` and `raw`.  |
| `--with-cycles <amount>`| Specifies the amount of cycles to send on the call. Deducted from the wallet. Requires `--wallet` as a flag to `dfx canister`.  |

### Arguments

You can specify the following arguments for the `dfx canister call` command.

| Argument        | Description  |
|-----------------|--------------|
| `canister_name` | Specifies the name of the canister to call. The canister name is a required argument and should match the name you have configured for a project in the `canisters` section of the `dfx.json` configuration file.  |
| `method_name`   | Specifies the method name to call on the canister. The canister method is a required argument.  |
| `argument`      | Specifies the argument to pass to the method. Depending on your program logic, the argument can be a required or optional argument. You can specify a data format type using the `--type` option if you pass an argument to the canister. By default, you can specify arguments using the [Candid](../../developer-docs/build/candid/candid-intro.md) (`idl`) syntax for data values. For information about using Candid and its supported types, see [Interact with a service in a terminal](../../developer-docs/build/candid/candid-howto.md#idl-syntax) and [Supported types](../candid-ref.md). You can use `raw` as the argument type if you want to pass raw bytes to a canister. |

### Examples

You can use the `dfx canister call` command to invoke specific methods—with or without arguments—after you have deployed the canister using the `dfx canister install` command. For example, to invoke the `get` method for a canister with a `canister_name` of `counter`, you can run the following command:

``` bash
dfx canister call counter get --async
```

In this example, the command includes the `--async` option to indicate that you want to make a separate `request-status` call rather than waiting to poll the local canister execution environment or the Internet Computer for the result. The `--async` option is useful when processing an operation might take some time to complete. The option enables you to continue performing other operations then check for the result using a separate `dfx canister request-status` command. The returned result will be displayed as the IDL textual format.

#### Using the IDL syntax

You can explicitly specify that you are passing arguments using the IDL syntax by running commands similar to the following for a Text data type:

``` bash
dfx canister call hello greet --type idl '("Lisa")'
("Hello, Lisa!")

dfx canister call hello greet '("Lisa")' --type idl
("Hello, Lisa!")
```

You can also implicitly use the IDL by running a command similar to the following:

``` bash
dfx canister call hello greet '("Lisa")'
("Hello, Lisa!")
```

To specify multiple arguments using the IDL syntax, use commas between the arguments. For example:

``` bash
dfx canister call contacts insert '("Amy Lu","01 916-335-2042")'

dfx canister call hotel guestroom '("Deluxe Suite",42,true)'
```

You can pass raw data in bytes by running a command similar to the following:

``` bash
dfx canister call hello greet --type raw '4449444c00017103e29883'
```

This example uses the raw data type to pass a hexadecimal to the `greet` function of the `hello` canister.

## dfx canister create

Use the `dfx canister create` command to register one or more canister identifiers without compiled code. The new canister principals are then recorded in `canister_ids.json` for non-local networks. You must be connected to the local canister execution environment or the Internet Computer to run this command.

Note that you can only run this command from within the project directory structure. For example, if your project name is `hello_world`, your current working directory must be the `hello_world` top-level project directory or one of its subdirectories.

### Basic usage

``` bash
dfx canister create [option] [flag] [--all | canister_name]
```

### Flags

You can use the following optional flags with the `dfx canister create` command.

| Flag              | Description                   |
|-------------------|-------------------------------|
| `-h`, `--help`    | Displays usage information.   |

### Options

You can use the following options with the `dfx canister create` command.

| Option                                    | Description  |
|-------------------------------------------|--------------|
| `-c`, `--compute-allocation <allocation>` | Specifies the canister's compute allocation. This should be a percent in the range [0..100].  |
| `--controller <principal>`                | Specifies the identity name or the principal of the new controller.  |
| `--memory-allocation <memory>`            | Specifies how much memory the canister is allowed to use in total. This should be a value in the range [0..12 GiB]. A setting of 0 means the canister will have access to memory on a “best-effort” basis: It will only be charged for the memory it uses, but at any point in time may stop running if it tries to allocate more memory when there isn’t space available on the subnet.  |
| `--no-wallet`                             | Performs the call with the user Identity as the Sender of messages. Bypasses the Wallet canister. Enabled by default.  |
| `--with-cycles <number-of-cycles>`        | Specifies the initial cycle balance to deposit into the newly created canister. The specified amount needs to take the canister create fee into account. This amount is deducted from the wallet's cycle balance.  |

### Arguments

You can use the following argument with the `dfx canister create` command.

| Argument        | Description  |
|-----------------|--------------|
| `--all`         | Enables you to create multiple canister identifiers at once if you have a project `dfx.json` file that defines multiple canisters. Note that you must specify `--all` or an individual canister name.  |
| `canister_name` | Specifies the name of the canister for which you want to register an identifier. If you are not using the `--all` option, the canister name is a required argument and must match at least one name that you have configured in the `canisters` section of the `dfx.json` configuration file for your project.  |

### Examples

You can use the `dfx canister create` command to register canister identifiers without first compiling any code. For example, if you want to create the canister identifier for the project `my_counter` before writing the program, you can run the following command:

``` bash
dfx canister create my_counter
```

You can use the `dfx canister create` command with the `--with-cycles` option to specify the initial balance upon the creation of one canister or all canisters in a project. For example, to specify an initial balance of 8000000000000 cycles for all canisters, run the following command:

``` bash
dfx canister create --with-cycles 8000000000000 --all
```

## dfx canister delete

Use the `dfx canister delete` command to delete a stopped canister from the local canister execution environment or the Internet Computer. By default, this withdraws remaining cycles to your wallet before deleting the canister.

Note that you can only run this command from within the project directory structure. For example, if your project name is `hello_world`, your current working directory must be the `hello_world` top-level project directory or one of its subdirectories.

### Basic usage

``` bash
dfx canister delete [flag] [--all | canister_name]
```

### Flags

You can use the following optional flags with the `dfx canister delete` command.

| Flag                        | Description                   |
|-----------------------------|-------------------------------|
| `-h`, `--help`              | Displays usage information.   |
| `--no-withdrawal`           | Do not withdrawal cycles, just delete the canister.  |
| `--withdraw-cycles-to-dank` | Withdraw cycles to dank with the current principal.  |

### Arguments

You can use the following arguments with the `dfx canister delete` command.

| Argument        | Description                                                                                                                        |
|-----------------|------------------------------------------------------------------------------------------------------------------------------------|
| `--all`         | Deletes all of the canisters configured in the `dfx.json` file. Note that you must specify `--all` or an individual canister name. |
| `canister_name` | Specifies the name of the canister you want to delete. Note that you must specify either a canister name or the `--all` option.    |
| `--withdraw-cycles-to-canister <principal>` | Withdraw cycles from canister(s) to the specified canister/wallet before deleting.  |
| `--withdraw-cycles-to-dank-principal <principal>` | Withdraw cycles to dank with the given principal.  |

### Examples

You can use the `dfx canister delete` command to delete a specific canister or all canisters.

To delete the `hello_world` canister, you can run the following command:

``` bash
dfx canister delete hello_world
```

To delete all of the canisters you have deployed on the `ic` Internet Computer and configured in your `dfx.json`, you can run the following command:

``` bash
dfx canister  delete --all--network=ic
```

## dfx canister deposit-cycles

Use the `dfx canister deposit-cycles` command to deposit cycles from your configured wallet into a canister.

Note that you must have your cycles wallet configured for this to work.

### Basic usage

``` bash
dfx canister deposit-cycles [amount of cycles] [--all | canister_name]
```

### Flags

You can use the following optional flags with the `dfx canister deposit-cycles` command.

| Flag              | Description                   |
|-------------------|-------------------------------|
| `-h`, `--help`    | Displays usage information.   |

### Arguments

You can use the following arguments with the `dfx canister deposit-cycles` command.

| Argument        | Description                                                                                                                        |
|-----------------|------------------------------------------------------------------------------------------------------------------------------------|
| `--all`         | Deposits the specified amount of cycles into all canisters configured in `dfx.json`. Note that you must specify `--all` or an individual canister name. |
| `canister_name` | Specifies the name of the canister you want to deposit cycles into. Note that you must specify either a canister name or the `--all` option.    |

### Examples

You can use the `dfx canister deposit-cycles` command to add cycles to a specific canister or all canisters.

To add 1T cycles to the canister called `hello`, you can run the following command:

``` bash
dfx canister deposit-cycles 1000000000000 hello
```

To add 2T cycles to each individual canister specified in `dfx.json`, you can run the following command:

``` bash
dfx canister deposit-cycles 2000000000000 --all
```

## dfx canister id

Use the `dfx canister id` command to output the canister identifier/principal for a specific canister name.

Note that you can only run this command from within the project directory structure. For example, if your project name is `hello_world`, your current working directory must be the `hello_world` top-level project directory or one of its subdirectories.

### Basic usage

``` bash
dfx canister id [flag] canister_name
```

### Flags

You can use the following optional flags with the `dfx canister id` command.

| Flag              | Description                   |
|-------------------|-------------------------------|
| `-h`, `--help`    | Displays usage information.   |

### Arguments

You can use the following argument with the `dfx canister id` command.

| Argument        | Description                                                                     |
|-----------------|---------------------------------------------------------------------------------|
| `canister_name` | Specifies the name of the canister for which you want to display an identifier. |

### Examples

You can use the `dfx canister id` command to display the canister identifier for a specific canister name.

To display the canister identifier for the `hello_world` canister, you can run the following command:

``` bash
dfx canister id hello_world
```

The command displays output similar to the following:

``` bash
75hes-oqbaa-aaaaa-aaaaa-aaaaa-aaaaa-aaaaa-q
```

## dfx canister info

Use the `dfx canister info` command to output a canister's controller and installed WASM module hash.

### Basic usage

``` bash
dfx canister info canister
```

### Flags

You can use the following optional flags with the `dfx canister info` command.

| Flag              | Description                   |
|-------------------|-------------------------------|
| `-h`, `--help`    | Displays usage information.   |

### Arguments

You can use the following argument with the `dfx canister info` command.

| Argument   | Description                                                                   |
|------------|-------------------------------------------------------------------------------|
| `canister` | Specifies the name or id of the canister for which you want to display data.  |

### Examples

You can use the `dfx canister info` command to display the canister controller and installed WASM module.

To the data about the `hello_world` canister, you can run the following command:

``` bash
dfx canister info hello_world
```

The command displays output similar to the following:

```
Controllers: owdog-wiaaa-aaaad-qaaaq-cai
Module hash: 0x2cfb6f216fd6ab367364c02960afbbc5c444f5481225ee676992ac9058fd41e3
```

## dfx canister install

Use the `dfx canister install` command to install compiled code as a canister on the Internet Computer or on the local canister execution environment.

### Basic usage

``` bash
dfx canister install [flag] [option] [--all | canister_name]
```

### Flags

You can use the following optional flags with the `dfx canister install` command.

| Flag              | Description  |
|-------------------|--------------|
| `--async-call`    | Enables you to continue without waiting for the result of the installation to be returned by polling the Internet Computer or the local canister execution environment.  |
| `-h`, `--help`    | Displays usage information.  |
| `--upgrade-unchanged` | Upgrade the canister even if the .wasm did not change.  |

### Options

You can use the following options with the `dfx canister install` command.

| Option   | Description  |
|----------|--------------|
| `--argument <argument>`                           | Specifies an argument to pass to the canister during installation.  |
| `--argument-type <argument-type>`                 | Specifies the data format for the argument when you install using the `--argument` option. The valid values are `idl` and `raw`. By default, you can specify arguments using the [Candid](../../developer-docs/build/candid/candid-intro.md) (`idl`) syntax for data values. For information about using Candid and its supported types, see [Interact with a service in a terminal](../../developer-docs/build/candid/candid-howto.md#idl-syntax) and [Supported types](../candid-ref.md). You can use `raw` as the argument type if you want to pass raw bytes to a canister. |
| `-c`, `--compute-allocation <compute-allocation>` | Defines a compute allocation—essentially the equivalent of setting a CPU allocation—for canister execution. You can set this value as a percentage in the range of 0 to 100.  |
| `--memory-allocation <memory-allocation>`         | Specifies how much memory the canister is allowed to use in total. You can set this value in the range of 0 to 8MB.  |
| `-m`, `--mode <mode>`                             | Specifies whether you want to `install`, `reinstall`, or `upgrade` canisters. Defaults to `install`. For more information about installation modes and canister management, see [Managing canisters](../../developer-docs/build/project-setup/manage-canisters.md).  |
| `--wasm <file.wasm>`                              | Specifies a particular WASM file to install, bypassing the dfx.json project settings.  |

### Arguments

You can use the following arguments with the `dfx canister install` command.

| Argument        | Description  |
|-----------------|--------------|
| `--all`         | Enables you to install multiple canisters at once if you have a project `dfx.json` file that includes multiple canisters. Note that you must specify `--all` or an individual canister name.  |
| `canister_name` | Specifies the name of the canister to deploy. If you are not using the `--all` option, the canister name is a required argument and should match the name you have configured for a project in the `canisters` section of the `dfx.json` configuration file. |

### Examples

You can use the `dfx canister install` command to deploy WebAssembly you have compiled using the `dfx build` command as a canister on the Internet Computer or on the local canister execution environment. The most common use case is to install all of the canisters by running the following command:

``` bash
dfx canister install --all
```

#### Installing a specific canister

You can also use the `dfx canister install` command to deploy a specific canister instead of all of the canisters in your project. For example, if you have a project with a `hello_world_backend` canister and a `hello_world_frontend` canister but only want to deploy the `hello_world_backend` canister, you can deploy just that the canister by running the following command:

``` bash
dfx canister install hello_world_backend
```

#### Sending an asynchronous request

If you want to submit a request to install the canister and return a request identifier to check on the status of your request later instead of waiting for the command to complete, you can run a command similar to the following:

``` bash
dfx canister install hello_world_backend --async
```

This command submits a request to install the canister and returns a request identifier similar to the following:

``` bash
0x58d08e785445dcab4ff090463b9e8b12565a67bf436251d13e308b32b5058608
```

You can then use the request identifier to check the status of the request at a later time, much like a tracking number if you were shipping a package.

#### Overriding the default deployment options

If you want to deploy a canister on a testnet without changing the settings in your `dfx.json` configuration file, you can explicitly specify the testnet you want to connect to by using the `--network` option.

For example, you can specify a testnet URL by running a command similar to the following:

``` bash
dfx canister install --all --network http://192.168.3.1:5678
```

#### Allocating message processing

The `--compute-allocation` options allows you to allocate computing resources as a percentage in the range of 0 to 100 to indicate how often your canister should be scheduled for execution.

For example, assume you run the following command:

``` bash
dfx canister install --all --compute-allocation 50
```

With this setting, all of the canisters in the current projects are assigned a 50% allocation. When canisters in the project receive input messages to process, the messages are scheduled for execution. Over 100 execution cycles, each canister’s messages will be scheduled for processing at least 50 times.

The default value for this option is 0—indicating that no specific allocation or scheduling is in effect. If all of your canisters use the default setting, processing occurs in a round-robin fashion.

## dfx canister metadata

Use the `dfx canister metadata` command to display metadata stored in a canister's WASM module.

### Basic usage

``` bash
dfx canister metadata canister metadata-name
```

### Flags

You can use the following optional flags with the `dfx canister metadata` command.

| Flag              | Description                   |
|-------------------|-------------------------------|
| `-h`, `--help`    | Displays usage information.   |

### Arguments

You can use the following argument with the `dfx canister metadata` command.

| Argument        | Description                                                                      |
|-----------------|----------------------------------------------------------------------------------|
| `canister`      | Specifies the name or id of the canister for which you want to display metadata. |
| `metadata-name` | Specifies the name of the metadata which you want to display.                    |


### Examples

To display the candid service metadata for the `hello_world` canister, you can run the following command:

``` bash
dfx canister metadata hello_world candid:service
```

The command displays output similar to the following:

```
service : {
  greet: (text) -> (text);
}
```


## dfx canister request-status

Use the `dfx canister request-status` command to request the status of a specified call to a canister. This command requires you to specify the request identifier you received after invoking a method on the canister. The request identifier is an hexadecimal string starting with `0x`.

### Basic usage

``` bash
dfx canister request-status request_id [option]
```

### Flags

You can use the following optional flags with the `dfx canister request-status` command.

| Flag              | Description                   |
|-------------------|-------------------------------|
| `-h`, `--help`    | Displays usage information.   |

### Options

You can use the following options with the `dfx canister request-status` command.

| Option   | Description  |
|----------|--------------|
| `--output <output>`  | Specifies the format for displaying the method's return result. Possible values are `idl`, `raw` and `pp`, where `pp` is equivalent to `idl`, but is pretty-printed.  |

### Arguments

You can specify the following argument for the `dfx canister request-status` command.

| Argument     | Description                                                                                                                                                                  |
|--------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `request_id` | Specifies the hexadecimal string returned in response to a `dfx canister call` or `dfx canister install` command. This identifier is an hexadecimal string starting with 0x. |

### Examples

You can use the `dfx canister request-status` command to check on the status of a canister state change or to verify that a call was not rejected by running a command similar to the following:

``` bash
dfx canister request-status 0x58d08e785445dcab4ff090463b9e8b12565a67bf436251d13e308b32b5058608
```

This command displays an error message if the request identifier is invalid or refused by the canister.


## dfx canister send

Use the `dfx canister send` command after signing a message with the `dfx canister sign` command when you want to separate these steps, rather than using the single `dfx canister call` command. Using separate calls can add security to the transaction.

For example, when creating your neuron stake, you might want to use the `dfx canister sign` command to create a signed `message.json` file using an air-gapped computer, then use the `dfx canister send` command to deliver the signed message.

### Basic usage

``` bash
dfx canister send file_name
```

### Flags

You can use the following optional flags with the `dfx canister request-status` command.

| Flag              | Description                   |
|-------------------|-------------------------------|
| `-h`, `--help`    | Displays usage information.   |
| `--status`        | Send the signed request-status call in the message.  |

### Arguments

You can specify the following argument for the `dfx canister send` command.

| Argument    | Description                             |
|-------------|-----------------------------------------|
| `file_name` | Specifies the file name of the message. |

### Examples

Use the `dfx canister send` command to send a signed message created using the `dfx canister sign` command to the genesis token canister (GTC) to create a neuron on your behalf by running the following command:

`dfx canister send message.json`

## dfx canister sign

Use the `dfx canister sign` command before sending a message with the `dfx canister send` command when you want to separate these steps, rather than using the single `dfx canister call` command. Using separate calls can add security to the transaction. For example, when creating your neuron stake, you might want to use the `dfx canister sign` command to create a signed `message.json` file using an air-gapped computer, then use the `dfx canister send` command to deliver the signed message from a computer connected to the Internet Computer.

### Basic usage

``` bash
dfx canister sign [flag] [option] canister-name method-name [argument]
```

### Flags

You can use the following optional flags with the `dfx canister sign` command.

| Flag              | Description                                                                                              |
|-------------------|----------------------------------------------------------------------------------------------------------|
| `-h`, `--help`    | Displays usage information.                                                                              |
| `--query`         | Sends a query request to a canister.                                                                     |
| `--update`        | Sends an update request to the canister. This is the default method if the `--query` method is not used. |

### Options

You can specify the following options for the `dfx canister sign` command.

| Option                       | Description  |
|------------------------------|--------------|
| `--expire-after <seconds>`   | Specifies how long the message will be valid before it expires and cannot be sent. Specify in seconds. If not defined, the default is 300s (5m).  |
| `--file <output>`            | Specifies the output file name. The default is `message.json`.  |
| `--random <random>`          | Specifies the configuration for generating random arguments.  |
| `--type <type>`              | Specifies the data type for the argument when making a call using an argument. Possible values are `idl` and `raw`.  |

<!--
### Arguments

You can specify the following arguments for the `dfx canister sign` command.

| Argument        | Description  |
|-----------------|--------------|
| `canister_name` | Specifies the name of the canister to call. The canister name is a required argument and should match the name you have configured for a project in the `canisters` section of the `dfx.json` configuration file.  |
| `method_name`   | Specifies the method name to call on the canister. The canister method is a required argument.  |
| `argument`      | Specifies the argument to pass to the method. Depending on your program logic, the argument can be a required or optional argument. You can specify a data format type using the `--type` option if you pass an argument to the canister. By default, you can specify arguments using the [Candid](../candid-ref.md) (`idl`) syntax for data values. For information about using Candid and its supported types, see [Interact with a service in a terminal](../../developer-docs/build/candid/candid-howto.md#idl-syntax) and [Supported types](../candid-ref#supported-types). You can use `raw` as the argument type if you want to pass raw bytes. |

### Examples

Use the `dfx canister sign` command to create a signed `message.json` file using the selected identity by running a command similar to the following:

`dfx canister sign --network=ic --expire-after=1h rno2w-sqaaa-aaaaa-aaacq-cai create_neurons ‘(“PUBLIC_KEY”)’`

This command illustrates how to creates a `message.json` file to create neurons on the Internet Computer specified by the `ic` alias, that is signed using your principal identifier as the message sender and with an expiration window that ends in one hour.

Note that the time allotted to send a signed message is a fixed 5-minute window. The `--expire-after` option enables you to specify the point in time when the 5-minute window for sending the signed message should end. For example, if you set the `--expire-after` option to one hour (`1h`), you must wait at least 55 minutes before you send the generated message and the signature for the message is only valid during the 5-minute window ending in the 60th minute.

In this example, therefore, you would need to send the message after 55 minutes and before 60 minutes for the message to be recognized as valid.

If you don’t specify the `--expire-after` option, the default expiration is five minutes.

Send the signed message to the genesis token canister (GTC) to create a neuron on your behalf by running the following command:

`dfx canister send message.json`

## dfx canister start

Use the `dfx canister start` command to restart a stopped canister on the Internet Computer or the local canister execution environment.

In most cases, you run this command after you have stopped a canister to properly terminate any pending requests as a prerequisite to upgrading the canister.

Note that you can only run this command from within the project directory structure. For example, if your project name is `hello_world`, your current working directory must be the `hello_world` top-level project directory or one of its subdirectories.

### Basic usage

``` bash
dfx canister start [--all | canister_name]
```

### Flags

You can use the following optional flags with the `dfx canister start` command.

| Flag              | Description                   |
|-------------------|-------------------------------|
| `-h`, `--help`    | Displays usage information.   |

### Arguments

You can use the following arguments with the `dfx canister start` command.

| Argument        | Description                                                                                                                       |
|-----------------|-----------------------------------------------------------------------------------------------------------------------------------|
| `--all`         | Starts all of the canisters configured in the `dfx.json` file. Note that you must specify `--all` or an individual canister name. |
| `canister_name` | Specifies the name of the canister you want to start. Note that you must specify either a canister name or the `--all` option.    |

### Examples

You can use the `dfx canister start` command to start a specific canister or all canisters.

To start the `hello_world` canister, you can run the following command:

``` bash
dfx canister start hello_world
```

To start all of the canisters you have deployed on the `ic` Internet Computer, you can run the following command:

``` bash
dfx canister start --all --network=ic
```

## dfx canister status

Use the `dfx canister status` command to check whether a canister is currently running, in the process of stopping, or currently stopped on the Internet Computer or on the local canister execution environment.

Note that you can only run this command from within the project directory structure. For example, if your project name is `hello_world`, your current working directory must be the `hello_world` top-level project directory or one of its subdirectories.

### Basic usage

``` bash
dfx canister status [--all | canister_name]
```

### Flags

You can use the following optional flags with the `dfx canister status` command.

| Flag              | Description                   |
|-------------------|-------------------------------|
| `-h`, `--help`    | Displays usage information.   |

### Arguments

You can use the following arguments with the `dfx canister status` command.

| Argument        | Description                                                                                                                                               |
|-----------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------|
| `--all`         | Returns status information for all of the canisters configured in the `dfx.json` file. Note that you must specify `--all` or an individual canister name. |
| `canister_name` | Specifies the name of the canister you want to return information for. Note that you must specify either a canister name or the `--all` option.           |

### Examples

You can use the `dfx canister status` command to check the status of a specific canister or all canisters.

To check the status of the `hello_world` canister, you can run the following command:

``` bash
dfx canister status hello_world
```

To check the status for all of the canisters you have deployed on the `ic` Internet Computer, you can run the following command:

``` bash
dfx canister status --all --network=ic
```

## dfx canister stop

Use the `dfx canister stop` command to stop a canister that is currently running on the Internet Computer or on the local canister execution environment.

In most cases, you run this command to properly terminate any pending requests as a prerequisite to upgrading the canister.

Note that you can only run this command from within the project directory structure. For example, if your project name is `hello_world`, your current working directory must be the `hello_world` top-level project directory or one of its subdirectories.

### Basic usage

``` bash
dfx canister stop [--all | canister_name]
```

### Flags

You can use the following optional flags with the `dfx canister stop` command.

| Flag              | Description                   |
|-------------------|-------------------------------|
| `-h`, `--help`    | Displays usage information.   |

### Arguments

You can use the following arguments with the `dfx canister stop` command.

| Argument        | Description                                                                                                                      |
|-----------------|----------------------------------------------------------------------------------------------------------------------------------|
| `--all`         | Stops all of the canisters configured in the `dfx.json` file. Note that you must specify `--all` or an individual canister name. |
| `canister_name` | Specifies the name of the canister you want to stop. Note that you must specify either a canister name or the `--all` option.    |

### Examples

You can use the `dfx canister stop` command to stop a specific canister or all canisters.

To stop the `hello_world` canister, you can run the following command:

``` bash
dfx canister stop hello_world
```

To stop all of the canisters you have deployed on the `ic` Internet Computer, you can run the following command:

``` bash
dfx canister stop --all --network=ic
```

## dfx canister uninstall-code

Use the `dfx canister uninstall-code` command to uninstall the code that a canister that is currently running on the Internet Computer or on the local canister execution environment.

This method removes a canister’s code and state, making the canister empty again. Only the controller of the canister can uninstall code. Uninstalling a canister’s code will reject all calls that the canister has not yet responded to, and drop the canister’s code and state. Outstanding responses to the canister will not be processed, even if they arrive after code has been installed again. The canister is now empty.

Note that you can only run this command from within the project directory structure. For example, if your project name is `hello_world`, your current working directory must be the `hello_world` top-level project directory or one of its subdirectories.

### Basic usage

``` bash
dfx canister uninstall-code [flag] [--all | canister_name]
```

### Flags

You can use the following optional flags with the `dfx canister uninstall-code` command.

| Flag              | Description                   |
|-------------------|-------------------------------|
| `-h`, `--help`    | Displays usage information.   |

### Arguments

You can use the following arguments with the `dfx canister uninstall-code` command.

| Argument        | Description                                                                                                                           |
|-----------------|---------------------------------------------------------------------------------------------------------------------------------------|
| `--all`         | Uninstalls all of the canisters configured in the `dfx.json` file. Note that you must specify `--all` or an individual canister name. |
| `canister_name` | Specifies the name of the canister you want to uninstall. Note that you must specify either a canister name or the `--all` option.    |

### Examples

You can use the `dfx canister uninstall-code` command to uninstall a specific canister or all canisters.

To uninstall the `hello_world` canister, you can run the following command:

``` bash
dfx canister uninstall-code hello_world
```

To uninstall all of the canisters you have deployed on the `ic` Internet Computer, you can run the following command:

``` bash
dfx canister uninstall-code --all --network=ic
```

## dfx canister update-settings

Use the `dfx canister update-settings` command to update the settings of a canister running in the local execution environment.

In most cases, you run this command to tune the amount of resources allocated to your canister.

Note that you can only run this command from within the project directory structure. For example, if your project name is `hello_world`, your current working directory must be the `hello_world` top-level project directory or one of its subdirectories.

### Basic usage

``` bash
dfx canister update-settings [flags] [options] [canister_name | --all]
```

### Flags

You can use the following optional flags with the `dfx canister update-settings` command.

| Flag                                    | Description  |
|-----------------------------------------|--------------|
| `-h`, `--help`                          | Displays usage information.  |
| `--confirm-very-long-freezing-threshold`| Freezing thresholds above ~1.5 years require this flag as confirmation. |

### Options

You can specify the following options for the `dfx canister update-settings` command.

| Option                                     | Description  |
|--------------------------------------------|--------------|
| `--add-controller <principal>`             | Add a principal to the list of controllers of the canister.  |
| `-c`, `--compute-allocation <allocation>`  | Specifies the canister's compute allocation. This should be a percent in the range [0..100].  |
| `--set-controller <principal>`             | Specifies the identity name or the principal of the new controller.  |
| `--memory-allocation <allocation>`         | Specifies how much memory the canister is allowed to use in total. This should be a value in the range [0..12 GiB]. A setting of 0 means the canister will have access to memory on a “best-effort” basis: It will only be charged for the memory it uses, but at any point in time may stop running if it tries to allocate more memory when there isn’t space available on the subnet. |
| `--remove-controller <principal>`          | Removes a principal from the list of controllers of the canister. |
| `--freezing-threshold <seconds>`           | Set the [freezing threshold](https://internetcomputer.org/docs/current/references/ic-interface-spec/#ic-create_canister) in seconds for a canister. This should be a value in the range [0..2^64^-1]. Very long thresholds require the `--confirm-very-long-freezing-threshold` flag.  |

### Arguments

You can use the following arguments with the `dfx canister update-settings` command.

| Argument        | Description                                             |
|-----------------|---------------------------------------------------------|
| `--all`         | Updates all canisters you have specified in `dfx.json`. You must specify either canister name/id or the --all option.  |
| `canister_name` | Specifies the name of the canister you want to update. You must specify either canister name/id or the --all option.  |

### Examples

You can use the `dfx canister update-settings` command to update settings of a specific canister.

To update the settings of the `hello_world` canister, you can run the following command:

``` bash
dfx canister update-settings --freezing-threshold 2592000 --compute-allocation 99 hello_world
```

-->
