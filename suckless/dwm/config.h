/* See LICENSE file for copyright and license details. */

/* appearance */
static const unsigned int borderpx = 5; /* border pixel of windows */
static const unsigned int snap = 32;	/* snap pixel */

static const unsigned int gappih = 20; /* horiz inner gap between windows */
static const unsigned int gappiv = 20; /* vert inner gap between windows */
static const unsigned int gappoh = 30; /* horiz outer gap between windows and screen edge */
static const unsigned int gappov = 30; /* vert outer gap between windows and screen edge */

static int smartgaps = 0;	  /* 1 means no outer gap when there is only one window */
static const int showbar = 1; /* 0 means no bar */
static const int topbar = 1;  /* 0 means bottom bar */

// bar paddings
static const int vertpad = 5;  /* vertical padding of bar */
static const int sidepad = 27; /* horizontal padding of bar */

static const char *fonts[] = {"Fira Code:size=20"};
static const char dmenufont[] = "Fira Code:size=20";
static const char col_gray1[] = "#222222";
static const char col_gray2[] = "#444444";
static const char col_gray3[] = "#bbbbbb";
static const char col_gray4[] = "#eeeeee";
static const char background[] = "#23243a";
static const char col_borderActive[] = "#8aadf4";
static const char col_noActive[] = "#868eba";
static const char background2[] = "#2f2f49";
static const char col_borderbar[] = "#292b40";

static const char *colors[][3] = {
	/*               fg         bg         border   */
	[SchemeNorm] = {
		col_gray3,
		background,
		col_noActive,
	},
	[SchemeSel] = {col_gray4, background2, col_borderActive},
};

/* tagging */
static const char *tags[] = {"󱍢", "", "󰈹", "", ""};

static const Rule rules[] = {
	/* xprop(1):
	 *	WM_CLASS(STRING) = instance, class
	 *	WM_NAME(STRING) = title
	 */
	/* class      instance    title       tags mask     isfloating   monitor */
	{"Gimp", NULL, NULL, 0, 1, -1},
	{"Firefox", NULL, NULL, 1 << 8, 0, -1},
};

/* layout(s) */
static const float mfact = 0.55;	 /* factor of master area size [0.05..0.95] */
static const int nmaster = 1;		 /* number of clients in master area */
static const int resizehints = 1;	 /* 1 means respect size hints in tiled resizals */
static const int lockfullscreen = 1; /* 1 will force focus on the fullscreen window */

#define FORCE_VSPLIT 1 /* nrowgrid layout: force two clients to always split vertically */
#include "vanitygaps.c"

static const Layout layouts[] = {
	/* symbol     arrange function */
	{"[@]", spiral},
	{"[]=", tile}, /* first entry is default */
	{"[M]", monocle},
	{"[\\]", dwindle},
	{"H[]", deck},
	{"TTT", bstack},
	{"===", bstackhoriz},
	{"HHH", grid},
	{"###", nrowgrid},
	{"---", horizgrid},
	{":::", gaplessgrid},
	{"|M|", centeredmaster},
	{">M>", centeredfloatingmaster},
	{"><>", NULL}, /* no layout function means floating behavior */
	{NULL, NULL},
};

/* key definitions */
#define MODKEY Mod4Mask
#define ALTKEY Mod1Mask
#define TAGKEYS(KEY, TAG)                                          \
	{MODKEY, KEY, view, {.ui = 1 << TAG}},                         \
		{MODKEY | ControlMask, KEY, toggleview, {.ui = 1 << TAG}}, \
		{MODKEY | ShiftMask, KEY, tag, {.ui = 1 << TAG}},          \
		{MODKEY | ControlMask | ShiftMask, KEY, toggletag, {.ui = 1 << TAG}},

/* helper for spawning shell commands in the pre dwm-5.0 fashion */
#define SHCMD(cmd)                                           \
	{                                                        \
		.v = (const char *[]) { "/bin/sh", "-c", cmd, NULL } \
	}

/* commands */
static char dmenumon[2] = "0"; /* component of dmenucmd, manipulated in spawn() */
static const char *dmenucmd[] = {
	"dmenu_run", "-m", dmenumon, "-fn", dmenufont,
	"-nb", col_gray1, "-nf", col_gray3,
	"-sb", col_borderActive, "-sf", col_gray4, NULL};
static const char *termcmd[] = {"kitty", NULL};
static const char *browser[] = {"firefox", NULL};
static const char *codeEditor[] = {"code", NULL};

/* volume */
static const char *volup[] = SHCMD("$HOME/suckless/scripts/volume.sh up");
static const char *voldown[] = SHCMD("$HOME/suckless/scripts/volume.sh down");
static const char *volmute[] = SHCMD("$HOME/suckless/scripts/volume.sh mute");

/* brightness */
static const char *brgup[] = SHCMD("$HOME/suckless/scripts/brightnessControl.sh up");
static const char *brgdown[] = SHCMD("$HOME/suckless/scripts/brightnessControl.sh down");

/* wallpapers */
static const char *walL[] = SHCMD("$HOME/suckless/scripts/change_wallpaper.sh left");
static const char *walR[] = SHCMD("$HOME/suckless/scripts/change_wallpaper.sh right");

#include "movestack.c"

