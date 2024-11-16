/*
* /===========================//
* /      _                    
* /     | |                   
* /   __| |_      __ __ ___  
* /  / _` \ \ /\ / / '_ ` _ \ 
* / | (_| |\ V  V /| | | | | |
* /  \__,_| \_/\_/ |_| |_| |_|
* /
* /===========================//
*/
// See LICENSE file for copyright and license details. 
// appearance 
static const unsigned int borderpx   = 6;       // border pixel of windows 
static const unsigned int snap       = 0;       // snap pixel 
//systray
static const unsigned int systraypinning = 1;    // 0: sloppy systray follows selected monitor, >0: pin systray to monitor X 
static const unsigned int systrayonleft = 1;     // 0: systray in the right corner, >0: systray on left of status text 
static const unsigned int systrayspacing = 12;   // systray spacing 
static const int systraypinningfailfirst = 1;    // 1: if pinning fails, display systray on the first monitor, False: display systray on the last monitor
static const int showsystray        =      0;         // 0 means no systray 
//show boxes
static int show_tag_boxes = 1;  // 1 — показывать квадратики, 0 — не показывать
//gap
static const unsigned int gappiv     = 20;       // vert inner gap between windows 
static const unsigned int gappih     = 20;       // horiz inner gap between windows 
static const unsigned int gappoh     = 35;       // horiz outer gap between windows and screen edge 
static const unsigned int gappov     = 20;       // vert outer gap between windows and screen edge 
static       int smartgaps           = 1;        // 1 means no outer gap when there is only one window 
static const unsigned int single_gappov = 120; // Вертикальный внешний отступ при одном окне
static const unsigned int single_gappoh = 60; // Горизонтальный внешний отступ при одном окне
//bar
static const int showbar             = 1;        // 0 means no bar 
static const int topbar              = 1;        // 0 means bottom bar 
// padding bar 
static const int vertpad             = 20;      // vertical padding of bar 
static const int sidepad             = 35;       // horizontal padding of bar 
// font
static const char *fonts[]           = { "FiraCode Nerd Font:size=16" };
// color
static const char col_gray1[]        = "#222222";
static const char col_gray2[]        = "#444444";
static const char col_gray3[]        = "#bbbbbb";
static const char col_gray4[]        = "#eeeeee";
static const char background[]       = "#1e1e2e";
static const char col_borderActive[] = "#8aadf4";
static const char col_noActive[]     = "#868eba";
static const char background2[]      = "#2f2f49";
static const char *colors[][3]       = {
	//               fg         bg         border   
	[SchemeNorm] = { col_gray3, background, col_noActive, },
	[SchemeSel]  = { col_gray4, background2 , col_borderActive },
};
// tagging 
static const char *tags[] = {   " 󱍢 ", "  ", " 󰈹 ", "  ", " 󰣇 ", "  ", "  ", "  ", "  " };
//static const char *tags[] = { " 1 ", " 2 ", " 3 ", " 4 ", " 5 ", " 6 ", " 7 ", " 8 ", " 9 " };

//static const char *tags[] = { "󱍢", "", "󰈹", "", "󰣇", "", "", "", "" };
//static const char *tags[] = { "1", "2", "3", "4", "5", "6", "7", "8", "9" };

