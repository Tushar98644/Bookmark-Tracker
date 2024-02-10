#!/bin/bash

echo "Hello there! I am scripi, a simple shell script manager. I will help you along the process. Let's get started!"

sleep 2

case "$OSTYPE" in
  solaris*) OS="SOLARIS" ;;
  darwin*)  OS="Mac OS" ;; 
  linux*)   OS="LINUX" ;;
  bsd*)     OS="BSD" ;;
  msys*)    OS="WINDOWS" ;;
  cygwin*)  OS="ALSO WINDOWS" ;;
  *)        OS="unknown: $OSTYPE" ;;
esac

echo "I can see that the operating system you are using is : $OS"

sleep 1

echo "First things first, let's identify all the browsers you have installed."

sleep 1

check_browser() {
    if [ -d "$1" ]; then
        echo "$2 is installed"        
    fi
}

chrome_directory="$HOME/Library/Application Support/Google/Chrome/Default"
check_browser "$chrome_directory" "Google Chrome"
check_browser "/Applications/Firefox.app" "Firefox"
check_browser "/Applications/Microsoft Edge.app" "Microsoft Edge"