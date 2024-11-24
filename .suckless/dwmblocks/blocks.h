static const Block blocks[] = {
	{"┇  "  , "xset -q|grep LED| awk '{ if (substr ($10,5,1) == 1) print \"[RU]\"; else print \"[EN]\"; }' &", 0, 1},
	{"   " , "cat $HOME/.suckless/scripts/dwmbScripts/.memory_state", 1, 0},
	{"  " , "cat $HOME/.suckless/scripts/dwmbScripts/.currentsWather", 1, 0},
	{"    ", "cat $HOME/.suckless/scripts/dwmbScripts/.currentInternet", 1, 0},
	{"  󰮯 " , "cat $HOME/.suckless/scripts/dwmbScripts/.currentInfoUpDate", 1, 0},
	{"  "   , "cat $HOME/.suckless/scripts/dwmbScripts/.currentShowInternet", 1, 0},
	{"  "   , "cat $HOME/.suckless/scripts/dwmbScripts/.carrentsBattery", 1, 0},
	{"  "   , "date '+%H:%M' &", 1, 0},
	{"        ", "", 0,},
	//{"  ", "", 0,},
};
static char delim[] = "  ┇  ";
static unsigned int delimLen = 5;

