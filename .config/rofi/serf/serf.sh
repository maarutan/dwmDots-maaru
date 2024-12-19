#
# ███████╗███████╗██████╗ ███████╗    ██████╗  ██████╗ ███████╗██╗
# ██╔════╝██╔════╝██╔══██╗██╔════╝    ██╔══██╗██╔═══██╗██╔════╝██║
# ███████╗█████╗  ██████╔╝█████╗      ██████╔╝██║   ██║█████╗  ██║
# ╚════██║██╔══╝  ██╔══██╗██╔══╝      ██╔══██╗██║   ██║██╔══╝  ██║
# ███████║███████╗██║  ██║██║         ██║  ██║╚██████╔╝██║     ██║
# ╚══════╝╚══════╝╚═╝  ╚═╝╚═╝         ╚═╝  ╚═╝ ╚═════╝ ╚═╝     ╚═╝
#
#
#!/usr/bin/env bash
#
DEFAULT_PLATFORM="duckduckgo"  # Set the default platform (e.g., google, duckduckgo, list)
DEFAULT_BROWSER="xdg-open"     # Set the browser: firefox, brave, google-chrome, or leave as xdg-open.
HISTORY_FILE="$HOME/.config/rofi/serf/.history.txt"
THEME_FILE="$HOME/.config/rofi/serf/config.rasi"
#
declare -A URLS
#
URLS=(
  ["google"]="https://www.google.com/search?q="
  ["bing"]="https://www.bing.com/search?q="
  ["yahoo"]="https://search.yahoo.com/search?p="
  ["duckduckgo"]="https://www.duckduckgo.com/?q="
  ["yandex"]="https://yandex.ru/yandsearch?text="
  ["github"]="https://github.com/search?q="
  ["goodreads"]="https://www.goodreads.com/search?q="
  ["stackoverflow"]="http://stackoverflow.com/search?q="
  ["symbolhound"]="http://symbolhound.com/?q="
  ["searchcode"]="https://searchcode.com/?q="
  ["openhub"]="https://www.openhub.net/p?ref=homepage&search="
  ["superuser"]="http://superuser.com/search?q="
  ["askubuntu"]="http://askubuntu.com/search?q="
  ["imdb"]="http://www.imdb.com/find?ref_=nv_sr_fn&q="
  ["rottentomatoes"]="https://www.rottentomatoes.com/search/?search="
  ["piratebay"]="https://thepiratebay.org/search/"
  ["youtube"]="https://www.youtube.com/results?search_query="
  ["vimawesome"]="http://vimawesome.com/?q="
  ["aur"]="https://aur.archlinux.org/packages/?K="
)
#
[ ! -f "$HISTORY_FILE" ] && touch "$HISTORY_FILE"
#
check_browser_support() {
  if "$DEFAULT_BROWSER" --new-tab "about:blank" &>/dev/null; then
    echo "supports_new_tab"
  else
    echo "no_new_tab_support"
  fi
}
#
gen_list() {
  for i in $(echo "${!URLS[@]}" | tr ' ' '\n' | sort); do
    echo "$i"
  done
}
#
open_search() {
  local platform="$1"
  local search="$2"
  local url="${URLS[$platform]}$search"
#
  echo "$search" >> "$HISTORY_FILE"
  sort -u -o "$HISTORY_FILE" "$HISTORY_FILE"
#
  if [[ "$DEFAULT_BROWSER" == "firefox" ]] || [[ "$(check_browser_support)" == "supports_new_tab" ]]; then
    "$DEFAULT_BROWSER" --new-tab "$url" &>/dev/null &
  else
    "$DEFAULT_BROWSER" "$url" &>/dev/null &
  fi
}
#
get_search() {
  search=$( (cat "$HISTORY_FILE"; echo "/list"; echo "/remove") | rofi -dmenu -matching fuzzy -p " Search > " -theme "$THEME_FILE" )
  echo "$search"
}
#
main() {
  trap "notify-send 'Web Search' 'Exiting search.' -u low; exit 0" SIGINT SIGTERM
#
  search=$(get_search)
#
  if [[ "$search" == "/list" ]]; then
    platform=$( (gen_list) | rofi -dmenu -matching fuzzy -no-custom -p " Search Platform > " -theme "$THEME_FILE" )
    if [[ -n "$platform" && -n "${URLS[$platform]}" ]]; then
      search=$( (echo ) | rofi -dmenu -matching fuzzy -p " Enter search > " -theme "$THEME_FILE" )
      if [[ -n "$search" ]]; then
        open_search "$platform" "$search"
      else
        notify-send "Web Search" "No search entered!" -u critical
      fi
    else
      notify-send "Web Search" "No platform selected or invalid choice!" -u critical
    fi
  elif [[ "$search" == "/remove" ]]; then
    > "$HISTORY_FILE"
    notify-send "Web Search" "Search history cleared." -u low
  elif [[ -n "$search" ]]; then
    open_search "$DEFAULT_PLATFORM" "$search"
  else
    notify-send "Web Search" "No search entered!" -u critical
  fi
}
#
main
