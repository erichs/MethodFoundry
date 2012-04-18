#!/bin/bash

# Extensible #method_missing for bash
load_source() {
  method_missing() { local cmd=$1
    shopt -u extdebug
    if ! $(type -t $cmd >/dev/null); then
      newcmd=$(~/conf/methodfoundry.rb $cmd)
      if [ -n "$newcmd" ]; then
        echo "$FUNCNAME: executing '$newcmd' instead"
        eval $newcmd
        shopt -s extdebug
        return 2
      else
        echo "$FUNCNAME: no match found for $cmd"
      fi
    fi
  }

  trap 'method_missing $BASH_COMMAND' DEBUG
}

install() {
  echo 'installing MethodFoundry...'

  # find our absolute PATH
  SOURCE="${BASH_SOURCE[0]}"
  while [ -h "$SOURCE" ] ; do SOURCE="$(readlink "$SOURCE")"; done
  DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"

  # source this file in .bashrc
  done_previously() { [ ! -z "$(grep source | grep $DIR | grep $(basename $0))" ]; }

  if ! $(<~/.bashrc done_previously) && ! $(<~/.bash_profile done_previously); then
    echo 'sourcing from .bashrc...'
    echo "source $DIR/$(basename $0)" >> ~/.bashrc
  fi

  echo 'done'
}

if [[ "$BASH_SOURCE" == "$0" ]]; then
  install
else
  load_source
  unset install
  unset load_source
fi
