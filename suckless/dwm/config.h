/* See LICENSE file for copyright and license details. */

/* appearance */
static const unsigned int borderpx   = 4;        /* border pixel of windows */
static const unsigned int snap       = 0;       /* snap pixel */

//systray
static const unsigned int systraypinning = 1;   /* 0: sloppy systray follows selected monitor, >0: pin systray to monitor X */
static const unsigned int systrayonleft = 1;    /* 0: systray in the right corner, >0: systray on left of status text */
static const unsigned int systrayspacing = 12;   /* systray spacing */
static const int systraypinningfailfirst = 1;   /* 1: if pinning fails, display systray on the first monitor, False: display systray on the last monitor*/
static const int showsystray        = 1;        /* 0 means no systray */

static const unsigned int gappiv     = 13;       /* vert inner gap between windows */
static const unsigned int gappih     = 13;       /* horiz inner gap between windows */
static const unsigned int gappoh     = 13;       /* horiz outer gap between windows and screen edge */
static const unsigned int gappov     = 13;       /* vert outer gap between windows and screen edge */

static       int smartgaps           = 0;        /* 1 means no outer gap when there is only one window */
static const int showbar             = 1;        /* 0 means no bar */
static const int topbar              = 1;        /* 0 means bottom bar */

//bar paddings
static const int vertpad             = 13;       /* vertical padding of bar */
static const int sidepad             = 7;       /* horizontal padding of bar */

//static const char *fonts[]         = { "FiraCode Nerd Font:size=16","Font Awesome 6 Free Solid:size=16","Fira Code:size=16" };
static const char *fonts[]           = { "FiraCode Nerd Font:size=14" };
static const char dmenufont[]        = "Fira Code :size=15" ;
static const char col_gray1[]        = "#222222";
static const char col_gray2[]        = "#444444";
static const char col_gray3[]        = "#bbbbbb";
static const char col_gray4[]        = "#eeeeee";
static const char background[]       = "#1e1e2e";
static const char col_borderActive[] = "#8aadf4";
static const char col_noActive[]     = "#868eba";
static const char background2[]      = "#2f2f49";


static const char *colors[][3]       = {
	/*               fg         bg         border   */
	[SchemeNorm] = { col_gray3, background, col_noActive, },
	[SchemeSel]  = { col_gray4, background2 , col_borderActive },
};

/* tagging */
static const char *tags[] = {   " 󱍢 ", "  ", " 󰈹 ", "  ", " 󰣇 ", "  ", "  ", "  ", "  " };
//static const char *tags[] = {  "1",  "2",  "3",  "4",  "5",  "6",  "7",  "8",  "9" };

static const Rule rules[] = {
	/* xprop(1):
	 *	WM_CLASS(STRING) = instance, class
	 *	WM_NAME(STRING) = title
	 */
	/* class      instance    title       tags mask     isfloating   monitor */
	{ "firefox",          NULL, NULL, 1 << 2, 0, -1 },
    { "telegram-desktop", NULL, NULL, 1 << 3, 0, -1 },
    { "TelegramDesktop",  NULL, NULL, 1 << 3, 0, -1 },
    { "kitty", NULL, "neofetch_terminal", 1 << 0, 0, -1 },



};

/* layout(s) */
static const float mfact     = 0.55; /* factor of master area size [0.05..0.95] */
static const int nmaster     = 1;    /* number of clients in master area */
static const int resizehints = 1;    /* 1 means respect size hints in tiled resizals */
static const int lockfullscreen = 1; /* 1 will force focus on the fullscreen window */

#define FORCE_VSPLIT 1  /* nrowgrid layout: force two clients to always split vertically */
#include "vanitygaps.c"

