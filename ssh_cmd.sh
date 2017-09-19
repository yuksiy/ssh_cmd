#!/bin/sh

# ==============================================================================
#   機能
#     sshコマンドのラッパースクリプト
#   構文
#     USAGE 参照
#
#   Copyright (c) 2009-2017 Yukio Shiiya
#
#   This software is released under the MIT License.
#   https://opensource.org/licenses/MIT
# ==============================================================================

######################################################################
# 関数定義
######################################################################
USAGE() {
	cat <<- EOF 1>&2
		Usage:
		  ssh_cmd.sh [OPTIONS ...] "REMOTE_HOSTS ..." "CMD_LINE"
		
		OPTIONS:
		    -E "SSH_OPTIONS ..."
		       Specify options which execute ssh command with.
		       See also ssh(1) for the further information on each option.
		    -n (no-play)
		       Print the commands that would be executed, but do not execute them.
		    -v (verbose)
		       Verbose output.
		    --show-empty-response={0|1}
		       When an output is empty and you want to display at least a hostname,
		       specify 1. Default is ${FLAG_OPT_SHOW_EMPTY_RESPONSE}.
		    --help
		       Display this help and exit.
	EOF
}

######################################################################
# 変数定義
######################################################################
SSH_OPTIONS=""

RESULT=0

FLAG_OPT_NO_PLAY=FALSE
FLAG_OPT_VERBOSE=FALSE
FLAG_OPT_SHOW_EMPTY_RESPONSE="0"

######################################################################
# メインルーチン
######################################################################

# オプションのチェック
CMD_ARG="`getopt -o E:nv -l show-empty-response:,help -- \"$@\" 2>&1`"
if [ $? -ne 0 ];then
	echo "-E ${CMD_ARG}" 1>&2
	USAGE;exit 1
fi
eval set -- "${CMD_ARG}"
while true ; do
	opt="$1"
	case "${opt}" in
	-E)
		SSH_OPTIONS="${SSH_OPTIONS:+${SSH_OPTIONS} }$2" ; shift 2
		;;
	-n)	FLAG_OPT_NO_PLAY=TRUE ; shift 1;;
	-v)	FLAG_OPT_VERBOSE=TRUE ; shift 1;;
	--show-empty-response)
		case $2 in
		0|1)	FLAG_OPT_SHOW_EMPTY_RESPONSE="$2" ; shift 2;;
		*)
			echo "-E Argument to \"${opt}\" is invalid -- \"$2\"" 1>&2
			USAGE;exit 1
			;;
		esac
		;;
	--help)
		USAGE;exit 0
		;;
	--)
		shift 1;break
		;;
	esac
done

# 第1引数のチェック
if [ "$1" = "" ];then
	echo "-E Missing REMOTE_HOSTS argument" 1>&2
	USAGE;exit 1
else
	REMOTE_HOSTS="$1"
fi

# 第2引数のチェック
if [ "$2" = "" ];then
	echo "-E Missing CMD_LINE argument" 1>&2
	USAGE;exit 1
else
	if [ "${FLAG_OPT_NO_PLAY}" = "FALSE" ];then
		if [ "${FLAG_OPT_VERBOSE}" = "FALSE" ];then
			CMD_LINE="$2"
		else
			CMD_LINE="echo '+ $2'; $2"
		fi
	else
		if [ "${FLAG_OPT_VERBOSE}" = "FALSE" ];then
			CMD_LINE="true"
		else
			CMD_LINE="echo '+ $2'"
		fi
	fi
fi

for host in ${REMOTE_HOSTS} ; do
	output="$(eval "ssh ${SSH_OPTIONS:+${SSH_OPTIONS}} ${host} \"${CMD_LINE}\" 2>&1")"
	if [ $? -ne 0 ];then
		RESULT=1
	fi
	if [ \( "${FLAG_OPT_SHOW_EMPTY_RESPONSE}" = "1" \) -o \( ! "${output}" = "" \) ];then
		echo
		echo "${output}" | sed "s/^/${host}: /"
	fi
done

# 作業終了後処理
exit ${RESULT}

