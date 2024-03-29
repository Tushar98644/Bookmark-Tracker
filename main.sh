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

echo "Now let's store all the bookmarks in a markdown file."

sleep 2

generate_output() {
echo "---"
echo "title: $1" 
echo "date: $(date +"%Y-%m-%d")" 
echo "description: Post description here."
echo "---"
echo
echo
echo 
if [ "$chrome_bookmarks" ]; then
  if [ -z "$chrome_bookmarks" ]; then
    echo "No bookmarks found"
  else
    echo "<h2>Chrome Bookmarks</h2>"
    for i in $(echo "$chrome_bookmarks" | jq -r '.roots | keys[]'); do
      echo "<ul>"
      for j in $(echo "$chrome_bookmarks" | jq -r ".roots.$i.children | keys[]"); do
        echo "<li>
           <a href=\"$(echo "$chrome_bookmarks" | jq -r ".roots.$i.children[$j].url")\" target=\"_blank\" rel=\"noopener\">$(echo "$chrome_bookmarks" | jq -r ".roots.$i.children[$j].name")</a>
        </li>"
      done
      echo "</ul>"
    done
  fi
fi
echo
echo
if [ "$brave_bookmarks" ]; then
  if [ -z "$brave_bookmarks" ]; then
    echo "No bookmarks found"
  else
    echo "<h2>Brave Bookmarks</h2>"
    for i in $(echo "$brave_bookmarks" | jq -r '.roots | keys[]'); do
      echo "<ul>"
      for j in $(echo "$brave_bookmarks" | jq -r ".roots.$i.children | keys[]"); do
        echo "<li>
           <a href=\"$(echo "$brave_bookmarks" | jq -r ".roots.$i.children[$j].url")\" target=\"_blank\" rel=\"noopener\">$(echo "$brave_bookmarks" | jq -r ".roots.$i.children[$j].name")</a>
        </li>"
      done
      echo "</ul>"
    done
  fi
fi
echo
echo
if [ "$firefox_bookmarks" ]; then
  if [ -z "$firefox_bookmarks" ]; then
    echo "No bookmarks found"
  else
    echo "<h2>Firefox Bookmarks</h2>"
    for i in $(echo "$firefox_bookmarks" | jq -r '.roots | keys[]'); do
      echo "<ul>"
      for j in $(echo "$firefox_bookmarks" | jq -r ".roots.$i.children | keys[]"); do
        echo "<li>
           <a href=\"$(echo "$firefox_bookmarks" | jq -r ".roots.$i.children[$j].url")\" target=\"_blank\" rel=\"noopener\">$(echo "$firefox_bookmarks" | jq -r ".roots.$i.children[$j].name")</a>
        </li>"
      done
      echo "</ul>"
    done
  fi
fi
echo
echo
if [ "$edge_bookmarks" ]; then
  if [ -z "$edge_bookmarks" ]; then
    echo "No bookmarks found"
  else
    echo "<h2>Edge Bookmarks</h2>"
    for i in $(echo "$edge_bookmarks" | jq -r '.roots | keys[]'); do
      echo "<ul>"
      for j in $(echo "$edge_bookmarks" | jq -r ".roots.$i.children | keys[]"); do
        echo "<li>
           <a href=\"$(echo "$edge_bookmarks" | jq -r ".roots.$i.children[$j].url")\" target=\"_blank\" rel=\"noopener\">$(echo "$edge_bookmarks" | jq -r ".roots.$i.children[$j].name")</a>
        </li>"
      done
      echo "</ul>"
    done
  fi
fi
}

markdown_file="bookmarks.md"
generate_output > "$markdown_file"