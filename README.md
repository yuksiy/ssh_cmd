# ssh_cmd

## 概要

sshコマンドのラッパースクリプト

## 使用方法

### ssh_cmd.sh

sshコマンドを使用して、リモートホストでコマンドを実行します。

    $ ssh_cmd.sh "リモートホスト名 ..." "コマンドライン"

### その他

* 上記で紹介したツールの詳細については、「ツール名 --help」を参照してください。

## 動作環境

OS:

* Linux
* Cygwin

依存パッケージ または 依存コマンド:

* make
* openssh

## インストール

ソースからインストールする場合:

    (Linux, Cygwin の場合)
    # make install

fil_pkg.plを使用してインストールする場合:

[fil_pkg.pl](https://github.com/yuksiy/fil_tools_pl/blob/master/README.md#fil_pkgpl) を参照してください。

## インストール後の設定

環境変数「PATH」にインストール先ディレクトリを追加してください。

## 最新版の入手先

<https://github.com/yuksiy/ssh_cmd>

## License

MIT License. See [LICENSE](https://github.com/yuksiy/ssh_cmd/blob/master/LICENSE) file.

## Copyright

Copyright (c) 2009-2017 Yukio Shiiya
