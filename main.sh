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
    if [ -d "$1" ]
    then
        echo "$2 is installed"
        installed_browsers+=("$2")  
    fi
}

case "$OS" in
  "Mac OS")
    chrome_directory="$HOME/Library/Application Support/Google/Chrome/Default"
    brave_directory="$HOME/Library/Application Support/BraveSoftware/Brave-Browser/Default"
    firefox_directory="$HOME/Library/Application Support/Firefox/Profiles"
    ;;
  "LINUX")
    chrome_directory="$HOME/.config/google-chrome/Default"
    brave_directory="$HOME/.config/BraveSoftware/Brave-Browser/Default"
    firefox_directory="$HOME/.mozilla/firefox"
    ;;
  "WINDOWS" | "ALSO WINDOWS")
    chrome_directory=""
    brave_directory=""
    firefox_directory=""
    edge_directory=""
    ;;
  *)
    echo "Unsupported operating system: $OS"
    exit 1
    ;;
esac

check_browser "$chrome_directory" "Google Chrome"
check_browser "$brave_directory" "Brave"
check_browser "$firefox_directory" "Firefox"
check_browser "$edge_directory" "Edge"

sleep 2 

echo "I have identified the browsers you have installed. Now, let's move on to the next step."

sleep 1

echo "I will look for the bookmarks in each of the browsers."

sleep 1

fetch_bookmarks() {
  case "$1" in
    "Google Chrome")
      chrome_bookmarks=$(cat "$chrome_directory/Bookmarks")
      ;;
    "Brave")
      brave_bookmarks=$(cat "$brave_directory/Bookmarks")
      ;;
    "Firefox")
      firefox_bookmarks=$(cat "$firefox_directory/places.sqlite")
      ;;
    "Edge")
      edge_bookmarks=$(cat "$edge_directory/Bookmarks")
      ;;
    *)
      echo "Unsupported browser: $1"
      exit 1
      ;;
  esac
}

echo "I will start with $installed_browsers"

for browser in "${installed_browsers[@]}"
do
  echo "Fetching all bookmarks for $browser" 
  fetch_bookmarks "$browser"
  echo "All bookmarks for $browser have been fetched successfully. Moving on to the next browser."
done

echo "All bookmarks for all the browsers have been fetched successfully."

sleep 2