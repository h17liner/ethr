#!/bin/bash

_script_path=$(dirname $0)

# const
VENV=".venv"

# import helpers
source $(realpath -e $_script_path/helper.sh)

check_python_3version() {
    echo  "checking python version"

    version=$(python -c 'import platform; print(platform.python_version())')
    version=$(echo "${version//./}" | cut -c -3)
    if [[ "$version" -lt "300" ]]
    then 
        fail "python version must be great then 3"
        exit 1
    fi

    ok
}


venv_active() {
    echo  "activate virtualenv"

    _venv=$1
    if [ ! -f $_venv/bin/python ]; then
        echo  " create virtualenv"
        virtualenv .venv
    fi 
    source .venv/bin/activate
    
    ok
}



check_python_3version
venv_active $VENV


echo  "install packages from requirements.txt"
pip install -U -r $(realpath -e $_script_path/../requirements.txt)

ok