static const Key keys[] = {
	/* modifier                     key        function        argument */

	// dmenu ------------------------
	{0, 0, spawn, {.v = dmenucmd}},

	// kitty ------------------------
	{MODKEY, XK_Return, spawn, {.v = termcmd}},

	// killActive ------------------------
	{MODKEY, XK_q, killclient, {0}},

	// firefox
	{MODKEY | ShiftMask, XK_f, spawn, {.v = browser}},

	// vesktop
	{MODKEY | ShiftMask, XK_v, spawn, SHCMD("vesktop")},

	// vscode
	{MODKEY, XK_c, spawn, {.v = codeEditor}},

	// toggleBar ------------------------
	{MODKEY | ShiftMask, XK_t, spawn, SHCMD("telegram-desktop")},

	// update system
	{MODKEY | ControlMask, XK_u, spawn, SHCMD("kitty -e $HOME/suckless/scripts/update.sh")},

	// signal dwmblocks change keyboard
	{ControlMask, 0xffe9, spawn, SHCMD("pkill -RTMIN+1 dwmblocks")},

	// rofi
	{MODKEY, XK_r, spawn, SHCMD("$HOME/.config/rofi/launchers/type-2/launcher.sh")},
	{MODKEY, XK_v, spawn, SHCMD("$HOME/suckless/scripts/buferRofi.sh")},
	{MODKEY | Mod1Mask, XK_a, spawn, SHCMD("$HOME/.config/rofi/launchers/type-2/emoji.sh")},
	{MODKEY | ShiftMask, XK_p, spawn, SHCMD("$HOME/.config/rofi/powermenu/type-2/powermenu.sh")},

	// color picker
	{MODKEY | ALTKEY, XK_p, spawn, SHCMD("xcolor -s clipboard")},

	// settings
	{MODKEY, XK_i, spawn, SHCMD("kitty -e $HOME/suckless/dwm")},

	// file manager
	{MODKEY, XK_e, spawn, SHCMD("kitty -e yazi")},

	// screen shot
	{MODKEY, XK_p, spawn, SHCMD("flameshot gui")},

	// wallpapers control
	{MODKEY | ControlMask, 0x5b, spawn, {.v = walL}},
	{MODKEY | ControlMask, 0x5d, spawn, {.v = walR}},

	/* Управление Яркостью */
	{MODKEY | ShiftMask, 0x5b, spawn, {.v = brgup}},
	{MODKEY | ShiftMask, 0x5d, spawn, {.v = brgdown}},

	/* Управление Громкостью */
	{MODKEY, 0x5b, spawn, {.v = volup}},
	{MODKEY, 0x5d, spawn, {.v = voldown}},
	{MODKEY, 0x5c, spawn, {.v = volmute}},

	// toggleBar ------------------------
	{MODKEY | ShiftMask, XK_w, togglebar, {0}},

	// focusStack ------------------------
	{MODKEY | ShiftMask, XK_j, focusstack, {.i = +1}},
	{MODKEY | ShiftMask, XK_k, focusstack, {.i = -1}},
	{MODKEY | ShiftMask, XK_m, focusstack, {.i = +1}},

	// moveWindow ------------------------
	{MODKEY | ShiftMask, XK_h, movestack, {.i = -1}},
	{MODKEY | ShiftMask, XK_l, movestack, {.i = +1}},

	// changeMaster ------------------------
	{MODKEY | ShiftMask, XK_Return, zoom, {0}},
	{MODKEY, XK_Tab, view, {0}},
	{MODKEY | ShiftMask, XK_space, togglefloating, {0}},
	{MODKEY | ShiftMask, XK_x, killclient, {0}},

	// tag
	TAGKEYS(XK_1, 0)
		TAGKEYS(XK_2, 1)
			TAGKEYS(XK_3, 2)
				TAGKEYS(XK_4, 3)
					TAGKEYS(XK_5, 4)
						TAGKEYS(XK_6, 5)
							TAGKEYS(XK_7, 6)
								TAGKEYS(XK_8, 7)
									TAGKEYS(XK_9, 8)

	// switch layouts
	{MODKEY, XK_space, setlayout, {.v = &layouts[0]}},
	{MODKEY | ShiftMask, XK_space, setlayout, {.v = &layouts[1]}},
	{MODKEY | ShiftMask, XK_Tab, setlayout, {.v = &layouts[2]}},

	// kill client
	{MODKEY | ShiftMask, XK_q, killclient, {0}},
};

/* button definitions */
static const Button buttons[] = {
	/* click                 event mask   button          function        argument */
	{ClkLtSymbol, 0, Button1, setlayout, {0}},
	{ClkWinTitle, 0, Button2, zoom, {0}},
	{ClkStatusText, 0, Button2, spawn, {.v = termcmd}},
	{ClkStatusText, 0, Button1, spawn, {.v = dmenucmd}},
	{ClkClientWin, MODKEY, Button1, movemouse, {0}},
	{ClkClientWin, MODKEY, Button2, togglefloating, {0}},
	{ClkClientWin, MODKEY, Button3, resizemouse, {0}},
	{ClkTagBar, 0, Button1, view, {0}},
	{ClkTagBar, 0, Button3, toggleview, {0}},
	{ClkTagBar, MODKEY, Button1, tag, {0}},
	{ClkTagBar, MODKEY, Button3, toggletag, {0}},
};
