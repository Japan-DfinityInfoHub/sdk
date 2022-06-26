# dfx cache

`dfx cache` コマンドとフラグ、サブコマンドを使用して `dfx` のバージョンのキャッシュを管理することができます。

`dfx cache` コマンドを実行するための基本的な構文は以下のとおりです：

``` bash
dfx cache [subcommand] [flag]
```

指定する `dfx cache` のサブコマンドによっては、追加の引数、オプション、およびフラグが適用される場合があります。 `dfx cache` コマンドを使用する際の利用情報および例を参考にして、適切なコマンドを選択してください。

|コマンド |説明|
|----------------------------|-------------------------------------------------------------------------------|
|<<dfx cache delete,`delete`>> |指定されたバージョンの `dfx` をローカルキャッシュから削除します。|
|`help` |指定されたサブコマンドの使用情報を表示します。|
|<<dfx cache install,`install`>> |指定されたバージョンの `dfx` をローカルキャッシュからインストールします。|
|<<dfx cache list,`list`>> |現在インストールされている `dfx` のバージョンと、現在のプロジェクトで使用されているバージョンをリストアップします。|
|<<dfx cache show,`show`>> |`dfx` 実行ファイルのバージョンが使用しているキャッシュのパスを表示します。|

特定のサブコマンドの使用情報を見るには、そのサブコマンドと `--help` フラグを指定します。 例えば、`dfx cache delete` の使用情報を見るには、以下のコマンドを実行します。

``` bash
dfx cache delete --help
```

## dfx cache delete

ローカルコンピューター上のバージョンキャッシュから指定したバージョンの `dfx` を削除するには、`dfx cache delete` コマンドを使用します。

### 基本的な利用法

``` bash
dfx cache delete [version] [flag]
```

### フラグ

`dfx cache delete` コマンドでは、以下のオプションフラグを使用することができます。

|フラグ |説明|
|-------------------|-------------------------------|
|`-h`, `--help` |利用情報を表示します。|
|`-V`, `--version` |バージョン情報を表示します。|

### 引数

`dfx cache delete` コマンドでは、以下の引数を指定できます。

|コマンド|説明|
|-----------|--------------------------------------------------------------------|
|`version` |ローカルキャッシュから削除する `dfx` のバージョンを指定します。|

### 例

`dfx cache delete` コマンドを使用すると、もう使用したくない `dfx` のバージョンを完全に削除することができます。 例えば、以下のコマンドを実行すると、`dfx` のバージョン `0.6.2` を削除することができます。

``` bash
dfx cache delete 0.6.2
```

## dfx cache install

`dfx cache install` コマンドを使用すると `dfx` キャッシュにある最新バージョンを `dfx` にインストールすることができます。

### 基本的な利用法

``` bash
dfx cache install [flag]
```

### フラグ

`dfx cache install` コマンドでは、以下のオプションフラグを使用することができます。

|フラグ |説明|
|-------------------|-------------------------------|
|`-h`, `--help` |利用情報を表示します。|
|`-V`, `--version` |バージョン情報を表示します。|

### 例

`dfx cache install` コマンドを使用すると、キャッシュのバージョンから（最新の） `dfx` を強制的にインストールすることができます。 例えば、以下のコマンドを実行すると `dfx` がインストールされます：

``` bash
dfx cache install
```

## dfx cache list

`dfx cache list` コマンドを使用すると、現在インストールされていて、プロジェクトで使用されている `dfx` のバージョンをリストアップすることができます。

複数のバージョンの `dfx` がインストールされている場合、キャッシュリストには現在有効なバージョンを示すアスタリスク (\*) が表示されます。

### 基本的な利用法

``` bash
dfx cache list [flag]
```

### フラグ

以下のオプションフラグは `dfx cache list` コマンドで使用できます。

|フラグ |説明|
|-------------------|-------------------------------|
|`-h`, `--help` |利用情報を表示します。|
|`-V`, `--version` |バージョン情報を表示します。|

### 例

`dfx cache list` コマンドを使用すると、現在インストールされていて、プロジェクトで使用されている `dfx` のバージョンをリストアップすることができます。 例えば、以下のコマンドを実行すると、キャッシュにある `dfx` のバージョンをリストアップします：

``` bash
dfx cache list
```

このコマンドは以下のような `dfx` バージョンが見つかった場合、一覧を表示します。

``` bash
0.6.4 *
0.6.3
0.6.0
```

## dfx cache show

`dfx cache show` コマンドを使用すると、現在使用している `dfx` のバージョンキャッシュのフルパスを表示します。

### 基本的な利用法

``` bash
dfx cache show [flag]
```

### フラグ

以下のオプションフラグは `dfx cache show` コマンドで使用することができます。