static const Rule rules[] = {
	// xprop(1):
	//	WM_CLASS(STRING) = instance, class
	//	WM_NAME(STRING) = title
	// class      instance    title       tags mask     isfloating   monitor 
	  { "firefox",          NULL, NULL, 1 << 2, 0, -1 },
    { "telegram-desktop", NULL, NULL, 1 << 3, 0, -1 },
    { "TelegramDesktop",  NULL, NULL, 1 << 3, 0, -1 },
    { "kitty", NULL, "neofetch_terminal", 1 << 0, 0, -1 },
};
/* layout(s) */
static const float mfact     = 0.55; // factor of master area size [0.05..0.95] 
static const int nmaster     = 1;    // number of clients in master area 
static const int resizehints = 1;    // 1 means respect size hints in tiled resizals 
static const int lockfullscreen = 1; // 1 will force focus on the fullscreen window 
#define FORCE_VSPLIT 1  // nrowgrid layout: force two clients to always split vertically
#include "vanitygaps.c"
static const Layout layouts[] = {
	// symbol     arrange function 
	{ "[@]",      spiral }, // first entry is default ,
	{ "[]=",      tile },    
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
	{ "><>",      NULL },    // no layout function means floating behavior 
	{ NULL,       NULL },
};
// key definitions
#define MODKEY Mod4Mask
#define ALTKEY Mod1Mask
#define TAGKEYS(KEY,TAG)                                                                                     \
       &((Keychord){1, {{MODKEY, KEY}},                                 view,           {.ui = 1 << TAG} }), \
       &((Keychord){1, {{MODKEY|ControlMask, KEY}},                     toggleview,     {.ui = 1 << TAG} }), \
       &((Keychord){1, {{MODKEY|ShiftMask, KEY}},                       tag,            {.ui = 1 << TAG} }), \
       &((Keychord){1, {{MODKEY|ControlMask|ShiftMask, KEY}},           toggletag,      {.ui = 1 << TAG} }),
