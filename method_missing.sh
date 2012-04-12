# Method missing for bash. Add to your .bashrc

method_missing() { local cmd=$1
    shopt -u extdebug
    if ! $(type -t $cmd >/dev/null); then
        newcmd=$(~/conf/matchfactory.rb $cmd)
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