|フラグ |説明|
|-------------------|-------------------------------|
|`-h`, `--help` |利用情報を表示します。|
|`-V`, `--version` |バージョン情報を表示します。|

### 例

`dfx cache show` コマンドを使用すると、現在使用している `dfx` のバージョンで使用されているキャッシュのパスを表示することができます：

``` bash
dfx cache show
```

このコマンドは現在使用している `dfx` のバージョンで使用されているキャッシュのパスを表示します：

``` bash
/Users/pubs/.cache/dfinity/versions/0.6.4
```


<!--
# dfx cache

Use the `dfx cache` command with flags and subcommands to manage the `dfx` version cache.

The basic syntax for running `dfx cache` commands is:

``` bash
dfx cache [subcommand] [flag]
```

Depending on the `dfx cache` subcommand you specify, additional arguments, options, and flags might apply. For reference information and examples that illustrate using `dfx cache` commands, select an appropriate command.

| Command                    | Description                                                                   |
|----------------------------|-------------------------------------------------------------------------------|
| [`delete`](#delete)        | Deletes the specified version of `dfx` from the local cache.                  |
| `help`                     | Displays usage information message for a specified subcommand.                |
| [`install`](#install)      | Installs the specified version of `dfx` from the local cache.                 |
| [`list`](#_dfx_cache_list) | Lists the versions of `dfx` currently installed and used in current projects. |
| [`show`](#_dfx_cache_show) | Show the path of the cache used by this version of the `dfx` executable.      |

To view usage information for a specific subcommand, specify the subcommand and the `--help` flag. For example, to see usage information for `dfx cache delete`, you can run the following command:

``` bash
dfx cache delete --help
```

## dfx cache delete

Use the `dfx cache delete` command to delete a specified version of `dfx` from the version cache on the local computer.

### Basic usage

``` bash
dfx cache delete [version] [flag]
```

### Flags

You can use the following optional flags with the `dfx cache delete` command.

| Flag              | Description                   |
|-------------------|-------------------------------|
| `-h`, `--help`    | Displays usage information.   |
| `-V`, `--version` | Displays version information. |

### Arguments

You can specify the following argument for the `dfx cache delete` command.

| Command   | Description                                                        |
|-----------|--------------------------------------------------------------------|
| `version` | Specifies the version of `dfx` you to delete from the local cache. |

### Examples

You can use the `dfx cache delete` command to permanently delete versions of `dfx` that you no longer want to use. For example, you can run the following command to delete `dfx` version `0.6.2`:

``` bash
dfx cache delete 0.6.2
```

## dfx cache install

Use the `dfx cache install` command to install `dfx` using the version currently found in the `dfx` cache.

### Basic usage

``` bash
dfx cache install [flag]
```

### Flags

You can use the following optional flags with the `dfx cache install` command.

| Flag              | Description                   |
|-------------------|-------------------------------|
| `-h`, `--help`    | Displays usage information.   |
| `-V`, `--version` | Displays version information. |

### Examples

You can use the `dfx cache install` command to force the installation of `dfx` from the version in the cache. For example, you can run the following command to install `dfx`:

``` bash
dfx cache install
```

## dfx cache list

Use the `dfx cache list` command to list the `dfx` versions you have currently installed and used in projects.

If you have multiple versions of `dfx` installed, the cache list displays an asterisk (\*) to indicate the currently active version.

### Basic usage

``` bash
dfx cache list [flag]
```

### Flags

You can use the following optional flags with the `dfx cache list` command.

| Flag              | Description                   |
|-------------------|-------------------------------|
| `-h`, `--help`    | Displays usage information.   |
| `-V`, `--version` | Displays version information. |

### Examples

You can use the `dfx cache list` command to list the `dfx` versions you have currently installed and used in projects. For example, you can run the following command to list versions of `dfx` found in the cache:

``` bash
dfx cache list
```

This command displays the list of `dfx` versions found similar to the following:

``` bash
0.6.4 *
0.6.3
0.6.0
```

## dfx cache show

Use the `dfx cache show` command to display the full path to the cache used by the `dfx` version you are currently using.

### Basic usage

``` bash
dfx cache show [flag]
```

### Flags

You can use the following optional flags with the `dfx cache show` command.

| Flag              | Description                   |
|-------------------|-------------------------------|
| `-h`, `--help`    | Displays usage information.   |
| `-V`, `--version` | Displays version information. |

### Examples

You can use the `dfx cache show` command to display the path to the cache used by the `dfx` version you are currently using:

``` bash
dfx cache show
```

This command displays the path to the cache used by the `dfx` version you are currently using:

``` bash
/Users/pubs/.cache/dfinity/versions/0.6.4
```

-->