// helper for spawning shell commands in the pre dwm-5.0 fashion 
#define SHCMD(cmd) {.v = (const char*[]){"/bin/sh", "-c", cmd, NULL}}
static const char *termcmd[]  = { "kitty", NULL };
static const char *browser[]  = { "firefox", NULL };
static const char *codeEditor[]  = { "code", NULL };
#include "movestack.c"
void togglesmartgaps(const Arg *arg);
static Keychord *keychords[] = {
/*
* //  _            _                      _   _    _         _ _           
* // | |_____ _  _| |__  ___  __ _ _ _ __| | | |__(_)_ _  __| (_)_ _  __ _ 
* // | / / -_) || | '_ \/ _ \/ _` | '_/ _` | | '_ \ | ' \/ _` | | ' \/ _` |
* // |_\_\___|\_, |_.__/\___/\__,_|_| \__,_| |_.__/_|_||_\__,_|_|_||_\__, |
* //          |__/                                                   |___/ 
*/
    //settings [ super + i ] 
    &((Keychord){2, {{MODKEY, XK_i}, {0, XK_d}}, spawn,  SHCMD("kitty -e $HOME/suckless/dwm")  }),
    &((Keychord){2, {{MODKEY, XK_i}, {0, XK_a}}, spawn,  SHCMD("kitty -e $HOME/suckless/autostart")  }),
    &((Keychord){2, {{MODKEY, XK_i}, {0, XK_s}}, spawn,  SHCMD("kitty -e $HOME/suckless/scripts")  }),
    &((Keychord){3, {{MODKEY, XK_i}, {0, XK_i},{0,XK_c}}, spawn,  SHCMD("kitty --hold sh -c 'cd $HOME/suckless/dwm; nvim config.h; exec $SHELL'")  }),
    &((Keychord){3, {{MODKEY, XK_i}, {0, XK_i},{0,XK_d}}, spawn,  SHCMD("kitty --hold sh -c 'cd $HOME/suckless/dwm; nvim dwm.c; exec $SHELL'")  }),
    &((Keychord){4, {{MODKEY, XK_i}, {0, XK_i},{0,XK_r},{0,XK_c}}, spawn,  SHCMD("kitty --hold sh -c 'cd $HOME/suckless/dwm; nvim config.def.h.rej; exec $SHELL'")  }),
    &((Keychord){4, {{MODKEY, XK_i}, {0, XK_i},{0,XK_r},{0,XK_d}}, spawn,  SHCMD("kitty --hold sh -c 'cd $HOME/suckless/dwm; nvim dwm.c.rej; exec $SHELL'")  }),
    // system [ super + s ]
    &((Keychord){2, {{MODKEY, XK_s},{0,XK_u}}, spawn,  SHCMD("kitty -e  $HOME/suckless/scripts/update.sh")  }), //update system
    &((Keychord){2, {{MODKEY, XK_s},{0|ShiftMask,XK_p}}, spawn,  SHCMD("kitty -e  $HOME/suckless/scripts/pushDots.sh")  }), //pushDots
    &((Keychord){2, {{MODKEY, XK_s},{0,XK_r}}, spawn,  SHCMD("$HOME/suckless/scripts/recompileDwm.sh")  }), //recompile dwm
    &((Keychord){2, {{MODKEY, XK_s},{0, XK_p}}, spawn,  SHCMD("$HOME/.config/rofi/powermenu/type-2/powermenu.sh")  }), // powermenu
    // aplication [ super + a ] 
    &((Keychord){2, {{MODKEY, XK_a},{0,XK_f}}, spawn,  {.v = browser } }),   //firefox
    &((Keychord){2, {{MODKEY, XK_a},{0,XK_d}}, spawn,  SHCMD("vesktop")  }), //vesktop
    &((Keychord){2, {{MODKEY, XK_a},{0,XK_c}}, spawn,  {.v = codeEditor } }),//vscode
    &((Keychord){2, {{MODKEY, XK_a},{0,XK_t}}, spawn,  SHCMD("telegram-desktop")  }), //telegram
    //screen [super + p ]
    &((Keychord){2, {{MODKEY, XK_p}, {0,XK_c}}, spawn,  SHCMD("$HOME/suckless/scripts/xcolor-picker.sh")  }),//	colorpicer
    &((Keychord){2, {{MODKEY, XK_p}, {0, XK_s}}, spawn,  SHCMD("flameshot gui")  }), //screen shot
    &((Keychord){2, {{MODKEY, XK_p},{0|ShiftMask, XK_c}}, spawn, SHCMD("$HOME/suckless/scripts/clock.sh") }), //clock
    &((Keychord){4, {{MODKEY, XK_p},{0, XK_p},{0, XK_b},{0,XK_t}}, spawn, SHCMD("$HOME/.config/picom/toggle_config.sh default") }), // picom blur
    &((Keychord){4, {{MODKEY, XK_p},{0, XK_p},{0, XK_g},{0,XK_t}}, spawn, SHCMD("$HOME/.config/picom/toggle_config.sh glass") }), // picom glass
    &((Keychord){3, {{MODKEY, XK_p},{0, XK_p},{0, XK_c}}, spawn, SHCMD("kitty -e $HOME/.config/picom/") }), // picom glass
    //filemanager [super + e ]
    &((Keychord){2, {{MODKEY, XK_e}, {0, XK_y}}, spawn,  SHCMD("kitty --hold sh -c 'yazi'")  }), // yazi
    &((Keychord){2, {{MODKEY, XK_e}, {0, XK_n}}, spawn,  SHCMD("nemo")  }), // nemo
    // web apps
    &((Keychord){2, {{MODKEY|ShiftMask, XK_f},{0,XK_m}}, spawn,  SHCMD("firefox --class WebApp-monkey3985 --name WebApp-monkey3985 --profile $HOME/.local/share/ice/firefox/monkey3985 --no-remote 'https://monkeytype.com'")  }), //monkeytype
    &((Keychord){2, {{MODKEY|ShiftMask, XK_f},{0,XK_g}}, spawn,  SHCMD("firefox --class WebApp-chatG2444 --name WebApp-chatG2444 --profile /home/maaru/.local/share/ice/firefox/chatG2444 --no-remote 'https://chatgpt.com/'")  }), //chat gpt
    //kitty 
    &((Keychord){1, {{MODKEY, XK_Return}},   spawn,          { .v = termcmd } }),
    //killActive 
    &((Keychord){1, {{MODKEY, XK_q}},       killclient,     {0} }),
    //changeKeyboard
    &((Keychord){1, {{ControlMask, 0xffe9}}, spawn,  SHCMD("pkill -RTMIN+1 dwmblocks && $HOME/suckless/scripts/changeKeyboard.sh setxkbmap -layout us,ru -option 'grp:ctrl_alt_toggle' -option 'ctrl:nocaps'")  }),
	//rofi
    &((Keychord){1, {{MODKEY, XK_r}}, spawn,  SHCMD("$HOME/.config/rofi/launchers/type-2/launcher.sh")  }),
    &((Keychord){1, {{MODKEY|ShiftMask, XK_a}}, spawn,  SHCMD("$HOME/.config/rofi/launchers/type-3/launcher_1.sh")  }),
    &((Keychord){1, {{MODKEY, XK_v}}, spawn, SHCMD("$HOME/.config/rofi/launchers/type-2/bufer.sh") }),
    &((Keychord){1, {{MODKEY|ALTKEY, XK_a}}, spawn,  SHCMD("$HOME/.config/rofi/launchers/type-2/emoji.sh")  }),
    //wallpapers control
    &((Keychord){1, {{MODKEY|ControlMask, 0x5b}}, spawn, SHCMD("$HOME/suckless/scripts/change_wallpaper.sh left" ) }),
    &((Keychord){1, {{MODKEY|ControlMask, 0x5d}}, spawn, SHCMD("$HOME/suckless/scripts/change_wallpaper.sh right") }),
	// Управление Ярсотью 
    &((Keychord){1, {{MODKEY|ShiftMask, 0x5b}}, spawn, SHCMD("$HOME/suckless/scripts/brightnessControl.sh up") }),
    &((Keychord){1, {{MODKEY|ShiftMask, 0x5d}}, spawn, SHCMD("$HOME/suckless/scripts/brightnessControl.sh down") }),
    // Управление Громкостью 
    &((Keychord){1, {{MODKEY, 0x5b}}, spawn, SHCMD("$HOME/suckless/scripts/volume.sh up"  ) }),
    &((Keychord){1, {{MODKEY, 0x5d}}, spawn, SHCMD("$HOME/suckless/scripts/volume.sh down") }),
    &((Keychord){1, {{MODKEY, 0x5c}}, spawn, SHCMD("$HOME/suckless/scripts/volume.sh mute") }),
    // move flouting window
	&((Keychord){1, {{MODKEY, XK_j}}, moveresize, { .v = "0x 45y 0w 0h"  } }),
    &((Keychord){1, {{MODKEY, XK_k}}, moveresize, { .v = "0x -45y 0w 0h" } }),
    &((Keychord){1, {{MODKEY, XK_l}}, moveresize, { .v = "45x 0y 0w 0h"  } }),
    &((Keychord){1, {{MODKEY, XK_h}}, moveresize, { .v = "-45x 0y 0w 0h" } }),
    //resize flouting widnow
    &((Keychord){1, {{MODKEY|ShiftMask|ALTKEY, XK_j}}, moveresize, { .v = "0x 0y 0w 45h"  } }),
    &((Keychord){1, {{MODKEY|ShiftMask|ALTKEY, XK_k}}, moveresize, { .v = "0x 0y 0w -45h" } }),
    &((Keychord){1, {{MODKEY|ShiftMask|ALTKEY, XK_l}}, moveresize, { .v = "0x 0y 45w 0h"  } }),
    &((Keychord){1, {{MODKEY|ShiftMask|ALTKEY, XK_h}}, moveresize, { .v = "0x 0y -45w 0h" } }),
    // move flouting window ALTKEY
    &((Keychord){1, {{MODKEY|ControlMask, XK_k}}, moveresizeedge, { .v = "t" } }),
    &((Keychord){1, {{MODKEY|ControlMask, XK_j}}, moveresizeedge, { .v = "b" } }),
    &((Keychord){1, {{MODKEY|ControlMask, XK_h}}, moveresizeedge, { .v = "l" } }),
    &((Keychord){1, {{MODKEY|ControlMask, XK_l}}, moveresizeedge, { .v = "r" } }),
    //move flouting wondow
    &((Keychord){1, {{MODKEY|ControlMask|ShiftMask, XK_k}}, moveresizeedge, { .v = "T" } }),
    &((Keychord){1, {{MODKEY|ControlMask|ShiftMask, XK_j}}, moveresizeedge, { .v = "B" } }),
    &((Keychord){1, {{MODKEY|ControlMask|ShiftMask, XK_h}}, moveresizeedge, { .v = "L" } }),
    &((Keychord){1, {{MODKEY|ControlMask|ShiftMask, XK_l}}, moveresizeedge, { .v = "R" } }),
	//toggleBar 
    &((Keychord){1, {{MODKEY|ShiftMask, XK_w}}, togglebar, { 0 } }),
	//focusStack 
    &((Keychord){1, {{MODKEY|ShiftMask, XK_j}}, focusstack, { .i = +1 } }),
    &((Keychord){1, {{MODKEY|ShiftMask, XK_k}}, focusstack, { .i = -1 } }),
    &((Keychord){1, {{MODKEY|ShiftMask, XK_h}}, focusstack, { .i = -0.05 } }),
    &((Keychord){1, {{MODKEY|ShiftMask, XK_l}}, focusstack, { .i = +0.05 } }),
    //resizeStack
    &((Keychord){1, {{MODKEY|ShiftMask, XK_l}}, setmfact, { .f = +0.05 } }),
    &((Keychord){1, {{MODKEY|ShiftMask, XK_h}}, setmfact, { .f = -0.05 } }),
	// tileStack modes I, D 
    &((Keychord){1, {{MODKEY, XK_u}}, incnmaster, { .i = +1 } }),
    &((Keychord){1, {{MODKEY, XK_d}}, incnmaster, { .i = -1 } }),
	//MoveStack 
    &((Keychord){1, {{MODKEY|ControlMask, XK_j}}, movestack, { .i = +1 } }),
    &((Keychord){1, {{MODKEY|ControlMask, XK_k}}, movestack, { .i = -1 } }),
    &((Keychord){1, {{MODKEY|ControlMask, XK_Return}}, zoom, { 0 } }),
	//fullscreen
    &((Keychord){1, {{MODKEY, XK_f}}, togglefullscr, { 0 } }),
	//Gaps resize 
    &((Keychord){1, {{0, 0}}, setcfact, { .f = +0.25 } }),
    &((Keychord){1, {{0, 0}}, setcfact, { .f = -0.25 } }),
    &((Keychord){1, {{0, 0}}, setcfact, { .f =  0.00 } }),
    // view window  
    &((Keychord){1, {{MODKEY, XK_Tab}}, view, { 0 } }),
    // view all window
    &((Keychord){1, {{MODKEY, XK_0}}, view, { .ui = ~0 } }),
    // pin window
    &((Keychord){1, {{MODKEY|ShiftMask, XK_0}}, tag, { .ui = ~0 } }),
    &((Keychord){1, {{MODKEY, XK_comma}}, focusmon, { .i = -1 } }),
    &((Keychord){1, {{MODKEY, XK_period}}, focusmon, { .i = +1 } }),
    &((Keychord){1, {{MODKEY|ShiftMask, XK_comma}}, tagmon, { .i = -1 } }),
    &((Keychord){1, {{MODKEY|ShiftMask, XK_period}}, tagmon, { .i = +1 } }),
    //===================================================================================//
	//layouts 
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
	// 13 { "><>",      NULL },    // no layout function means floating behavior 
    // window [ super + w ]
    //===================================================================================//
    &((Keychord){2, {{MODKEY,XK_w}, {0,XK_1}}, setlayout, { .v = &layouts[0] } }), //spiral
    &((Keychord){2, {{MODKEY,XK_w}, {0,XK_2}}, setlayout, { .v = &layouts[3] } }), //dwindle
    &((Keychord){2, {{MODKEY,XK_w}, {0,XK_3}}, setlayout, { .v = &layouts[1] } }), //tile
    &((Keychord){2, {{MODKEY,XK_w}, {0,XK_4}}, setlayout, { .v = &layouts[5] } }), //bstack
    &((Keychord){2, {{MODKEY,XK_w}, {0,XK_5}}, setlayout, { .v = &layouts[11] } }), //centeredmaster
    &((Keychord){2, {{MODKEY,XK_w}, {0,XK_6}}, setlayout, { .v = &layouts[8] } }), //nrowgrid
    &((Keychord){2, {{MODKEY,XK_w}, {0,XK_7}}, setlayout, { .v = &layouts[7] } }), //grid
    &((Keychord){2, {{MODKEY,XK_w}, {0,XK_8}}, setlayout, { .v = &layouts[10] } }), //gaplessgrid
    &((Keychord){2, {{MODKEY,XK_w}, {0,XK_9}}, setlayout, { .v = &layouts[2] } }), //monocle
    &((Keychord){2, {{MODKEY,XK_w}, {0,XK_0}}, setlayout, { .v = &layouts[4] } }), //desk
    //===================================================================================//
    &((Keychord){2, {{MODKEY, XK_w},{0,XK_Tab}}, toggleAttachBelow, { 0 } }), //toggleAttachBelow
    &((Keychord){2, {{MODKEY, XK_w},{0,XK_w}}, togglefloating, { 0 } }), //toggle floating
    &((Keychord){2, {{MODKEY, XK_w},{0,XK_l}}, setlayout, { 0 } }),// setlayout
    &((Keychord){2, {{MODKEY, XK_w},{0,XK_g}}, togglesmartgaps, { 0 } }),// togglesmartgaps
    &((Keychord){2, {{MODKEY, XK_w},{0,XK_t}}, toggle_tag_boxes, { 0 } }),// toggle_tag_boxes


    //===================================================================================//
	// tags 
	TAGKEYS(            XK_1,                      0)
	TAGKEYS(            XK_2,                      1)
	TAGKEYS(            XK_3,                      2)
	TAGKEYS(            XK_4,                      3)
	TAGKEYS(            XK_5,                      4)
	TAGKEYS(            XK_6,                      5)
	TAGKEYS(            XK_7,                      6)
	TAGKEYS(            XK_8,                      7)
	TAGKEYS(            XK_9,                      8)
    //reload && exit
    &((Keychord){1, {{MODKEY|ALTKEY, XK_q}}, quit, { 0 } }),
    //Gaps 
    &((Keychord){0, {{0, 0}}, incrgaps, { .i = +1 } }),
    &((Keychord){0, {{0, 0}}, incrgaps, { .i = -1 } }),
    &((Keychord){0, {{0, 0}}, incrigaps, { .i = +1 } }),
    &((Keychord){0, {{0, 0}}, incrigaps, { .i = -1 } }),
    &((Keychord){0, {{0, 0}}, incrogaps, { .i = +1 } }),
    &((Keychord){0, {{0, 0}}, incrogaps, { .i = -1 } }),
    &((Keychord){0, {{0, 0}}, incrihgaps, { .i = +1 } }),
    &((Keychord){0, {{0, 0}}, incrihgaps, { .i = -1 } }),
    &((Keychord){0, {{0, 0}}, incrivgaps, { .i = +1 } }),
    &((Keychord){0, {{0, 0}}, incrivgaps, { .i = -1 } }),
    &((Keychord){0, {{0, 0}}, incrohgaps, { .i = +1 } }),
    &((Keychord){0, {{0, 0}}, incrohgaps, { .i = -1 } }),
    &((Keychord){0, {{0, 0}}, incrovgaps, { .i = +1 } }),
    &((Keychord){0, {{0, 0}}, incrovgaps, { .i = -1 } }),
    &((Keychord){0, {{0, 0}}, togglegaps, { 0 } }),
    &((Keychord){0, {{0, 0}}, defaultgaps, { 0 } }),
    //===================================================================================//
};
// button definitions 
// click can be ClkTagBar, ClkLtSymbol, ClkStatusText, ClkWinTitle, ClkClientWin, or ClkRootWin 
static const Button buttons[] = {
	// click                event mask      button          function        argument 
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
//=-=-=-=-=-=-=-=-=-=-=-not=-Working=-=-=-=-=-=-=-=-=-=-=-=-=-=//
//bar paddings
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=//

