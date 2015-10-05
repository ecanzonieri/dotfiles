#!/bin/bash
# A utility to do more env setup using the given file.
# Expect ENVSETUP to be properly defined.


ENVSETUP="/Users/enrico/.bash_commons"
SOURCE_LOG="~/.mysourcelog"
sourceFrom () {
   base_file="$1"; shift
   source_file="${ENVSETUP}/${base_file}";
   if [ -f "${source_file}" ]; then
       # If an optional message was given, print it first.
       [[ $# -gt 0 ]] && { printf "$1\n"; shift; }

       . ${source_file}
       export SOURCE_LOG="${SOURCE_LOG}:${base_file}"
       return 0
   else
       printf "Source $source_file not found"
       return 1
   fi

   # Note that if the file does not exist, no action is taken (silently).
   # Only the return value indicates that action was done.
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# http://dotslashstar.blogspot.com/2011/10/shell-trick-dynamic-bashrc-setup.html

# Special environmental & shell related setup are defined here
sourceFrom bashrc-common-shell

# Common aliases are defined externally.
sourceFrom bashrc-common-aliases

# Common Functions are defined externally.
sourceFrom bashrc-common-functions

## Platform-specific setup
printf "Bourne Again Shell "
#os=$(uname -s)
#case ${os} in
#   Linux)
#       sourceFrom bashrc-os-linux "on Linux.";;
#   SunOS)
#       sourceFrom bashrc-os-sunos "on SunOS.";;
#   CYGWIN_NT-5.1)
#       sourceFrom bashrc-os-win "on Windows XP.";;
#   CYGWIN_NT-5.0)
#       sourceFrom bashrc-os-win "on Windows 2000.";;
#   CYGWIN_NT-4.0)
#       sourceFrom bashrc-os-win "on Windows NT.";;
#   *)
#       printf "Unknown OS: %s\n" "${os}"
#esac

# host-specific setup
sourceFrom "bashrc-host-${HOSTNAME%.*}" "Customization for host: ${HOSTNAME%.*}"

# Final processing after OS-specific and host-specific setup.
sourceFrom bashrc-common-final
