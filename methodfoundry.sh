#!/bin/bash
# Extensible #method_missing for bash

# put these files where they make sense in your system,
# then run this script directly to install it

source_mf() {
  source /tmp/methodfoundry.sh
  trap 'methodfoundry $BASH_COMMAND' DEBUG
}

generate_mf() {
  # generate function from template with run-time path calculation
  cat <<EOT > /tmp/methodfoundry.sh
  methodfoundry() { local cmd="\$1"
    shopt -u extdebug
    if ! \$(type -t \$cmd >/dev/null); then
      newcmd=\$(/usr/bin/env ruby __AUTOREPLACE__/methodfoundry.rb \$cmd)
      if [ -n "\$newcmd" ]; then
        echo "\$FUNCNAME: executing '\$newcmd' instead"
        eval \$newcmd
        shopt -s extdebug
        return 2
      else
        echo "\$FUNCNAME: no match found for \$cmd"
      fi
    fi
  }
EOT
  sed -i '' -e "s#__AUTOREPLACE__#${DIR}#" /tmp/methodfoundry.sh
}

install_mf() {
  echo 'installing MethodFoundry...'

  # source this file in .bashrc
  done_previously() { [ ! -z "$(grep source | grep $DIR | grep $(basename $0))" ]; }

  if ! $(<~/.bashrc done_previously) && ! $(<~/.bash_profile done_previously); then
    echo 'sourcing from .bashrc...'
    echo "source $DIR/$(basename $0)" >> ~/.bashrc
  fi

  echo 'done'
}

cleanup() {
  unset install_mf generate_mf source_mf cleanup done_previously SOURCE DIR
  rm /tmp/methodfoundry.sh
}

# find our absolute PATH
SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ] ; do SOURCE="$(readlink "$SOURCE")"; done
DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"

if [[ "$BASH_SOURCE" == "$0" ]]; then
  install_mf
else
  generate_mf
  source_mf
  cleanup
fi
