#!/bin/bash

# this script assumes that vimrc is already configured to use pathogen and
# the plugins in the plugin list.

BASE_VIM=$HOME/.vim
BUNDLE_DIRECTORY=$BASE_VIM/bundle
DEFAULT_PLUGIN_FILE=./vim_plugins
plugin_file=$1

usage() { echo "Usage: $0 [-f filename" >&2; exit 1; }

while getopts :f:h opt; do
    case $opt in
        f)
            echo "Loading plugins from $2"
            plugin_file=$2
            shift; shift;
            ;;
        \?)
            echo "Invalid option: -$OPTARG" >&2
            exit 1
            ;;
        *)
            usage
            ;;
    esac
done

# Function to install a vim plugin
fetch_and_install_plugin() {
    plugin_name=$1
    repo=$2
    
    pushd $DEFAULT_BUNDLE_DIRECTORY

    git clone $2
    if [[ $? -ne 0 ]]; then
        printf "Failed to fetch $plugin_name from $repo\n" > 2
        popd
        return 1
    fi

    if [[ $# -eq 3 ]]; then
        ref=$3
        git checkout $ref
        if [[ $? -ne 0 ]]; then
            printf "Failed to checkout $plugin_name to $ref\n" > 2
            return 1
        fi
    fi
    popd
    return 0
}

# Install pathogen
if [[ ! -f $HOME/.vim/autoload/pathogen.vim ]]; then 
    mkdir -p $HOME/.vim/autoload $HOME/.vim/bundle && curl -LSso $HOME/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
fi

# Install plugins
while IFS='' read -r line || [[ -n "$line" ]]; do
    # skip comments
    if [[ ${line::1} = "#" ]]; then
        continue
    fi
    args=$(echo $line | tr ',' ' ')
    fetch_and_install_plugin $args

done < "$DEFAULT_PLUGIN_FILE"
