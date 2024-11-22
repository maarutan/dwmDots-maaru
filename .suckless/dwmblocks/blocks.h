static const Block blocks[] = {
	{"┇  ", "xset -q|grep LED| awk '{ if (substr ($10,5,1) == 1) print \"[RU]\"; else print \"[EN]\"; }' &", 0, 1},
	{"   ", "cat $HOME/.suckless/dwmblocks/dwmbScripts/.currentMemory", 1, 0},
	//{"  ", "cat $HOME/.suckless/dwmblocks/dwmbScripts/.currentsWather", 1, 0},
	{"    ", "cat $HOME/.suckless/dwmblocks/dwmbScripts/.currentInternet", 1, 0},
	{"  󰮯 ", "cat $HOME/.suckless/dwmblocks/dwmbScripts/.currentInfoUpDate", 1, 0},
	{"  ", "cat $HOME/.suckless/dwmblocks/dwmbScripts/.currentShowInternet", 1, 0},
	{"  ", "cat $HOME/.suckless/dwmblocks/dwmbScripts/.carrentsBattery", 1, 0},
	{"  ", "date '+%H:%M' &", 1, 0},
	{"        ", "", 0,},
	//{"  ", "", 0,},
};
static char delim[] = "  ┇  ";
static unsigned int delimLen = 5;

