if test -n "$BASH" ; then SCRIPT_NAME=$BASH_SOURCE
elif test -n "$TMOUT"; then SCRIPT_NAME=${.sh.file}
elif test -n "$ZSH_NAME" ; then SCRIPT_NAME=${(%):-%x}
elif test ${0##*/} = dash; then x=$(lsof -p $$ -Fn0 | tail -1); SCRIPT_NAME=${x#n}
else SCRIPT_NAME=$0
fi

SCRIPT_DIR="$(cd "$(dirname -- "$SCRIPT_NAME")" 2>/dev/null && pwd -P)"

export REG_LOCAL_ROOT_DIR_PATH=$(readlink -f ${SCRIPT_DIR}/../src/sim)
unset SCRIPT_DIR

echo "REG_LOCAL_ROOT_DIR_PATH         " $REG_LOCAL_ROOT_DIR_PATH