static const Layout layouts[] = {
	/* symbol     arrange function */
	{ "[@]",      spiral },
	{ "[]=",      tile },    /* first entry is default */
	{ "[M]",      monocle },
	{ "[\\]",     dwindle },
	{ "H[]",      deck },
	{ "TTT",      bstack },
	{ "===",      bstackhoriz },
	{ "HHH",      grid },
	{ "###",      nrowgrid },
	{ "---",      horizgrid },
	{ ":::",      gaplessgrid },
	{ "|M|",      centeredmaster },
	{ ">M>",      centeredfloatingmaster },
	{ "><>",      NULL },    /* no layout function means floating behavior */
	{ NULL,       NULL },
};
/* key definitions */
#define MODKEY Mod4Mask
#define ALTKEY Mod1Mask
#define TAGKEYS(KEY,TAG) \
	{ MODKEY,                       KEY,      view,           {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask,           KEY,      toggleview,     {.ui = 1 << TAG} }, \
	{ MODKEY|ShiftMask,             KEY,      tag,            {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask|ShiftMask, KEY,      toggletag,      {.ui = 1 << TAG} },

/* helper for spawning shell commands in the pre dwm-5.0 fashion */
#define SHCMD(cmd) { .v = (const char*[]){ "/bin/sh", "-c", cmd, NULL } }



/* commands */
static char dmenumon[2] = "0"; /* component of dmenucmd, manipulated in spawn() */
static const char *dmenucmd[] = { "dmenu_run", "-m", dmenumon, "-fn", dmenufont, "-nb", col_gray1, "-nf", col_gray3, "-sb", col_borderActive, "-sf", col_gray4, NULL };
static const char *termcmd[]  = { "kitty", NULL };
static const char *browser[]  = { "firefox", NULL };
static const char *codeEditor[]  = { "code", NULL };


/* volume */
static const char *volup[]   = { "/home/maaru/suckless/scripts/volume.sh", "up", NULL };
static const char *voldown[] = { "/home/maaru/suckless/scripts/volume.sh", "down", NULL };
static const char *volmute[] = { "/home/maaru/suckless/scripts/volume.sh", "mute", NULL };

/*brightness*/
static const char *brgup[]   = { "/home/maaru/suckless/scripts/brightnessControl.sh", "up", NULL };
static const char *brgdown[] = { "/home/maaru/suckless/scripts/brightnessControl.sh", "down", NULL };

/* wallpapers */
static const char *walL[] = { "/home/maaru/suckless/scripts/change_wallpaper.sh", "left", NULL };
static const char *walR[] = { "/home/maaru/suckless/scripts/change_wallpaper.sh", "right", NULL };


#include "movestack.c"

static const Key keys[] = {
	/* modifier                     key        function        argument */

	//dmenu ------------------------
	{ 0,                            0,      spawn,          {.v = dmenucmd } },

	//kitty ------------------------
	{ MODKEY,                      XK_Return, spawn,          {.v = termcmd } },
	
    //clock
	{ MODKEY|ALTKEY,            XK_c,      spawn,          SHCMD("/home/maaru/suckless/scripts/clock.sh") },

    //killActive ------------------------
	{ MODKEY,                      XK_q,      killclient,     {0} },

	//firefoox
	{ MODKEY|ShiftMask,            XK_f,      spawn,          {.v = browser } },

	//vesktop
	{ MODKEY|ShiftMask,            XK_v,      spawn,          SHCMD("vesktop") },

	//vscode
	{ MODKEY|ShiftMask,                      XK_c,      spawn,          {.v = codeEditor } },
	
	//toggleBar ------------------------
	{ MODKEY|ShiftMask,            XK_t,      spawn,          SHCMD("telegram-desktop") },


	//update system
	{ MODKEY|ControlMask,		       XK_u,            spawn,          SHCMD("kitty -e  /home/maaru/suckless/scripts/update.sh")},

    //reload keyboard
    { MODKEY|ShiftMask, XK_k, spawn, SHCMD("setxkbmap -layout us,ru -option 'grp:ctrl_alt_toggle' -option 'ctrl:nocaps'") },


	//signal dwmblocks change keyboard
	{ ControlMask,     		         0xffe9,          spawn,          SHCMD("pkill -RTMIN+1 dwmblocks && /home/maaru/suckless/scripts/changeKeyboard.sh")},
	

	//rofi
	{ MODKEY,                       XK_a,      spawn,          SHCMD("/home/maaru/.config/rofi/launchers/type-2/launcher.sh") },
    { MODKEY,                       XK_r,      spawn,          SHCMD("/home/maaru/.config/rofi/launchers/type-3/launcher_1.sh") },
	{ MODKEY,                       XK_v,      spawn,          SHCMD("/home/maaru/suckless/scripts/buferRofi.sh") },
	{ MODKEY|Mod1Mask,              XK_a,      spawn,          SHCMD("/home/maaru/.config/rofi/launchers/type-2/emoji.sh") },
	{ MODKEY|ShiftMask,             XK_p,      spawn,          SHCMD("/home/maaru/.config/rofi/powermenu/type-2/powermenu.sh") },


	//colorpicer
	{ MODKEY|ALTKEY,   		     				  	XK_p,      spawn,          SHCMD("xcolor -s clipboard") },

	//settings 
	{ MODKEY,                       XK_i,      spawn,          SHCMD("kitty -e /home/maaru/suckless/dwm") },


	//filemanager
	{ MODKEY,                       XK_e,      spawn,          SHCMD("kitty -e yazi") },

	//screen shot
	{ MODKEY,                       XK_p,      spawn,          SHCMD("flameshot gui") },
	
	//wallpapers control
	{ MODKEY|ControlMask,	 		0x5b, 	   spawn,	   	 {.v = walL } },   
  { MODKEY|ControlMask, 			0x5d, 	   spawn, 	   {.v = walR } },  

	/* Управление Ярсотью */
	{ MODKEY|ShiftMask, 		0x5b, 	   spawn,	   {.v = brgup   } },   
  { MODKEY|ShiftMask, 		0x5d, 	   spawn, 	   {.v = brgdown } },

  /* Управление Громкостью */
  { MODKEY, 			0x5b, 	   spawn,	   {.v = volup   } },   
  { MODKEY, 			0x5d,      spawn,	   {.v = voldown } },  
  { MODKEY, 			0x5c,      spawn,	   {.v = volmute } },
	
  // move flouting window
	{ MODKEY,                       XK_j,     moveresize,     {.v = "0x 25y 0w 0h" } },
	{ MODKEY,                       XK_k,     moveresize,     {.v = "0x -25y 0w 0h" } },
	{ MODKEY,                       XK_l,     moveresize,     {.v = "25x 0y 0w 0h" } },
	{ MODKEY,                       XK_h,     moveresize,     {.v = "-25x 0y 0w 0h" } },
 
  //resize flouting widnow
	{ MODKEY|ShiftMask|ALTKEY,             XK_j,     moveresize,     {.v = "0x 0y 0w 25h" } },
	{ MODKEY|ShiftMask|ALTKEY,             XK_k,     moveresize,     {.v = "0x 0y 0w -25h" } },
	{ MODKEY|ShiftMask|ALTKEY,             XK_l,     moveresize,     {.v = "0x 0y 25w 0h" } },
	{ MODKEY|ShiftMask|ALTKEY,             XK_h,     moveresize,     {.v = "0x 0y -25w 0h" } },

  // move flouting window ALTKEY
	{ MODKEY|ControlMask,           XK_k,   moveresizeedge, {.v = "t"} },
	{ MODKEY|ControlMask,           XK_j,   moveresizeedge, {.v = "b"} },
	{ MODKEY|ControlMask,           XK_h,   moveresizeedge, {.v = "l"} },
	{ MODKEY|ControlMask,           XK_l,   moveresizeedge, {.v = "r"} },
 
  //move flouting wondow
	{ MODKEY|ControlMask|ShiftMask, XK_k,   moveresizeedge, {.v = "T"} },
	{ MODKEY|ControlMask|ShiftMask, XK_j,   moveresizeedge, {.v = "B"} },
	{ MODKEY|ControlMask|ShiftMask, XK_h,   moveresizeedge, {.v = "L"} },
	{ MODKEY|ControlMask|ShiftMask, XK_l,   moveresizeedge, {.v = "R"} },


	//toggleBar ------------------------
	{ MODKEY|ShiftMask,               XK_w,      togglebar,      {0} },

	//focusStack ------------------------
	{ MODKEY|ShiftMask,               XK_j,      focusstack,     {.i = +1 } },
	{ MODKEY|ShiftMask,               XK_k,      focusstack,     {.i = -1 } },
	{ MODKEY|ShiftMask, 		          XK_h,	     setmfact,	     {.f = -0.05} },
	{ MODKEY|ShiftMask,               XK_l,      setmfact,       {.f = +0.05} },


	// tileStack modes I, D ------------------------
	{ MODKEY,                       XK_i,      incnmaster,     {.i = +1 } },
	{ MODKEY,                       XK_d,      incnmaster,     {.i = -1 } },
	
	//MoveStack ------------------------
	{ MODKEY|ControlMask,             XK_j,      movestack,      {.i = +1 } },
	{ MODKEY|ControlMask,             XK_k,      movestack,      {.i = -1 } },
	{ MODKEY|ControlMask,             XK_Return, zoom,           {0} },
 
	//fullscreen
	{ MODKEY,             XK_f,      togglefullscr,  {0} },

	//Gaps resize ------------------------
	{ 0,		             0,      setcfact,       {.f = +0.25} },
	{ 0,		             0,      setcfact,       {.f = -0.25} },
	{ 0,		             0,      setcfact,       {.f =  0.00} },

	//Gaps ------------------------
	{ 0,	             		0,      incrgaps,       {.i = +1 } },
	{ 0,    							0,      incrgaps,       {.i = -1 } },
	{ 0,              		0,      incrigaps,      {.i = +1 } },
	{ 0,    							0,      incrigaps,      {.i = -1 } },
	{ 0,              		0,      incrogaps,      {.i = +1 } },
	{ 0,    							0,      incrogaps,      {.i = -1 } },
	{ 0,              		0,      incrihgaps,     {.i = +1 } },
	{ 0,    							0,      incrihgaps,     {.i = -1 } },
	{ 0,              		0,      incrivgaps,     {.i = +1 } },
	{ 0,    							0,      incrivgaps,     {.i = -1 } },
	{ 0,              		0,      incrohgaps,     {.i = +1 } },
	{ 0,                  0,      incrohgaps,     {.i = -1 } },
	{ 0,			        	  0,      incrovgaps,     {.i = +1 } },
	{ 0,							  	0,      incrovgaps,     {.i = -1 } },
	{ 0,              		0,      togglegaps,     {0} },
	{ 0,			        		0,      defaultgaps,    {0} },

	// view window ------------------------ 
	{ MODKEY,                       XK_Tab,    view,           {0} },

	//{ MODKEY,                       XK_t,      setlayout,      {.v = &layouts[0]} },
	//{ MODKEY,                       XK_f,      setlayout,      {.v = &layouts[1]} },
	//{ MODKEY,                       XK_m,      setlayout,      {.v = &layouts[2]} },
  //
  // setlayout
	{ MODKEY,                       XK_space,  setlayout,      {0} },

  // togglefloating
	{ MODKEY,	                      XK_w,      togglefloating, {0} },

	{ MODKEY,                       XK_0,      view,           {.ui = ~0 } },
	{ MODKEY|ShiftMask,             XK_0,      tag,            {.ui = ~0 } },

	{ MODKEY,                       XK_comma,  focusmon,       {.i = -1 } },
	{ MODKEY,                       XK_period, focusmon,       {.i = +1 } },
	{ MODKEY|ShiftMask,             XK_comma,  tagmon,         {.i = -1 } },
	{ MODKEY|ShiftMask,             XK_period, tagmon,         {.i = +1 } },

	// tags ------------------------
	TAGKEYS(                        XK_1,                      0)
	TAGKEYS(                        XK_2,                      1)
	TAGKEYS(                        XK_3,                      2)
	TAGKEYS(                        XK_4,                      3)
	TAGKEYS(                        XK_5,                      4)
	TAGKEYS(                        XK_6,                      5)
	TAGKEYS(                        XK_7,                      6)
	TAGKEYS(                        XK_8,                      7)
	TAGKEYS(                        XK_9,                      8)
	{ MODKEY|ALTKEY,                XK_q,      quit,           {0} },
	
	//layouts ------------------------
	// 0 { "[@]",      spiral },
	// 1 { "[]=",      tile },    /* first entry is default */
	// 2 { "[M]",      monocle },
	// 3 { "[\\]",     dwindle },
	// 4 { "H[]",      deck },
	// 5 { "TTT",      bstack },
	// 6 { "===",      bstackhoriz },
	// 7 { "HHH",      grid },
	// 8 { "###",      nrowgrid },
	// 9 { "---",      horizgrid },
	// 10 { ":::",      gaplessgrid },
	// 11 { "|M|",      centeredmaster },
	// 12 { ">M>",      centeredfloatingmaster },
	// 13 { "><>",      NULL },    /* no layout function means floating behavior */
	
	{ MODKEY|ALTKEY,                XK_1,                  setlayout,      {.v = &layouts[0]} },  //spiral
	{ MODKEY|ALTKEY,                XK_2,                  setlayout,      {.v = &layouts[3]} },  //dwindle
	{ MODKEY|ALTKEY,                XK_3,                  setlayout,      {.v = &layouts[1]} },  //tile
	{ MODKEY|ALTKEY,                XK_4,                  setlayout,      {.v = &layouts[5]} },  //bstack
	{ MODKEY|ALTKEY,                XK_5,                  setlayout,      {.v = &layouts[11]} }, //centeredmaster
	{ MODKEY|ALTKEY,                XK_6,                  setlayout,      {.v = &layouts[8]} },  //nrowgrid
	{ MODKEY|ALTKEY,                XK_7,                  setlayout,      {.v = &layouts[7]} },  //grid
	{ MODKEY|ALTKEY,                XK_8,                  setlayout,      {.v = &layouts[10]} }, //gaplessgrid
	{ MODKEY|ALTKEY,                XK_9,                  setlayout,      {.v = &layouts[2]} },  //monocle
	{ MODKEY|ALTKEY,                XK_0,                  setlayout,      {.v = &layouts[4]} },  //desk 

};

/* button definitions */
/* click can be ClkTagBar, ClkLtSymbol, ClkStatusText, ClkWinTitle, ClkClientWin, or ClkRootWin */
static const Button buttons[] = {
	/* click                event mask      button          function        argument */
	{ ClkLtSymbol,          0,              Button1,        setlayout,      {0} },
	{ ClkLtSymbol,          0,              Button3,        setlayout,      {.v = &layouts[2]} },
	{ ClkStatusText,        0,              Button2,        spawn,          {.v = termcmd } },
	{ ClkClientWin,         MODKEY,         Button1,        movemouse,      {0} },
	{ ClkClientWin,         MODKEY,         Button2,        togglefloating, {0} },
	{ ClkClientWin,         MODKEY,         Button3,        resizemouse,    {0} },
	{ ClkTagBar,            0,              Button1,        view,           {0} },
	{ ClkTagBar,            0,              Button3,        toggleview,     {0} },
	{ ClkTagBar,            MODKEY,         Button1,        tag,            {0} },
	{ ClkTagBar,            MODKEY,         Button3,        toggletag,      {0} },
};

