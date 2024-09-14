static const Block blocks[] = {
	{"┇  ", "xset -q|grep LED| awk '{ if (substr ($10,5,1) == 1) print \"[RU]\"; else print \"[EN]\"; }' &", 0, 1},
	{"  ", "free -h | awk '/^Mem:/{print $3}' | sed 's/Gi/ G/' &", 1, 0},
	{"  ", "cat /home/maaru/suckless/scripts/dwmbScripts/.currentsWather", 1, 0},
	{"    ", "cat /home/maaru/suckless/scripts/dwmbScripts/.currentInternet", 1, 0},
	{"  󰮯 ", "cat /home/maaru/suckless/scripts/dwmbScripts/.currentInfoUpDate", 1, 0},
	{"  ", "cat /home/maaru/suckless/scripts/dwmbScripts/.currentShowInternet", 1, 0},
	{"   ", "cat /home/maaru/suckless/scripts/dwmbScripts/.carrentsBattery", 1, 0},
        //  {" ", "curl -s 'wttr.in/Tashkent?format=%t'", 300, 0},
	{"  ", "date '+%H:%M' &", 1, 0},
	{"         ", "", 0,},
};
static char delim[] = "  ┇  ";
static unsigned int delimLen = 5;

