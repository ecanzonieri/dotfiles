#!/bin/bash

# Slightly modified version of http://dotslashstar.blogspot.com/2011/10/shell-trick-dynamic-bashrc-setup.html
# A utility to do more env setup using the given file.
# Expect ENVSETUP to be properly defined.
ENVSETUP="$HOME/.bash_commons"
SOURCED_FILES=""
sourceFrom () {
   base_file="$1"; shift
   source_file="${ENVSETUP}/${base_file}";
   if [ -f "${source_file}" ]; then
       # If an optional message was given, print it first.
       [[ $# -gt 0 ]] && { printf "$1\n"; shift; }

       . ${source_file}
       export SOURCED_FILES="${SOURCED_FILES}:${base_file}"
       return 0
   else
       printf "Source $source_file not found\n"
       return 1
   fi
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Check interactive and apply bashrc files
if [[ -n "${PS1}" ]]; then 
    # Special environmental & shell related setup are defined here
    sourceFrom bashrc-common-shell

    # Common aliases are defined externally.
    sourceFrom bashrc-common-aliases

    # Common Functions are defined externally.
    sourceFrom bashrc-common-functions

    ## Platform-specific setup
    printf "Bourne Again Shell \n"
    os=$(uname -s)
    case ${os} in
       Linux)
           sourceFrom bashrc-os-linux "on Linux.";;
       Darwin)
           sourceFrom bashrc-os-macos "on SunOS.";;
       *)
           printf "Unknown OS: %s\n" "${os}"
    esac

    # host-specific setup
    sourceFrom "bashrc-host-${HOSTNAME%.*}" "Customization for host: ${HOSTNAME%.*}"

    # Final processing after OS-specific and host-specific setup.
    sourceFrom bashrc-common-final
fi
