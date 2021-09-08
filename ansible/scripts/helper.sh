# helpers func
red ()    { printf "\033[0;31m${1}\033[0m\n"; }
green ()  { printf "\033[0;32m${1}\033[0m\n"; }
yellow () { printf "\033[0;33m${1}\033[0m\n"; }
blue ()   { printf "\033[0;34m${1}\033[0m\n"; }
purple () { printf "\033[0;35m${1}\033[0m\n"; }
cyan ()   { printf "\033[0;36m${1}\033[0m\n"; }


ok ()  { green "    Ok."; }
fail() { red   "    Fail. $1"; }
