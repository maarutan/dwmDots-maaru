/*
* /==========================================//
* / ██████╗ ██╗    ██╗███╗   ███╗     ██████╗
* / ██╔══██╗██║    ██║████╗ ████║    ██╔════╝
* / ██║  ██║██║ █╗ ██║██╔████╔██║    ██║     
* / ██║  ██║██║███╗██║██║╚██╔╝██║    ██║     
* / ██████╔╝╚███╔███╔╝██║ ╚═╝ ██║ ██╗╚ ██████╗
* / ╚═════╝  ╚══╝╚══╝ ╚═╝     ╚═╝ ╚═╝  ╚═════╝
* /==========================================//
*/
#include <errno.h>
#include <locale.h>
#include <signal.h>
#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <X11/cursorfont.h>
#include <X11/keysym.h>
#include <X11/Xatom.h>
#include <X11/Xlib.h>
#include <X11/Xproto.h>
#include <X11/Xutil.h>
#ifdef XINERAMA
#include <X11/extensions/Xinerama.h>
#endif /* XINERAMA */
#include <X11/Xft/Xft.h>
#include "drw.h"
#include "util.h"

/* macros */
#define BUTTONMASK              (ButtonPressMask|ButtonReleaseMask)
#define CLEANMASK(mask)         (mask & ~(numlockmask|LockMask) & (ShiftMask|ControlMask|Mod1Mask|Mod2Mask|Mod3Mask|Mod4Mask|Mod5Mask))
#define INTERSECT(x,y,w,h,m)    (MAX(0, MIN((x)+(w),(m)->wx+(m)->ww) - MAX((x),(m)->wx)) \
                               * MAX(0, MIN((y)+(h),(m)->wy+(m)->wh) - MAX((y),(m)->wy)))
#define ISVISIBLE(C)            ((C->tags & C->mon->tagset[C->mon->seltags]))
#define MOUSEMASK               (BUTTONMASK|PointerMotionMask)
#define WIDTH(X)                ((X)->w + 2 * (X)->bw)
#define HEIGHT(X)               ((X)->h + 2 * (X)->bw)
#define TAGMASK                 ((1 << LENGTH(tags)) - 1)
#define TAGSLENGTH              (LENGTH(tags))
#define TEXTW(X)                (drw_fontset_getwidth(drw, (X)) + lrpad)
#define SYSTEM_TRAY_REQUEST_DOCK    0
/* XEMBED messages */
#define XEMBED_EMBEDDED_NOTIFY      0
#define XEMBED_WINDOW_ACTIVATE      1
#define XEMBED_FOCUS_IN             4
#define XEMBED_MODALITY_ON         10
#define NUMTAGS 9 // Обычно количество тегов в dwm — 9
#define XEMBED_MAPPED              (1 << 0)
#define XEMBED_WINDOW_ACTIVATE      1
#define XEMBED_WINDOW_DEACTIVATE    2
#define VERSION_MAJOR               0
#define VERSION_MINOR               0
#define XEMBED_EMBEDDED_VERSION (VERSION_MAJOR << 16) | VERSION_MINOR

#define STATE_FILE_PATH ".cache/smartgaps_state"
#define STATE_FILE_PATH_SYSTRAY ".cache/dwmsystray_state" 
#define STATE_FILE_PATH_TITLE ".cache/dwmtitle_state"
#define STATE_FILE_TOGGLEGAPS ".cache/togglebottgaps"
#define CURRENTS_MINIBOX ".cache/dwmshowtagboxes_state"
/* enums */
enum { CurNormal, CurResize, CurMove, CurLast }; /* cursor */
enum { 
    NetSupported, 
    NetWMName, 
    NetWMState, 
    NetWMCheck,
    NetSystemTray, 
    NetSystemTrayOP, 
    NetSystemTrayOrientation, 
    NetSystemTrayOrientationHorz,
    NetWMFullscreen, 
    NetActiveWindow, 
    NetWMWindowType,
    NetWMWindowTypeDialog, 
    NetWMWindowTypeDock, 
    NetClientList, 
    NetDesktopNames, 
    NetDesktopViewport,
    NetNumberOfDesktops, 
    NetCurrentDesktop, 
    NetWMDesktop, 
    NetClientInfo, 
    NetWorkarea, // Добавляем сюда
    NetLast 
}; /* EWMH atoms */
enum { Manager, Xembed, XembedInfo, XLast }; /* Xembed atoms */
enum { WMProtocols, WMDelete, WMState, WMTakeFocus, WMLast }; /* default atoms */
enum { ClkTagBar, ClkLtSymbol, ClkStatusText, ClkClientWin,
       ClkRootWin, ClkLast }; /* clicks */
enum { SchemeNorm, SchemeSel, SchemeTitle, SchemeTitleSel, SchemeLine }; /* color schemes */

typedef union {
	int i;
	unsigned int ui;
	float f;
	const void *v;
} Arg;

typedef struct {
	unsigned int click;
	unsigned int mask;
	unsigned int button;
	void (*func)(const Arg *arg);
	const Arg arg;
} Button;

typedef struct Monitor Monitor;
typedef struct Client Client;
struct Client {
	char name[256];
	float mina, maxa;
	float cfact;
	int x, y, w, h;
	int oldx, oldy, oldw, oldh;
	int basew, baseh, incw, inch, maxw, maxh, minw, minh, hintsvalid;
	int bw, oldbw;
	unsigned int tags;
	int isfixed, isfloating, isurgent, neverfocus, oldstate, isfullscreen;
	Client *next;
	Client *snext;
	Monitor *mon;
	Window win;
};

typedef struct {
	unsigned int mod;
	KeySym keysym;
} Key;

typedef struct {
    unsigned int n;
    const Key keys[5];
	void (*func)(const Arg *);
	const Arg arg;
} Keychord;

typedef struct {
	const char *symbol;
	void (*arrange)(Monitor *);
} Layout;

typedef struct Pertag Pertag;

struct Monitor {
    char ltsymbol[16];
    float mfact;
    int nmaster;
    int num;
    int by;               /* bar geometry */
    int mx, my, mw, mh;   /* screen size */
    int wx, wy, ww, wh;   /* window area  */
    int gappih;           /* horizontal gap between windows */
    int gappiv;           /* vertical gap between windows */
    int gappoh;           /* horizontal outer gaps */
    int gappov;           /* vertical outer gaps */
    unsigned int seltags;
    unsigned int sellt;
    unsigned int tagset[2];
    int showbar;
    int showtitle;        /* управление отображением заголовков */
    int topbar;
    Client *clients;
    Client *sel;
    Client *stack;
    Monitor *next;
    Window barwin;
    const Layout *lt[2];
    Pertag *pertag;
};

typedef struct {
	const char *class;
	const char *instance;
	const char *title;
	unsigned int tags;
	int isfloating;
	int monitor;
} Rule;

typedef struct Systray   Systray;
struct Systray {
	Window win;
	Client *icons;
};

/* function declarations */
static void applyrules(Client *c);
static int applysizehints(Client *c, int *x, int *y, int *w, int *h, int interact);
static void arrange(Monitor *m);
static void arrangemon(Monitor *m);
static void attach(Client *c);
static void attachBelow(Client *c);
static void toggleAttachBelow();
static void attachstack(Client *c);
static void buttonpress(XEvent *e);
static void checkotherwm(void);
static void cleanup(void);
static void cleanupmon(Monitor *mon);
static void clientmessage(XEvent *e);
static void configure(Client *c);
static void configurenotify(XEvent *e);
static void configurerequest(XEvent *e);
static Monitor *createmon(void);
static void destroynotify(XEvent *e);
static void detach(Client *c);
static void detachstack(Client *c);
static Monitor *dirtomon(int dir);
static void drawbar(Monitor *m);
static void drawbars(void);
static void enternotify(XEvent *e);
static void expose(XEvent *e);
static void focus(Client *c);
static void focusin(XEvent *e);
static void focusmon(const Arg *arg);
static void focusstack(const Arg *arg);
static Atom getatomprop(Client *c, Atom prop);
static int getrootptr(int *x, int *y);
static long getstate(Window w);
static unsigned int getsystraywidth();
static int gettextprop(Window w, Atom atom, char *text, unsigned int size);
static void grabbuttons(Client *c, int focused);
static void grabkeys(void);
static void incnmaster(const Arg *arg);
static void keypress(XEvent *e);
static void killclient(const Arg *arg);
static void manage(Window w, XWindowAttributes *wa);
static void mappingnotify(XEvent *e);
static void maprequest(XEvent *e);
static void motionnotify(XEvent *e);
static void moveresize(const Arg *arg);
static void moveresizeedge(const Arg *arg);
static void movemouse(const Arg *arg);
static Client *nexttiled(Client *c);
static void pop(Client *c);
static void propertynotify(XEvent *e);
static void quit(const Arg *arg);
static Monitor *recttomon(int x, int y, int w, int h);
static void removesystrayicon(Client *i);
static void resize(Client *c, int x, int y, int w, int h, int interact);
static void resizebarwin(Monitor *m);
static void resizeclient(Client *c, int x, int y, int w, int h);
static void resizemouse(const Arg *arg);
static void resizerequest(XEvent *e);
static void restack(Monitor *m);
static void run(void);
static void scan(void);
static int sendevent(Window w, Atom proto, int m, long d0, long d1, long d2, long d3, long d4);
static void sendmon(Client *c, Monitor *m);
static void setclientstate(Client *c, long state);
static void setcurrentdesktop(void);
static void setdesktopnames(void);
static void setnumdesktops(void);
static void setviewport(void);
static void setclienttagprop(Client *c);
static void setfocus(Client *c);
static void setfullscreen(Client *c, int fullscreen);
static void setlayout(const Arg *arg);
static void setcfact(const Arg *arg);
static void setmfact(const Arg *arg);
static void setup(void);
static void seturgent(Client *c, int urg);
static void showhide(Client *c);
static void spawn(const Arg *arg);
static Monitor *systraytomon(Monitor *m);
static void tag(const Arg *arg);
static void tagmon(const Arg *arg);
static void togglebar(const Arg *arg);
static void togglefloating(const Arg *arg);
static void togglefullscr(const Arg *arg);
static void toggletag(const Arg *arg);
static void toggleview(const Arg *arg);
static void unfocus(Client *c, int setfocus);
static void unmanage(Client *c, int destroyed);
static void unmapnotify(XEvent *e);
static void updatecurrentdesktop(void);
static void updatebarpos(Monitor *m);
static void updatebars(void);
static void updateclientlist(void);
static int updategeom(void);
static void updatenumlockmask(void);
static void updatesizehints(Client *c);
static void updatestatus(void);
static void updatesystray(void);
static void updatesystrayicongeom(Client *i, int w, int h);
static void updatesystrayiconstate(Client *i, XPropertyEvent *ev);
static void updatetitle(Client *c);
static void updatewindowtype(Client *c);
static void updatewmhints(Client *c);
static void view(const Arg *arg);
static Client *wintoclient(Window w);
static Monitor *wintomon(Window w);
static Client *wintosystrayicon(Window w);
static int xerror(Display *dpy, XErrorEvent *ee);
static int xerrordummy(Display *dpy, XErrorEvent *ee);
static int xerrorstart(Display *dpy, XErrorEvent *ee);
static void zoom(const Arg *arg);
static void winview(const Arg* arg);
void toggleSystray(const Arg *arg);
void viewnext(const Arg *arg);
void viewprev(const Arg *arg);
int is_noborder_app(const char *class);
int is_alltags_app(const char *class);
void toggleshowtitle(const Arg *arg);
void save_showtitle_state(void);
void load_showtitle_state(void);
void saveSmartgapsState(int state);
int isWindowIgnored(Client *c);  // Объявление функции
void toggle_bottGaps(const Arg *arg);  // Прототип функции
void toggleTagBoxes(const Arg *arg);
int read_saved_tag(void);     // Объявление функции для чтения сохранённого тега
void save_current_tag(void);  // Объявление функции для сохранения текущего тега
void switch_to_saved_tag(void); // Объявление функции для переключения на сохранённый тег
void recompile_and_restart(const Arg *arg);
void updateworkarea(void);
void hidewin(const Arg *arg);
void restorewin(const Arg *arg);
void showall(const Arg *arg);

/* variables */
static Systray *systray = NULL;
static const char broken[] = "broken";
static char stext[256];
static Client *hidden_windows[NUMTAGS];
static int screen;
static int sw, sh;           /* X display screen geometry width, height */
static int bh;               /* bar height */
static int lrpad;            /* sum of left and right padding for text */
static int vp;               /* vertical padding for bar */
static int sp;               /* side padding for bar */
static int (*xerrorxlib)(Display *, XErrorEvent *);
static unsigned int numlockmask = 0;
static void (*handler[LASTEvent]) (XEvent *) = {
	[ButtonPress] = buttonpress,
	[ClientMessage] = clientmessage,
	[ConfigureRequest] = configurerequest,
	[ConfigureNotify] = configurenotify,
	[DestroyNotify] = destroynotify,
	[EnterNotify] = enternotify,
	[Expose] = expose,
	[FocusIn] = focusin,
	[KeyPress] = keypress,
	[MappingNotify] = mappingnotify,
	[MapRequest] = maprequest,
	[MotionNotify] = motionnotify,
	[PropertyNotify] = propertynotify,
	[ResizeRequest] = resizerequest,
	[UnmapNotify] = unmapnotify
};
static Atom wmatom[WMLast], netatom[NetLast], xatom[XLast];
static int running = 1;
static Cur *cursor[CurLast];
static Clr **scheme;
static Display *dpy;
static Drw *drw;
static Monitor *mons, *selmon;
static Window root, wmcheckwin;
unsigned int currentkey = 0;

/* configuration, allows nested code to access above variables */
#include "config.h"


int read_saved_tag() {
    char filepath[256];
    snprintf(filepath, sizeof(filepath), "%s/.cache/dwm_current_tag", getenv("HOME"));

    FILE *file = fopen(filepath, "r");
    if (!file) {
        return -1; // Если файл не найден, возвращаем -1 (остаемся на дефолтном теге)
    }

    int tag;
    fscanf(file, "%d", &tag);
    fclose(file);
    return tag;
}




void save_current_tag_to_file() {
    char filepath[256];
    snprintf(filepath, sizeof(filepath), "%s/.cache/dwm_current_tag", getenv("HOME"));

    FILE *file = fopen(filepath, "w");
    if (file) {
        unsigned int mask = selmon->tagset[selmon->seltags];
        int tag = 0;

        // Преобразуем битовую маску в индекс
        while (!(mask & 1)) {
            mask >>= 1;
            tag++;
        }

        fprintf(file, "%d\n", tag);  // Сохраняем индекс активного тега
        fclose(file);
        printf("Saved current tag: %d to %s\n", tag, filepath);  // Для отладки
    } else {
        fprintf(stderr, "Failed to save current tag to %s\n", filepath);
    }
}




void hidewin(const Arg *arg) {
    Client *c = selmon->sel;

    if (!c || c->isfullscreen)
        return;

    unsigned int tag = selmon->tagset[selmon->seltags]; // Текущий тег

    // Убираем окно из стека монитора
    detach(c);
    detachstack(c);

    // Добавляем окно в список скрытых для текущего тега
    c->next = hidden_windows[tag];
    hidden_windows[tag] = c;

    // Убираем окно с экрана
    XUnmapWindow(dpy, c->win);

    // Обновляем монитор
    focus(NULL);
    arrange(selmon);
}




void restorewin(const Arg *arg) {
    unsigned int tag = selmon->tagset[selmon->seltags]; // Текущий тег

    if (!hidden_windows[tag])
        return;

    // Достаем первое скрытое окно для текущего тега
    Client *c = hidden_windows[tag];
    hidden_windows[tag] = c->next;

    // Возвращаем окно в стек
    attach(c);
    attachstack(c);

    // Делаем окно видимым
    XMapWindow(dpy, c->win);

    // Обновляем монитор
    focus(c);
    arrange(selmon);
}



void showall(const Arg *arg) {
    unsigned int tag = selmon->tagset[selmon->seltags]; // Текущий тег
    Client *c;

    while (hidden_windows[tag]) {
        c = hidden_windows[tag];
        hidden_windows[tag] = c->next;

        // Возвращаем окно в стек и делаем его видимым
        attach(c);
        attachstack(c);
        XMapWindow(dpy, c->win);
    }

    // Обновляем монитор
    focus(NULL);
    arrange(selmon);
}

void switch_to_saved_tag() {
    char filepath[256];
    snprintf(filepath, sizeof(filepath), "%s/.cache/dwm_current_tag", getenv("HOME"));

    FILE *file = fopen(filepath, "r");
    if (file) {
        int tag;
        fscanf(file, "%d", &tag);
        fclose(file);

        printf("Restoring tag: %d\n", tag);  // Отладочное сообщение

        if (tag >= 0 && tag < LENGTH(tags)) {
            Arg arg = {.ui = 1 << tag};  // Преобразуем индекс в битовую маску
            view(&arg);                 // Переключаемся на нужный тег
        } else {
            printf("Tag out of range: %d\n", tag);
        }
    } else {
        fprintf(stderr, "Failed to open file for restoring tag: %s\n", filepath);
    }
}


void save_bottGaps_state() {
    FILE *file = fopen(STATE_FILE_TOGGLEGAPS, "w");
    if (file) {
        fprintf(file, "%d", bottGaps);  // Сохраняем текущее значение в файл
        fclose(file);
    }
}

// Функция для чтения состояния из файла
void load_bottGaps_state() {
    FILE *file = fopen(STATE_FILE_TOGGLEGAPS, "r");
    if (file) {
        fscanf(file, "%d", &bottGaps);  // Читаем значение из файла
        fclose(file);
    }
}

void toggle_bottGaps(const Arg *arg) {
    // Загружаем состояние из файла, если оно есть
    load_bottGaps_state();

    // Формируем команду для запуска и остановки dock
    char command[256];

    if (bottGaps == 0) {
        // Если отступы 0, восстанавливаем сохранённое значение (например, 160 или то, что было сохранено)
        bottGaps = bottgaps;

        // Формируем команду для запуска dock
        snprintf(command, sizeof(command), "%s &", DOCK_NAME);

        // Запускаем dock
        system(command);
    } else {
        // Если отступы больше 0, сбрасываем их в 0
        bottGaps = 0;

        // Формируем команду для остановки dock
        snprintf(command, sizeof(command), "pkill %s", DOCK_NAME);

        // Останавливаем dock
        system(command);
    }

    // Сохраняем новое состояние в файл
    save_bottGaps_state();

    // Перерисовываем окна с новыми отступами
    arrange(NULL);
}
void save_showtitle_state(void)
{
    FILE *file = fopen(STATE_FILE_PATH_TITLE, "w");
    if (file != NULL) {
        fprintf(file, "%d\n", showtitle);
        fclose(file);
    } else {
        fprintf(stderr, "Ошибка: не удалось открыть файл для записи состояния showtitle.\n");
    }
}





void load_showtitle_state(void)
{
    FILE *file = fopen(STATE_FILE_PATH_TITLE, "r");
    if (file != NULL) {
        if (fscanf(file, "%d", &showtitle) != 1) {
            fprintf(stderr, "Ошибка: не удалось считать состояние showtitle из файла.\n");
        }
        fclose(file);
    } else {
        fprintf(stderr, "Ошибка: не удалось открыть файл для чтения состояния showtitle.\n");
    }
}


void saveSmartgapsState(int state) {
    FILE *file = fopen(STATE_FILE_PATH, "w");
    if (file) {
        fprintf(file, "%d\n", state); // Сохраняем состояние smartgaps
        fclose(file);
    } else {
        fprintf(stderr, "Ошибка: не удалось открыть файл для записи состояния smartgaps.\n");
    }
}


int loadSmartgapsState() {
    FILE *file = fopen(STATE_FILE_PATH, "r");
    int state = 1; // Значение по умолчанию (1 = smartgaps включен)
    if (file != NULL) {
        fscanf(file, "%d", &state);
        fclose(file);
    } else {
        fprintf(stderr, "Ошибка: не удалось открыть файл для чтения состояния. Используется значение по умолчанию.\n");
    }
    return state;
}

void toggleSystray(const Arg *arg) {
    showsystray = !showsystray;

    // Сохраняем текущее состояние в файл
    FILE *file = fopen(STATE_FILE_PATH_SYSTRAY, "w");
    if (file) {
        fprintf(file, "%d", showsystray);
        fclose(file);
    }

    // Управление видимостью трея
    if (!showsystray) {
        XUnmapWindow(dpy, systray->win); // Скрыть трей
    } else {
        XMapWindow(dpy, systray->win);   // Показать трей
    }

    updatebarpos(selmon); // Обновляем позиции панели
    arrange(selmon);      // Переразметка окон
    drawbar(selmon);      // Перерисовка панели
}

void loadSystrayState() {
    FILE *file = fopen(STATE_FILE_PATH_SYSTRAY, "r");
    if (file) {
        int state;
        if (fscanf(file, "%d", &state) == 1) {
            showsystray = state; // Восстанавливаем сохранённое состояние
        }
        fclose(file);
    } else {
        showsystray = 1; // Если файл не найден, показываем трей по умолчанию
    }

    // Управляем видимостью трея на основе состояния
    if (!showsystray) {
        XUnmapWindow(dpy, systray->win); // Скрываем трей, если нужно
    } else {
        XMapWindow(dpy, systray->win);   // Показываем трей, если нужно
    }
}


struct Pertag {
	unsigned int curtag, prevtag; /* current and previous tag */
	int nmasters[LENGTH(tags) + 1]; /* number of windows in master area */
	float mfacts[LENGTH(tags) + 1]; /* mfacts per tag */
	unsigned int sellts[LENGTH(tags) + 1]; /* selected layouts */
	const Layout *ltidxs[LENGTH(tags) + 1][2]; /* matrix of tags and layouts indexes  */
	int showbars[LENGTH(tags) + 1]; /* display bar for the current tag */
	Client *sel[LENGTH(tags) + 1]; /* selected client */
};

/* compile-time check if all tags fit into an unsigned int bit array. */
struct NumTags { char limitexceeded[LENGTH(tags) > 31 ? -1 : 1]; };

/* function implementations */
void
applyrules(Client *c)
{
	const char *class, *instance;
	unsigned int i;
	const Rule *r;
	Monitor *m;
	XClassHint ch = { NULL, NULL };

	/* rule matching */
	c->isfloating = 0;
	c->tags = 0;
	XGetClassHint(dpy, c->win, &ch);
	class    = ch.res_class ? ch.res_class : broken;
	instance = ch.res_name  ? ch.res_name  : broken;

	for (i = 0; i < LENGTH(rules); i++) {
		r = &rules[i];
		if ((!r->title || strstr(c->name, r->title))
		&& (!r->class || strstr(class, r->class))
		&& (!r->instance || strstr(instance, r->instance)))
		{
			c->isfloating = r->isfloating;
			c->tags |= r->tags;
			for (m = mons; m && m->num != r->monitor; m = m->next);
			if (m)
				c->mon = m;
		}
	}
	if (ch.res_class)
		XFree(ch.res_class);
	if (ch.res_name)
		XFree(ch.res_name);
	c->tags = c->tags & TAGMASK ? c->tags & TAGMASK : c->mon->tagset[c->mon->seltags];
}

int
applysizehints(Client *c, int *x, int *y, int *w, int *h, int interact)
{
	int baseismin;
	Monitor *m = c->mon;

	/* set minimum possible */
	*w = MAX(1, *w);
	*h = MAX(1, *h);
	if (interact) {
		if (*x > sw)
			*x = sw - WIDTH(c);
		if (*y > sh)
			*y = sh - HEIGHT(c);
		if (*x + *w + 2 * c->bw < 0)
			*x = 0;
		if (*y + *h + 2 * c->bw < 0)
			*y = 0;
	} else {
		if (*x >= m->wx + m->ww)
			*x = m->wx + m->ww - WIDTH(c);
		if (*y >= m->wy + m->wh)
			*y = m->wy + m->wh - HEIGHT(c);
		if (*x + *w + 2 * c->bw <= m->wx)
			*x = m->wx;
		if (*y + *h + 2 * c->bw <= m->wy)
			*y = m->wy;
	}
	if (*h < bh)
		*h = bh;
	if (*w < bh)
		*w = bh;
	if (resizehints || c->isfloating || !c->mon->lt[c->mon->sellt]->arrange) {
		if (!c->hintsvalid)
			updatesizehints(c);
		/* see last two sentences in ICCCM 4.1.2.3 */
		baseismin = c->basew == c->minw && c->baseh == c->minh;
		if (!baseismin) { /* temporarily remove base dimensions */
			*w -= c->basew;
			*h -= c->baseh;
		}
		/* adjust for aspect limits */
		if (c->mina > 0 && c->maxa > 0) {
			if (c->maxa < (float)*w / *h)
				*w = *h * c->maxa + 0.5;
			else if (c->mina < (float)*h / *w)
				*h = *w * c->mina + 0.5;
		}
		if (baseismin) { /* increment calculation requires this */
			*w -= c->basew;
			*h -= c->baseh;
		}
		/* adjust for increment value */
		if (c->incw)
			*w -= *w % c->incw;
		if (c->inch)
			*h -= *h % c->inch;
		/* restore base dimensions */
		*w = MAX(*w + c->basew, c->minw);
		*h = MAX(*h + c->baseh, c->minh);
		if (c->maxw)
			*w = MIN(*w, c->maxw);
		if (c->maxh)
			*h = MIN(*h, c->maxh);
	}
	return *x != c->x || *y != c->y || *w != c->w || *h != c->h;
}



void
arrange(Monitor *m)
{
	if (m)
		showhide(m->stack);
	else for (m = mons; m; m = m->next)
		showhide(m->stack);
	if (m) {
		arrangemon(m);
		restack(m);
	} else for (m = mons; m; m = m->next)
		arrangemon(m);
}

void
arrangemon(Monitor *m)
{
	strncpy(m->ltsymbol, m->lt[m->sellt]->symbol, sizeof m->ltsymbol);
	if (m->lt[m->sellt]->arrange)
		m->lt[m->sellt]->arrange(m);
}


void
attach(Client *c)
{
	c->next = c->mon->clients;
	c->mon->clients = c;
}
void
attachBelow(Client *c)
{
	//If there is nothing on the monitor or the selected client is floating, attach as normal
	if(c->mon->sel == NULL || c->mon->sel == c || c->mon->sel->isfloating) {
		attach(c);
		return;
	}

	//Set the new client's next property to the same as the currently selected clients next
	c->next = c->mon->sel->next;
	//Set the currently selected clients next property to the new client
	c->mon->sel->next = c;

}


#include "attachbelow.h"  // Подключаем заголовочный файл, где объявлена переменная и функции

void toggleAttachBelow() {
    attachbelow = !attachbelow;
    saveAttachBelow();  // Сохраняем состояние после переключения
}


void
attachstack(Client *c)
{
	c->snext = c->mon->stack;
	c->mon->stack = c;
}

void
buttonpress(XEvent *e)
{
	unsigned int i, x, click;
	Arg arg = {0};
	Client *c;
	Monitor *m;
	XButtonPressedEvent *ev = &e->xbutton;

	click = ClkRootWin;
	/* focus monitor if necessary */
	if ((m = wintomon(ev->window)) && m != selmon) {
		unfocus(selmon->sel, 1);
		selmon = m;
		focus(NULL);
	}
	if (ev->window == selmon->barwin) {
		i = x = 0;
		do
			x += TEXTW(tags[i]);
		while (ev->x >= x && ++i < LENGTH(tags));
		if (i < LENGTH(tags)) {
			click = ClkTagBar;
			arg.ui = 1 << i;
		} else if (ev->x < x + TEXTW(selmon->ltsymbol))
			click = ClkLtSymbol;
		else
            click = ClkStatusText;

	} else if ((c = wintoclient(ev->window))) {
		focus(c);
		restack(selmon);
		XAllowEvents(dpy, ReplayPointer, CurrentTime);
		click = ClkClientWin;
	}
	for (i = 0; i < LENGTH(buttons); i++)
		if (click == buttons[i].click && buttons[i].func && buttons[i].button == ev->button
		&& CLEANMASK(buttons[i].mask) == CLEANMASK(ev->state))
			buttons[i].func(click == ClkTagBar && buttons[i].arg.i == 0 ? &arg : &buttons[i].arg);
}

void
checkotherwm(void)
{
	xerrorxlib = XSetErrorHandler(xerrorstart);
	/* this causes an error if some other window manager is running */
	XSelectInput(dpy, DefaultRootWindow(dpy), SubstructureRedirectMask);
	XSync(dpy, False);
	XSetErrorHandler(xerror);
	XSync(dpy, False);
}

void
cleanup(void)
{
	Arg a = {.ui = ~0};
	Layout foo = { "", NULL };
	Monitor *m;
	size_t i;

	view(&a);
	selmon->lt[selmon->sellt] = &foo;
	for (m = mons; m; m = m->next)
		while (m->stack)
			unmanage(m->stack, 0);
	XUngrabKey(dpy, AnyKey, AnyModifier, root);
	while (mons)
		cleanupmon(mons);

	if (showsystray) {
		XUnmapWindow(dpy, systray->win);
		XDestroyWindow(dpy, systray->win);
		free(systray);
	}

	for (i = 0; i < CurLast; i++)
		drw_cur_free(drw, cursor[i]);
	for (i = 0; i < LENGTH(colors); i++)
		free(scheme[i]);
	free(scheme);
	XDestroyWindow(dpy, wmcheckwin);
	drw_free(drw);
	XSync(dpy, False);
	XSetInputFocus(dpy, PointerRoot, RevertToPointerRoot, CurrentTime);
	XDeleteProperty(dpy, root, netatom[NetActiveWindow]);
}

void
cleanupmon(Monitor *mon)
{
	Monitor *m;

	if (mon == mons)
		mons = mons->next;
	else {
		for (m = mons; m && m->next != mon; m = m->next);
		m->next = mon->next;
	}
	XUnmapWindow(dpy, mon->barwin);
	XDestroyWindow(dpy, mon->barwin);
	free(mon);
}

void
clientmessage(XEvent *e)
{
	XWindowAttributes wa;
	XSetWindowAttributes swa;
	XClientMessageEvent *cme = &e->xclient;
	Client *c = wintoclient(cme->window);
	unsigned int i;

	if (showsystray && cme->window == systray->win && cme->message_type == netatom[NetSystemTrayOP]) {
		/* add systray icons */
		if (cme->data.l[1] == SYSTEM_TRAY_REQUEST_DOCK) {
			if (!(c = (Client *)calloc(1, sizeof(Client))))
				die("fatal: could not malloc() %u bytes\n", sizeof(Client));
			if (!(c->win = cme->data.l[2])) {
				free(c);
				return;
			}
			c->mon = selmon;
			c->next = systray->icons;
			systray->icons = c;
			if (!XGetWindowAttributes(dpy, c->win, &wa)) {
				/* use sane defaults */
				wa.width = bh;
				wa.height = bh;
				wa.border_width = 0;
			}
			c->x = c->oldx = c->y = c->oldy = 0;
			c->w = c->oldw = wa.width;
			c->h = c->oldh = wa.height;
			c->oldbw = wa.border_width;
			c->bw = 0;
			c->isfloating = True;
			/* reuse tags field as mapped status */
			c->tags = 1;
			updatesizehints(c);
			updatesystrayicongeom(c, wa.width, wa.height);
			XAddToSaveSet(dpy, c->win);
			XSelectInput(dpy, c->win, StructureNotifyMask | PropertyChangeMask | ResizeRedirectMask);
			XReparentWindow(dpy, c->win, systray->win, 0, 0);
			/* use parents background color */
			swa.background_pixel  = scheme[SchemeNorm][ColBg].pixel;
			XChangeWindowAttributes(dpy, c->win, CWBackPixel, &swa);
			sendevent(c->win, netatom[Xembed], StructureNotifyMask, CurrentTime, XEMBED_EMBEDDED_NOTIFY, 0 , systray->win, XEMBED_EMBEDDED_VERSION);
			/* FIXME not sure if I have to send these events, too */
			sendevent(c->win, netatom[Xembed], StructureNotifyMask, CurrentTime, XEMBED_FOCUS_IN, 0 , systray->win, XEMBED_EMBEDDED_VERSION);
			sendevent(c->win, netatom[Xembed], StructureNotifyMask, CurrentTime, XEMBED_WINDOW_ACTIVATE, 0 , systray->win, XEMBED_EMBEDDED_VERSION);
			sendevent(c->win, netatom[Xembed], StructureNotifyMask, CurrentTime, XEMBED_MODALITY_ON, 0 , systray->win, XEMBED_EMBEDDED_VERSION);
			XSync(dpy, False);
			resizebarwin(selmon);
			updatesystray();
			setclientstate(c, NormalState);
		}
		return;
	}

	if (!c)
		return;
	if (cme->message_type == netatom[NetWMState]) {
		if (cme->data.l[1] == netatom[NetWMFullscreen]
		|| cme->data.l[2] == netatom[NetWMFullscreen])
			setfullscreen(c, (cme->data.l[0] == 1 /* _NET_WM_STATE_ADD    */
				|| (cme->data.l[0] == 2 /* _NET_WM_STATE_TOGGLE */ && !c->isfullscreen)));
	} else if (cme->message_type == netatom[NetActiveWindow]) {
		for (i = 0; i < LENGTH(tags) && !((1 << i) & c->tags); i++);
		if (i < LENGTH(tags)) {
			const Arg a = {.ui = 1 << i};
			selmon = c->mon;
			view(&a);
			focus(c);
			restack(selmon);
		}
	}
}

void
configure(Client *c)
{
	XConfigureEvent ce;

	ce.type = ConfigureNotify;
	ce.display = dpy;
	ce.event = c->win;
	ce.window = c->win;
	ce.x = c->x;
	ce.y = c->y;
	ce.width = c->w;
	ce.height = c->h;
	ce.border_width = c->bw;
	ce.above = None;
	ce.override_redirect = False;
	XSendEvent(dpy, c->win, False, StructureNotifyMask, (XEvent *)&ce);
}


void
configurenotify(XEvent *e)
{
	Monitor *m;
	Client *c;
	XConfigureEvent *ev = &e->xconfigure;
	int dirty;

	/* TODO: updategeom handling sucks, needs to be simplified */
	if (ev->window == root) {
		dirty = (sw != ev->width || sh != ev->height);
		sw = ev->width;
		sh = ev->height;
		if (updategeom() || dirty) {
			drw_resize(drw, sw, bh);
			updatebars();
			for (m = mons; m; m = m->next) {
				for (c = m->clients; c; c = c->next)
					if (c->isfullscreen)
						resizeclient(c, m->mx, m->my, m->mw, m->mh);
				resizebarwin(m);
			}
			focus(NULL);
			arrange(NULL);
		}
	}
}

void
configurerequest(XEvent *e)
{
	Client *c;
	Monitor *m;
	XConfigureRequestEvent *ev = &e->xconfigurerequest;
	XWindowChanges wc;

	if ((c = wintoclient(ev->window))) {
		if (ev->value_mask & CWBorderWidth)
			c->bw = ev->border_width;
		else if (c->isfloating || !selmon->lt[selmon->sellt]->arrange) {
			m = c->mon;
			if (ev->value_mask & CWX) {
				c->oldx = c->x;
				c->x = m->mx + ev->x;
			}
			if (ev->value_mask & CWY) {
				c->oldy = c->y;
				c->y = m->my + ev->y;
			}
			if (ev->value_mask & CWWidth) {
				c->oldw = c->w;
				c->w = ev->width;
			}
			if (ev->value_mask & CWHeight) {
				c->oldh = c->h;
				c->h = ev->height;
			}
			if ((c->x + c->w) > m->mx + m->mw && c->isfloating)
				c->x = m->mx + (m->mw / 2 - WIDTH(c) / 2); /* center in x direction */
			if ((c->y + c->h) > m->my + m->mh && c->isfloating)
				c->y = m->my + (m->mh / 2 - HEIGHT(c) / 2); /* center in y direction */
			if ((ev->value_mask & (CWX|CWY)) && !(ev->value_mask & (CWWidth|CWHeight)))
				configure(c);
			if (ISVISIBLE(c))
				XMoveResizeWindow(dpy, c->win, c->x, c->y, c->w, c->h);
		} else
			configure(c);
	} else {
		wc.x = ev->x;
		wc.y = ev->y;
		wc.width = ev->width;
		wc.height = ev->height;
		wc.border_width = ev->border_width;
		wc.sibling = ev->above;
		wc.stack_mode = ev->detail;
		XConfigureWindow(dpy, ev->window, ev->value_mask, &wc);
	}
	XSync(dpy, False);
}

Monitor *
createmon(void)
{
	Monitor *m;
	unsigned int i;

	m = ecalloc(1, sizeof(Monitor));
	m->tagset[0] = m->tagset[1] = 1;
	m->mfact = mfact;
	m->nmaster = nmaster;
	m->showbar = showbar;
	m->topbar = topbar;
	m->gappih = gappih;
	m->gappiv = gappiv;
	m->gappoh = gappoh;
	m->gappov = gappov;
	m->lt[0] = &layouts[0];
	m->lt[1] = &layouts[1 % LENGTH(layouts)];
	strncpy(m->ltsymbol, layouts[0].symbol, sizeof m->ltsymbol);
	m->pertag = ecalloc(1, sizeof(Pertag));
	m->pertag->curtag = m->pertag->prevtag = 1;

	for (i = 0; i <= LENGTH(tags); i++) {
		m->pertag->nmasters[i] = m->nmaster;
		m->pertag->mfacts[i] = m->mfact;

		m->pertag->ltidxs[i][0] = m->lt[0];
		m->pertag->ltidxs[i][1] = m->lt[1];
		m->pertag->sellts[i] = m->sellt;

		m->pertag->showbars[i] = m->showbar;
	}

	return m;
}

void
destroynotify(XEvent *e)
{
	Client *c;
	XDestroyWindowEvent *ev = &e->xdestroywindow;

	if ((c = wintoclient(ev->window)))
		unmanage(c, 1);
	else if ((c = wintosystrayicon(ev->window))) {
		removesystrayicon(c);
		resizebarwin(selmon);
		updatesystray();
	}
}

void
detach(Client *c)
{
	Client **tc;

	for (tc = &c->mon->clients; *tc && *tc != c; tc = &(*tc)->next);
	*tc = c->next;
}

void
detachstack(Client *c)
{
	Client **tc, *t;

	for (tc = &c->mon->stack; *tc && *tc != c; tc = &(*tc)->snext);
	*tc = c->snext;

	if (c == c->mon->sel) {
		for (t = c->mon->stack; t && !ISVISIBLE(t); t = t->snext);
		c->mon->sel = t;
	}
}

Monitor *
dirtomon(int dir)
{
	Monitor *m = NULL;

	if (dir > 0) {
		if (!(m = selmon->next))
			m = mons;
	} else if (selmon == mons)
		for (m = mons; m->next; m = m->next);
	else
		for (m = mons; m->next != selmon; m = m->next);
	return m;
}

void
drawbars(void)
{
	Monitor *m;

	for (m = mons; m; m = m->next)
		drawbar(m);
}

void
enternotify(XEvent *e)
{
	Client *c;
	Monitor *m;
	XCrossingEvent *ev = &e->xcrossing;

	if ((ev->mode != NotifyNormal || ev->detail == NotifyInferior) && ev->window != root)
		return;
	c = wintoclient(ev->window);
	m = c ? c->mon : wintomon(ev->window);
	if (m != selmon) {
		unfocus(selmon->sel, 1);
		selmon = m;
	} else if (!c || c == selmon->sel)
		return;
	focus(c);
}

void
expose(XEvent *e)
{
	Monitor *m;
	XExposeEvent *ev = &e->xexpose;

	if (ev->count == 0 && (m = wintomon(ev->window))) {
		drawbar(m);
		if (m == selmon)
			updatesystray();
	}
}


int isWindowIgnored(Client *c) {
    const char **ignore = focusIgnore;  // Указатель на массив с именами окон
    XClassHint class_hint;  // Структура для хранения информации о классе окна

    // Получаем информацию о классе окна
    if (XGetClassHint(dpy, c->win, &class_hint)) {  // Передаем указатель на class_hint
        while (*ignore) {
            if (strstr(class_hint.res_class, *ignore)) {  // Проверяем, есть ли совпадение
                return 1;  // Окно игнорируется, возвращаем 1
            }
            ignore++;
        }
    }

    return 0;  // Фокус можно установить для этого окна
}


void updateworkarea(void) {
    long workarea[4];

    // Корректировка рабочей области для текущего монитора
    workarea[0] = selmon->wx; // x
    workarea[1] = selmon->wy + (selmon->showbar ? bh : 0); // y с учётом панели
    workarea[2] = selmon->ww; // ширина
    workarea[3] = selmon->wh - (selmon->showbar ? bh : 0); // высота с учётом панели

    XChangeProperty(dpy, root, netatom[NetWorkarea], XA_CARDINAL, 32,
                    PropModeReplace, (unsigned char *)workarea, 4);
}
void
focus(Client *c)
{
    // Если окно игнорируется или не видно, ищем следующее в стеке
    if (!c || !ISVISIBLE(c) || isWindowIgnored(c)) {
        for (c = selmon->stack; c && (!ISVISIBLE(c) || isWindowIgnored(c)); c = c->snext);
    }

    // Снимаем фокус с предыдущего окна, если оно существует и отличается от нового
    if (selmon->sel && selmon->sel != c) {
        unfocus(selmon->sel, 0);
    }

    if (c) {
        // Если окно на другом мониторе, переключаемся на его монитор
        if (c->mon != selmon) {
            selmon = c->mon;
        }

        // Снимаем статус "тревожного" окна
        if (c->isurgent) {
            seturgent(c, 0);
        }

        // Перемещаем окно в стек
        detachstack(c);
        attachstack(c);

        // Устанавливаем фокус на окно
        grabbuttons(c, 1);
        XSetWindowBorder(dpy, c->win, scheme[SchemeSel][ColBorder].pixel);
        setfocus(c);

        // Обновляем _NET_ACTIVE_WINDOW
        XChangeProperty(dpy, root, netatom[NetActiveWindow], XA_WINDOW, 32,
                        PropModeReplace, (unsigned char *)&(c->win), 1);
    } else {
        // Если нет активного окна, устанавливаем фокус на корневое окно
        XSetInputFocus(dpy, root, RevertToPointerRoot, CurrentTime);
        XDeleteProperty(dpy, root, netatom[NetActiveWindow]);
    }

    // Поднимаем DOCK окна наверх, чтобы они не перекрывались
    for (Client *dock = selmon->clients; dock; dock = dock->next) {
        if (ISDOCK(dock)) {
            XRaiseWindow(dpy, dock->win);
        }
    }

    // Обновляем выбранное окно
    selmon->sel = c;
    selmon->pertag->sel[selmon->pertag->curtag] = c;

    // Перерисовываем панели
    drawbars();
}


void
grabbuttons(Client *c, int focused)
{
    updatenumlockmask();
    {
        unsigned int i, j;
        unsigned int modifiers[] = { 0, LockMask, numlockmask, numlockmask|LockMask };
        XUngrabButton(dpy, AnyButton, AnyModifier, c->win);
        if (!focused)
            XGrabButton(dpy, AnyButton, AnyModifier, c->win, False,
                        BUTTONMASK, GrabModeSync, GrabModeSync, None, None);
        for (i = 0; i < LENGTH(buttons); i++)
            if (buttons[i].click == ClkClientWin)
                for (j = 0; j < LENGTH(modifiers); j++)
                    XGrabButton(dpy, buttons[i].button,
                                buttons[i].mask | modifiers[j],
                                c->win, False, BUTTONMASK,
                                GrabModeAsync, GrabModeSync, None, None);
    }
}



/* there are some broken focus acquiring clients needing extra handling */
void
focusin(XEvent *e)
{
	XFocusChangeEvent *ev = &e->xfocus;

	if (selmon->sel && ev->window != selmon->sel->win)
		setfocus(selmon->sel);
}

void
focusmon(const Arg *arg)
{
	Monitor *m;

	if (!mons->next)
		return;
	if ((m = dirtomon(arg->i)) == selmon)
		return;
	unfocus(selmon->sel, 0);
	selmon = m;
	focus(NULL);
}

void
focusstack(const Arg *arg)
{
	Client *c = NULL, *i;

	if (!selmon->sel || (selmon->sel->isfullscreen && lockfullscreen))
		return;
	if (arg->i > 0) {
		for (c = selmon->sel->next; c && !ISVISIBLE(c); c = c->next);
		if (!c)
			for (c = selmon->clients; c && !ISVISIBLE(c); c = c->next);
	} else {
		for (i = selmon->clients; i != selmon->sel; i = i->next)
			if (ISVISIBLE(i))
				c = i;
		if (!c)
			for (; i; i = i->next)
				if (ISVISIBLE(i))
					c = i;
	}
	if (c) {
		focus(c);
		restack(selmon);
	}
}

Atom
getatomprop(Client *c, Atom prop)
{
	int di;
	unsigned long dl;
	unsigned char *p = NULL;
	Atom da, atom = None;

	/* FIXME getatomprop should return the number of items and a pointer to
	 * the stored data instead of this workaround */
	Atom req = XA_ATOM;
	if (prop == xatom[XembedInfo])
		req = xatom[XembedInfo];

	if (XGetWindowProperty(dpy, c->win, prop, 0L, sizeof atom, False, req,
		&da, &di, &dl, &dl, &p) == Success && p) {
		atom = *(Atom *)p;
		if (da == xatom[XembedInfo] && dl == 2)
			atom = ((Atom *)p)[1];
		XFree(p);
	}
	return atom;
}

unsigned int
getsystraywidth()
{
	unsigned int w = 0;
	Client *i;
	if(showsystray)
		for(i = systray->icons; i; w += i->w + systrayspacing, i = i->next) ;
	return w ? w + systrayspacing : 1;
}

int
getrootptr(int *x, int *y)
{
	int di;
	unsigned int dui;
	Window dummy;

	return XQueryPointer(dpy, root, &dummy, &dummy, x, y, &di, &di, &dui);
}

long
getstate(Window w)
{
	int format;
	long result = -1;
	unsigned char *p = NULL;
	unsigned long n, extra;
	Atom real;

	if (XGetWindowProperty(dpy, w, wmatom[WMState], 0L, 2L, False, wmatom[WMState],
		&real, &format, &n, &extra, (unsigned char **)&p) != Success)
		return -1;
	if (n != 0)
		result = *p;
	XFree(p);
	return result;
}

int
gettextprop(Window w, Atom atom, char *text, unsigned int size)
{
	char **list = NULL;
	int n;
	XTextProperty name;

	if (!text || size == 0)
		return 0;
	text[0] = '\0';
	if (!XGetTextProperty(dpy, w, &name, atom) || !name.nitems)
		return 0;
	if (name.encoding == XA_STRING) {
		strncpy(text, (char *)name.value, size - 1);
	} else if (XmbTextPropertyToTextList(dpy, &name, &list, &n) >= Success && n > 0 && *list) {
		strncpy(text, *list, size - 1);
		XFreeStringList(list);
	}
	text[size - 1] = '\0';
	XFree(name.value);
	return 1;
}



void
drawbar(Monitor *m)
{
    int x, w, tw = 0, stw = 0;
    unsigned int i, occ = 0, urg = 0;
    Client *c;

    if (!m->showbar)
        return;

    /* Убираем padding для системного трея */
    if (showsystray && m == systraytomon(m) && !systrayonleft)
        stw = getsystraywidth();

    x = 0;

    /* Отрисовка статуса (только для выбранного монитора) */
    if (m == selmon) {
        drw_setscheme(drw, scheme[SchemeNorm]);
        tw = TEXTW(stext) - lrpad / 2 + 2;
        drw_text(drw, m->ww - tw - stw, 0, tw, bh, lrpad / 2 - 2, stext, 0);
    }

    resizebarwin(m);

    /* Собираем информацию о тегах */
    for (c = m->clients; c; c = c->next) {
        /* Игнорируем окна, прикрепленные ко всем тегам */
        if (c->tags != ~0)
            occ |= c->tags;

        if (c->isurgent)
            urg |= c->tags;
    }

    /* Отрисовка тегов с линиями */
    for (i = 0; i < LENGTH(tags); i++) {
        w = TEXTW(tags[i]);

        /* Выбор цвета для текущего тега */
        drw_setscheme(drw, scheme[m->tagset[m->seltags] & 1 << i ? SchemeSel : SchemeNorm]);

        /* Отрисовка названия тега */
        drw_text(drw, x, 0, w, bh, lrpad / 2, tags[i], urg & 1 << i);

    if (occ & 1 << i) {
        // Рассчитываем отступ, чтобы линия была по центру
        int line_width = w - 8;  // Ширина линии (уменьшаем на 8 пикселей)
    
        // Переключение между тремя режимами
        if (show_tag_boxes == 1) {
        // Режим 1: Увеличиваем ширину и высоту, сдвиг вверх на 23 пикселя
        int line_height = 1;  // Базовая высота линии
        if (m->tagset[m->seltags] & 1 << i) {
            line_width += 4;  // Увеличиваем ширину линии для активного тега
            line_height += 1; // Увеличиваем высоту линии для активного тега
        }

        // Сдвигаем линию по центру
        int line_offset = (w - line_width) / 2;  // Сдвиг для центрирования линии

        // Перемещаем линию вверх
        int line_y_position = bh - line_height - 23;  // Сдвигаем линию вверх на 23 пикселя

        // Рисуем линию по центру с измененной высотой и новым вертикальным смещением
        drw_rect(drw, x + line_offset, line_y_position, line_width, line_height, 1, 0);  // Линия по центру
    }
    else if (show_tag_boxes == 2) {
        // Режим 2: Увеличиваем ширину и высоту, но без сдвига
        int line_height = 1;  // Базовая высота линии
        if (m->tagset[m->seltags] & 1 << i) {
            line_width += 2;  // Увеличиваем ширину линии для активного тега
            line_height += 1; // Увеличиваем высоту линии для активного тега
        }

        // Сдвигаем линию по центру
        int line_offset = (w - line_width) / 2;  // Сдвиг для центрирования линии

        // Рисуем линию по центру с измененной высотой
        drw_rect(drw, x + line_offset, bh - line_height, line_width, line_height, 1, 0);  // Линия по центру
    }
    else if (show_tag_boxes == 3) {
        // Режим 3: Отображение стандартных квадратиков
        drw_rect(drw, x + 6, bh - 20, 5, 5, 1, 0);  // Стандартные квадратики
    }else if (show_tag_boxes == 4) {
        // Режим 4: Отображение стандартных квадратиков
        drw_rect(drw, x + 0, bh - 0, 0, 0, 0, 0);  // Стандартные квадратики
    }

}
        x += w;
    }

    /* Символ компоновки */
    w = TEXTW(m->ltsymbol);
    drw_setscheme(drw, scheme[SchemeNorm]);
    x = drw_text(drw, x, 0, w, bh, lrpad / 2, m->ltsymbol, 0);

    /* Отрисовка заголовков окон (awesomebar) */
    if ((w = m->ww - tw - stw - x) > bh) {
        if (showtitle) {
            int n = 0;
            for (c = m->clients; c; c = c->next)
                if (ISVISIBLE(c))
                    n++;
            if (n > 0) {
                int tabw = (w - 2 * lrpad) / n;
                if (tabw < 50) tabw = 50;
                for (c = m->clients; c; c = c->next) {
                    if (!ISVISIBLE(c))
                        continue;

                    if (c == m->sel) {
                        drw_setscheme(drw, scheme[SchemeLine]);
                        drw_rect(drw, x, 0, tabw, 4, 1, 0);
                    } else {
                        drw_setscheme(drw, scheme[SchemeNorm]);
                        drw_rect(drw, x, 0, tabw, 4, 1, 1);
                    }

                    drw_setscheme(drw, scheme[m->sel == c ? SchemeTitleSel : SchemeTitle]);
                    drw_text(drw, x, 6, tabw, bh - 6, lrpad / 2, c->name, 0);
                    x += tabw;
                }
            } else {
                drw_setscheme(drw, scheme[SchemeNorm]);
                drw_rect(drw, x, 0, w, bh, 1, 1);
            }
        } else {
            drw_setscheme(drw, scheme[SchemeNorm]);
            drw_rect(drw, x, 0, w, bh, 1, 1);
        }
    }

    /* Обновление панели без padding для системного трея */
    drw_map(drw, m->barwin, 0, 0, m->ww - stw, bh);
}


void MINIBOXloadState() {
    FILE *inputFile = fopen(CURRENTS_MINIBOX, "r");
    if (inputFile != NULL) {
        fscanf(inputFile, "%d", &show_tag_boxes); // Считываем значение из файла
        fclose(inputFile);
    }
}

void MINIBOXsaveState() {
    FILE *outputFile = fopen(CURRENTS_MINIBOX, "w");
    if (outputFile != NULL) {
        fprintf(outputFile, "%d", show_tag_boxes); // Записываем значение в файл
        fclose(outputFile);
    }
}
// Изменение функции toggleTagBoxes
void toggleTagBoxes(const Arg *arg) {
    if (show_tag_boxes == 1) {
        show_tag_boxes = 2;
    } else if (show_tag_boxes == 2) {
        show_tag_boxes = 3;
    } else if (show_tag_boxes == 3) {
        show_tag_boxes = 1;
    } else if (show_tag_boxes == 4) {
        show_tag_boxes = 4;
    }


    // Сохраняем новое состояние
    MINIBOXsaveState(); // Функция сохранения
}


void toggleshowtitle(const Arg *arg)
{
    showtitle = !showtitle; // Переключаем состояние
    save_showtitle_state(); // Убедитесь, что эта функция существует и сохраняет состояние
    drawbars();             // Обновляем панель
}
void
grabkeys(void)
{
	updatenumlockmask();
	{
		/* unsigned int i, j, k; */
		unsigned int i, c, k;
		unsigned int modifiers[] = { 0, LockMask, numlockmask, numlockmask|LockMask };
		int start, end, skip;
		KeySym *syms;

		XUngrabKey(dpy, AnyKey, AnyModifier, root);
		XDisplayKeycodes(dpy, &start, &end);
		syms = XGetKeyboardMapping(dpy, start, end - start + 1, &skip);
		if (!syms)
			return;

		for (k = start; k <= end; k++)
			for (i = 0; i < LENGTH(keychords); i++)
				/* skip modifier codes, we do that ourselves */
				if (keychords[i]->keys[currentkey].keysym == syms[(k - start) * skip])
					for (c = 0; c < LENGTH(modifiers); c++)
						XGrabKey(dpy, k,
							 keychords[i]->keys[currentkey].mod | modifiers[c],
							 root, True,
							 GrabModeAsync, GrabModeAsync);
                if(currentkey > 0)
                        XGrabKey(dpy, XKeysymToKeycode(dpy, XK_Escape), AnyModifier, root, True, GrabModeAsync, GrabModeAsync);
		XFree(syms);
	}
}

void
incnmaster(const Arg *arg)
{
	selmon->nmaster = selmon->pertag->nmasters[selmon->pertag->curtag] = MAX(selmon->nmaster + arg->i, 0);
	arrange(selmon);
}

#ifdef XINERAMA
static int
isuniquegeom(XineramaScreenInfo *unique, size_t n, XineramaScreenInfo *info)
{
	while (n--)
		if (unique[n].x_org == info->x_org && unique[n].y_org == info->y_org
		&& unique[n].width == info->width && unique[n].height == info->height)
			return 0;
	return 1;
}
#endif /* XINERAMA */

void
keypress(XEvent *e)
{
	/* unsigned int i; */
    XEvent event = *e;
    unsigned int ran = 0;
	KeySym keysym;
	XKeyEvent *ev;

    Keychord *arr1[sizeof(keychords) / sizeof(Keychord*)];
    Keychord *arr2[sizeof(keychords) / sizeof(Keychord*)];
    memcpy(arr1, keychords, sizeof(keychords));
    Keychord **rpointer = arr1;
    Keychord **wpointer = arr2;

    size_t r = sizeof(keychords)/ sizeof(Keychord*);

    while(1){
            ev = &event.xkey;
            keysym = XKeycodeToKeysym(dpy, (KeyCode)ev->keycode, 0);
            size_t w = 0;
            for (int i = 0; i < r; i++){
                    if(keysym == (*(rpointer + i))->keys[currentkey].keysym
                       && CLEANMASK((*(rpointer + i))->keys[currentkey].mod) == CLEANMASK(ev->state)
                       && (*(rpointer + i))->func){
                            if((*(rpointer + i))->n == currentkey +1){
                                    (*(rpointer + i))->func(&((*(rpointer + i))->arg));
                                    ran = 1;
                            }else{
                                    *(wpointer + w) = *(rpointer + i);
                                    w++;
                            }
                    }
            }
            currentkey++;
            if(w == 0 || ran == 1)
                    break;
            grabkeys();
            while (running && !XNextEvent(dpy, &event) && !ran)
                    if(event.type == KeyPress)
                            break;
            r = w;
            Keychord **holder = rpointer;
            rpointer = wpointer;
            wpointer = holder;
    }
    currentkey = 0;
    grabkeys();
}

void
killclient(const Arg *arg)
{
	if (!selmon->sel)
		return;

	if (!sendevent(selmon->sel->win, wmatom[WMDelete], NoEventMask, wmatom[WMDelete], CurrentTime, 0 , 0, 0)) {
		XGrabServer(dpy);
		XSetErrorHandler(xerrordummy);
		XSetCloseDownMode(dpy, DestroyAll);
		XKillClient(dpy, selmon->sel->win);
		XSync(dpy, False);
		XSetErrorHandler(xerror);
		XUngrabServer(dpy);
	}
}





void
manage(Window w, XWindowAttributes *wa)
{
    Client *c, *t = NULL;
    Window trans = None;
    XWindowChanges wc;

    c = ecalloc(1, sizeof(Client));
    c->win = w;
    /* geometry */
    c->x = c->oldx = wa->x;
    c->y = c->oldy = wa->y;
    c->w = c->oldw = wa->width;
    c->h = c->oldh = wa->height;
    c->oldbw = wa->border_width;
    c->cfact = 1.0;

    updatetitle(c);

    // Проверка на _NET_WM_WINDOW_TYPE_DOCK
    Atom type = None;
    unsigned char *data = NULL;
    int format;
    unsigned long nitems, bytes_after;

    if (XGetWindowProperty(dpy, w, netatom[NetWMWindowType], 0L, 1L, False, XA_ATOM,
                           &type, &format, &nitems, &bytes_after, &data) == Success && data) {
        if (*(Atom *)data == netatom[NetWMWindowTypeDock]) {
            XFree(data);

            // Учитываем _NET_WM_STRUT_PARTIAL, если оно есть
            long struts[4] = {0};
            if (XGetWindowProperty(dpy, w, XInternAtom(dpy, "_NET_WM_STRUT_PARTIAL", False),
                                   0L, 4L, False, XA_CARDINAL, &type, &format,
                                   &nitems, &bytes_after, (unsigned char **)&data) == Success && data) {
                memcpy(struts, data, sizeof(long) * 4);
                XFree(data);

                // Корректируем область монитора
                if (struts[0] > 0) selmon->wx += struts[0]; // Левый
                if (struts[1] > 0) selmon->ww -= struts[1]; // Правый
                if (struts[2] > 0) selmon->wy += struts[2]; // Верхний
                if (struts[3] > 0) selmon->wh -= struts[3]; // Нижний
            }

            // Поднимаем окно наверх и отображаем
            XRaiseWindow(dpy, w);
            XMapWindow(dpy, w);

            // Добавляем DOCK окно в _NET_CLIENT_LIST
            XChangeProperty(dpy, root, netatom[NetClientList], XA_WINDOW, 32,
                            PropModeAppend, (unsigned char *)&w, 1);

            // DOCK окна не добавляются в общий список клиентов
            free(c);
            return;
        }
        XFree(data);
    }

    // Если это transient окно, наследуем теги
    if (XGetTransientForHint(dpy, w, &trans) && (t = wintoclient(trans))) {
        c->mon = t->mon;
        c->tags = t->tags;
    } else {
        c->mon = selmon;
        applyrules(c);
    }

    // Восстановление тегов и мониторинга
    {
        int format;
        unsigned long *data, n, extra;
        Monitor *m;
        Atom atom;

        if (XGetWindowProperty(dpy, c->win, netatom[NetClientInfo], 0L, 2L, False, XA_CARDINAL,
                               &atom, &format, &n, &extra, (unsigned char **)&data) == Success && n == 2) {
            c->tags = *data;
            for (m = mons; m; m = m->next) {
                if (m->num == *(data + 1)) {
                    c->mon = m;
                    break;
                }
            }
        }
        if (n > 0)
            XFree(data);
    }

    setclienttagprop(c); /* Устанавливаем сохранённые теги */

    // Логика обработки класса окна
    char class[256] = "";
    XClassHint ch = { NULL, NULL };

    if (XGetClassHint(dpy, c->win, &ch)) {
        if (ch.res_class)
            strncpy(class, ch.res_class, sizeof(class) - 1);

        // Проверка на принадлежность к alltags_apps
        if (is_alltags_app(class)) {
            c->tags = ~0; // Устанавливаем окно на все теги
        }

        // Устанавливаем бордеры
        if (is_noborder_app(class)) {
            c->bw = 0; // Убираем границы
        } else {
            c->bw = borderpx; // Устанавливаем стандартные границы
        }

        if (ch.res_class)
            XFree(ch.res_class);
        if (ch.res_name)
            XFree(ch.res_name);
    } else {
        c->bw = borderpx; // Если класс не удалось определить, применяем стандартные границы
    }

    wc.border_width = c->bw;
    XConfigureWindow(dpy, w, CWBorderWidth, &wc);
    XSetWindowBorder(dpy, w, scheme[SchemeNorm][ColBorder].pixel);
    configure(c);
    updatewindowtype(c);
    updatesizehints(c);
    updatewmhints(c);

    // Центрируем окно, если оно плавающее
    if (c->isfloating) {
        c->x = c->mon->mx + (c->mon->mw - WIDTH(c)) / 2;
        c->y = c->mon->my + (c->mon->mh - HEIGHT(c)) / 2;
        XMoveWindow(dpy, c->win, c->x, c->y);
        XRaiseWindow(dpy, c->win);
    }

    if (attachbelow)
        attachBelow(c);
    else
        attach(c);

    attachstack(c);
    XChangeProperty(dpy, root, netatom[NetClientList], XA_WINDOW, 32, PropModeAppend,
                    (unsigned char *)&(c->win), 1);
    XMoveResizeWindow(dpy, c->win, c->x + 2 * sw, c->y, c->w, c->h);
    setclientstate(c, NormalState);

    if (c->mon == selmon)
        unfocus(selmon->sel, 0);

    c->mon->sel = c;
    arrange(c->mon);
    XMapWindow(dpy, c->win);

    // Обновляем _NET_CLIENT_LIST
    updateclientlist();

    focus(NULL);
}


int is_noborder_app(const char *class) {
    for (int i = 0; noborder_apps[i]; i++) {
        if (strstr(class, noborder_apps[i]))
            return 1;
    }
    return 0;
}

int is_alltags_app(const char *class) {
    for (int i = 0; alltags_apps[i]; i++) {
        if (strstr(class, alltags_apps[i]))
            return 1; 
    }
    return 0; 
}



void
mappingnotify(XEvent *e)
{
	XMappingEvent *ev = &e->xmapping;

	XRefreshKeyboardMapping(ev);
	if (ev->request == MappingKeyboard)
		grabkeys();
}

void
maprequest(XEvent *e)
{
	static XWindowAttributes wa;
	XMapRequestEvent *ev = &e->xmaprequest;

	Client *i;
	if ((i = wintosystrayicon(ev->window))) {
		sendevent(i->win, netatom[Xembed], StructureNotifyMask, CurrentTime, XEMBED_WINDOW_ACTIVATE, 0, systray->win, XEMBED_EMBEDDED_VERSION);
		resizebarwin(selmon);
		updatesystray();
	}

	if (!XGetWindowAttributes(dpy, ev->window, &wa) || wa.override_redirect)
		return;
	if (!wintoclient(ev->window))
		manage(ev->window, &wa);
}

void
motionnotify(XEvent *e)
{
	static Monitor *mon = NULL;
	Monitor *m;
	XMotionEvent *ev = &e->xmotion;

	if (ev->window != root)
		return;
	if ((m = recttomon(ev->x_root, ev->y_root, 1, 1)) != mon && mon) {
		unfocus(selmon->sel, 1);
		selmon = m;
		focus(NULL);
	}
	mon = m;
}

void
movemouse(const Arg *arg)
{
	int x, y, ocx, ocy, nx, ny;
	Client *c;
	Monitor *m;
	XEvent ev;
	Time lasttime = 0;

	if (!(c = selmon->sel))
		return;
	if (c->isfullscreen) /* no support moving fullscreen windows by mouse */
		return;
	restack(selmon);
	ocx = c->x;
	ocy = c->y;
	if (XGrabPointer(dpy, root, False, MOUSEMASK, GrabModeAsync, GrabModeAsync,
		None, cursor[CurMove]->cursor, CurrentTime) != GrabSuccess)
		return;
	if (!getrootptr(&x, &y))
		return;
	do {
		XMaskEvent(dpy, MOUSEMASK|ExposureMask|SubstructureRedirectMask, &ev);
		switch(ev.type) {
		case ConfigureRequest:
		case Expose:
		case MapRequest:
			handler[ev.type](&ev);
			break;
		case MotionNotify:
			if ((ev.xmotion.time - lasttime) <= (1000 / 60))
				continue;
			lasttime = ev.xmotion.time;

			nx = ocx + (ev.xmotion.x - x);
			ny = ocy + (ev.xmotion.y - y);
			if (abs(selmon->wx - nx) < snap)
				nx = selmon->wx;
			else if (abs((selmon->wx + selmon->ww) - (nx + WIDTH(c))) < snap)
				nx = selmon->wx + selmon->ww - WIDTH(c);
			if (abs(selmon->wy - ny) < snap)
				ny = selmon->wy;
			else if (abs((selmon->wy + selmon->wh) - (ny + HEIGHT(c))) < snap)
				ny = selmon->wy + selmon->wh - HEIGHT(c);
			if (!selmon->lt[selmon->sellt]->arrange || c->isfloating)
				resize(c, nx, ny, c->w, c->h, 1);
			else if (selmon->lt[selmon->sellt]->arrange || !c->isfloating) {
				if ((m = recttomon(ev.xmotion.x_root, ev.xmotion.y_root, 1, 1)) != selmon) {
					sendmon(c, m);
					selmon = m;
					focus(NULL);
				}

				Client *cc = c->mon->clients;
				while (1) {
					if (cc == 0) break;
					if(
					 cc != c && !cc->isfloating && ISVISIBLE(cc) &&
					 ev.xmotion.x_root > cc->x &&
					 ev.xmotion.x_root < cc->x + cc->w &&
					 ev.xmotion.y_root > cc->y &&
					 ev.xmotion.y_root < cc->y + cc->h ) {
						break;
					}

					cc = cc->next;
				}

				if (cc) {
					Client *cl1, *cl2, ocl1;
					
					if (!selmon->lt[selmon->sellt]->arrange) return;

					cl1 = c;
					cl2 = cc;
					ocl1 = *cl1;
					strcpy(cl1->name, cl2->name);
					cl1->win = cl2->win;
					cl1->x = cl2->x;
					cl1->y = cl2->y;
					cl1->w = cl2->w;
					cl1->h = cl2->h;
					
					cl2->win = ocl1.win;
					strcpy(cl2->name, ocl1.name);
					cl2->x = ocl1.x;
					cl2->y = ocl1.y;
					cl2->w = ocl1.w;
					cl2->h = ocl1.h;
					
					selmon->sel = cl2;

					c = cc;
					focus(c);
					
					arrange(cl1->mon);
				}
			}
			break;
		}
	} while (ev.type != ButtonRelease);
	XUngrabPointer(dpy, CurrentTime);
	if ((m = recttomon(c->x, c->y, c->w, c->h)) != selmon) {
		sendmon(c, m);
		selmon = m;
		focus(NULL);
	}
}

void
moveresize(const Arg *arg) {
	/* only floating windows can be moved */
	Client *c;
	c = selmon->sel;
	int x, y, w, h, nx, ny, nw, nh, ox, oy, ow, oh;
	char xAbs, yAbs, wAbs, hAbs;
	int msx, msy, dx, dy, nmx, nmy;
	unsigned int dui;
	Window dummy;

	if (!c || !arg)
		return;
	if (selmon->lt[selmon->sellt]->arrange && !c->isfloating)
		return;
	if (sscanf((char *)arg->v, "%d%c %d%c %d%c %d%c", &x, &xAbs, &y, &yAbs, &w, &wAbs, &h, &hAbs) != 8)
		return;

	/* compute new window position; prevent window from be positioned outside the current monitor */
	nw = c->w + w;
	if (wAbs == 'W')
		nw = w < selmon->mw - 2 * c->bw ? w : selmon->mw - 2 * c->bw;

	nh = c->h + h;
	if (hAbs == 'H')
		nh = h < selmon->mh - 2 * c->bw ? h : selmon->mh - 2 * c->bw;

	nx = c->x + x;
	if (xAbs == 'X') {
		if (x < selmon->mx)
			nx = selmon->mx;
		else if (x > selmon->mx + selmon->mw)
			nx = selmon->mx + selmon->mw - nw - 2 * c->bw;
		else
			nx = x;
	}

	ny = c->y + y;
	if (yAbs == 'Y') {
		if (y < selmon->my)
			ny = selmon->my;
		else if (y > selmon->my + selmon->mh)
			ny = selmon->my + selmon->mh - nh - 2 * c->bw;
		else
			ny = y;
	}

	ox = c->x;
	oy = c->y;
	ow = c->w;
	oh = c->h;

	XRaiseWindow(dpy, c->win);
	Bool xqp = XQueryPointer(dpy, root, &dummy, &dummy, &msx, &msy, &dx, &dy, &dui);
	resize(c, nx, ny, nw, nh, True);

	/* move cursor along with the window to avoid problems caused by the sloppy focus */
	if (xqp && ox <= msx && (ox + ow) >= msx && oy <= msy && (oy + oh) >= msy)
	{
		nmx = c->x - ox + c->w - ow;
		nmy = c->y - oy + c->h - oh;
		/* make sure the cursor stays inside the window */
		if ((msx + nmx) > c->x && (msy + nmy) > c->y)
			XWarpPointer(dpy, None, None, 0, 0, 0, 0, nmx, nmy);
	}
}

void
moveresizeedge(const Arg *arg) {
	/* move or resize floating window to edge of screen */
	Client *c;
	c = selmon->sel;
	char e;
	int nx, ny, nw, nh, ox, oy, ow, oh, bp;
	int msx, msy, dx, dy, nmx, nmy;
	int starty;
	unsigned int dui;
	Window dummy;

	nx = c->x;
	ny = c->y;
	nw = c->w;
	nh = c->h;

	starty = selmon->showbar && topbar ? bh : 0;
	bp = selmon->showbar && !topbar ? bh : 0;

	if (!c || !arg)
		return;
	if (selmon->lt[selmon->sellt]->arrange && !c->isfloating)
		return;
	if(sscanf((char *)arg->v, "%c", &e) != 1)
		return;

	if(e == 't')
		ny = starty;

	if(e == 'b')
		ny = c->h > selmon->mh - 2 * c->bw ? c->h - bp : selmon->mh - c->h - 2 * c->bw - bp;

	if(e == 'l')
		nx = selmon->mx;

	if(e == 'r')
		nx = c->w > selmon->mw - 2 * c->bw ? selmon->mx + c->w : selmon->mx + selmon->mw - c->w - 2 * c->bw;

	if(e == 'T') {
		/* if you click to resize again, it will return to old size/position */
		if(c->h + starty == c->oldh + c->oldy) {
			nh = c->oldh;
			ny = c->oldy;
		} else {
			nh = c->h + c->y - starty;
			ny = starty;
		}
	}

	if(e == 'B')
		nh = c->h + c->y + 2 * c->bw + bp == selmon->mh ? c->oldh : selmon->mh - c->y - 2 * c->bw - bp;

	if(e == 'L') {
		if(selmon->mx + c->w == c->oldw + c->oldx) {
			nw = c->oldw;
			nx = c->oldx;
		} else {
			nw = c->w + c->x - selmon->mx;
			nx = selmon->mx;
		}
	}

	if(e == 'R')
		nw = c->w + c->x + 2 * c->bw == selmon->mx + selmon->mw ? c->oldw : selmon->mx + selmon->mw - c->x - 2 * c->bw;

	ox = c->x;
	oy = c->y;
	ow = c->w;
	oh = c->h;

	XRaiseWindow(dpy, c->win);
	Bool xqp = XQueryPointer(dpy, root, &dummy, &dummy, &msx, &msy, &dx, &dy, &dui);
	resizeclient(c, nx, ny, nw, nh);

	/* move cursor along with the window to avoid problems caused by the sloppy focus */
	if (xqp && ox <= msx && (ox + ow) >= msx && oy <= msy && (oy + oh) >= msy) {
		nmx = c->x - ox + c->w - ow;
		nmy = c->y - oy + c->h - oh;
		/* make sure the cursor stays inside the window */
		if ((msx + nmx) > c->x && (msy + nmy) > c->y)
			XWarpPointer(dpy, None, None, 0, 0, 0, 0, nmx, nmy);
	}
}

Client *
nexttiled(Client *c)
{
	for (; c && (c->isfloating || !ISVISIBLE(c)); c = c->next);
	return c;
}

void
pop(Client *c)
{
	detach(c);
	attach(c);
	focus(c);
	arrange(c->mon);
}

void
propertynotify(XEvent *e)
{
	Client *c;
	Window trans;
	XPropertyEvent *ev = &e->xproperty;

	if ((c = wintosystrayicon(ev->window))) {
		if (ev->atom == XA_WM_NORMAL_HINTS) {
			updatesizehints(c);
			updatesystrayicongeom(c, c->w, c->h);
		}
		else
			updatesystrayiconstate(c, ev);
		resizebarwin(selmon);
		updatesystray();
	}

	if ((ev->window == root) && (ev->atom == XA_WM_NAME))
		updatestatus();
	else if (ev->state == PropertyDelete)
		return; /* ignore */
	else if ((c = wintoclient(ev->window))) {
		switch(ev->atom) {
		default: break;
		case XA_WM_TRANSIENT_FOR:
			if (!c->isfloating && (XGetTransientForHint(dpy, c->win, &trans)) &&
				(c->isfloating = (wintoclient(trans)) != NULL))
				arrange(c->mon);
			break;
		case XA_WM_NORMAL_HINTS:
			c->hintsvalid = 0;
			break;
		case XA_WM_HINTS:
			updatewmhints(c);
			drawbars();
			break;
		}
		if (ev->atom == XA_WM_NAME || ev->atom == netatom[NetWMName])
			updatetitle(c);
		if (ev->atom == netatom[NetWMWindowType])
			updatewindowtype(c);
	}
}

void
quit(const Arg *arg)
{
	running = 0;
}

Monitor *
recttomon(int x, int y, int w, int h)
{
	Monitor *m, *r = selmon;
	int a, area = 0;

	for (m = mons; m; m = m->next)
		if ((a = INTERSECT(x, y, w, h, m)) > area) {
			area = a;
			r = m;
		}
	return r;
}

void
removesystrayicon(Client *i)
{
	Client **ii;

	if (!showsystray || !i)
		return;
	for (ii = &systray->icons; *ii && *ii != i; ii = &(*ii)->next);
	if (ii)
		*ii = i->next;
	free(i);
}

void
resize(Client *c, int x, int y, int w, int h, int interact)
{
	if (applysizehints(c, &x, &y, &w, &h, interact))
		resizeclient(c, x, y, w, h);
}

void
resizebarwin(Monitor *m) {
    unsigned int w = m->ww - 2 * sp; /* Учитываем боковые отступы */
    if (showsystray && m == systraytomon(m) && !systrayonleft)
        w -= getsystraywidth(); /* Учитываем ширину системного трея */
    XMoveResizeWindow(dpy, m->barwin, m->wx + sp, m->by + vp, w, bh);
}

void
resizeclient(Client *c, int x, int y, int w, int h)
{
	XWindowChanges wc;

	c->oldx = c->x; c->x = wc.x = x;
	c->oldy = c->y; c->y = wc.y = y;
	c->oldw = c->w; c->w = wc.width = w;
	c->oldh = c->h; c->h = wc.height = h;
	wc.border_width = c->bw;
	XConfigureWindow(dpy, c->win, CWX|CWY|CWWidth|CWHeight|CWBorderWidth, &wc);
	configure(c);
	XSync(dpy, False);
}

void
resizerequest(XEvent *e)
{
	XResizeRequestEvent *ev = &e->xresizerequest;
	Client *i;

	if ((i = wintosystrayicon(ev->window))) {
		updatesystrayicongeom(i, ev->width, ev->height);
		resizebarwin(selmon);
		updatesystray();
	}
}

void
resizemouse(const Arg *arg)
{
	int x, y, ocw, och, nw, nh;
	Client *c;
	Monitor *m;
	XEvent ev;
	Time lasttime = 0;

	if (!(c = selmon->sel))
		return;
	if (c->isfullscreen) /* no support resizing fullscreen windows by mouse */
		return;
	restack(selmon);
	ocw = c->w;
	och = c->h;
	if (XGrabPointer(dpy, root, False, MOUSEMASK, GrabModeAsync, GrabModeAsync,
		None, cursor[CurResize]->cursor, CurrentTime) != GrabSuccess)
		return;
	if(!getrootptr(&x, &y))
		return;
	do {
		XMaskEvent(dpy, MOUSEMASK|ExposureMask|SubstructureRedirectMask, &ev);
		switch(ev.type) {
		case ConfigureRequest:
		case Expose:
		case MapRequest:
			handler[ev.type](&ev);
			break;
		case MotionNotify:
			if ((ev.xmotion.time - lasttime) <= (1000 / 60))
				continue;
			lasttime = ev.xmotion.time;

			nw = MAX(ocw + (ev.xmotion.x - x), 1);
			nh = MAX(och + (ev.xmotion.y - y), 1);
			if (c->mon->wx + nw >= selmon->wx && c->mon->wx + nw <= selmon->wx + selmon->ww
			&& c->mon->wy + nh >= selmon->wy && c->mon->wy + nh <= selmon->wy + selmon->wh)
			{
				if (!c->isfloating && selmon->lt[selmon->sellt]->arrange
				&& (abs(nw - c->w) > snap || abs(nh - c->h) > snap))
					togglefloating(NULL);
			}
			if (!selmon->lt[selmon->sellt]->arrange || c->isfloating)
				resize(c, c->x, c->y, nw, nh, 1);
			break;
		}
	} while (ev.type != ButtonRelease);
	XUngrabPointer(dpy, CurrentTime);
	while (XCheckMaskEvent(dpy, EnterWindowMask, &ev));
	if ((m = recttomon(c->x, c->y, c->w, c->h)) != selmon) {
		sendmon(c, m);
		selmon = m;
		focus(NULL);
	}
}

void
restack(Monitor *m)
{
	Client *c;
	XEvent ev;
	XWindowChanges wc;

	drawbar(m);
	if (!m->sel)
		return;
	if (m->sel->isfloating || !m->lt[m->sellt]->arrange)
		XRaiseWindow(dpy, m->sel->win);
	if (m->lt[m->sellt]->arrange) {
		wc.stack_mode = Below;
		wc.sibling = m->barwin;
		for (c = m->stack; c; c = c->snext)
			if (!c->isfloating && ISVISIBLE(c)) {
				XConfigureWindow(dpy, c->win, CWSibling|CWStackMode, &wc);
				wc.sibling = c->win;
			}
	}
	XSync(dpy, False);
	while (XCheckMaskEvent(dpy, EnterWindowMask, &ev));
}

void
run(void)
{
	XEvent ev;
	/* main event loop */
	XSync(dpy, False);
	while (running && !XNextEvent(dpy, &ev))
		if (handler[ev.type])
			handler[ev.type](&ev); /* call handler */
}

void
scan(void)
{
	unsigned int i, num;
	Window d1, d2, *wins = NULL;
	XWindowAttributes wa;

	if (XQueryTree(dpy, root, &d1, &d2, &wins, &num)) {
		for (i = 0; i < num; i++) {
			if (!XGetWindowAttributes(dpy, wins[i], &wa)
			|| wa.override_redirect || XGetTransientForHint(dpy, wins[i], &d1))
				continue;
			if (wa.map_state == IsViewable || getstate(wins[i]) == IconicState)
				manage(wins[i], &wa);
		}
		for (i = 0; i < num; i++) { /* now the transients */
			if (!XGetWindowAttributes(dpy, wins[i], &wa))
				continue;
			if (XGetTransientForHint(dpy, wins[i], &d1)
			&& (wa.map_state == IsViewable || getstate(wins[i]) == IconicState))
				manage(wins[i], &wa);
		}
		if (wins)
			XFree(wins);
	}
}

void
sendmon(Client *c, Monitor *m)
{
	if (c->mon == m)
		return;
	unfocus(c, 1);
	detach(c);
	detachstack(c);
	c->mon = m;
	c->tags = m->tagset[m->seltags]; /* assign tags of target monitor */
	if( attachbelow )
		attachBelow(c);
	else
		attach(c);
	attachstack(c);
	setclienttagprop(c);
	focus(NULL);
	arrange(NULL);
}

void
setclientstate(Client *c, long state)
{
	long data[] = { state, None };

	XChangeProperty(dpy, c->win, wmatom[WMState], wmatom[WMState], 32,
		PropModeReplace, (unsigned char *)data, 2);
}
void
setcurrentdesktop(void){
	long data[] = { 0 };
	XChangeProperty(dpy, root, netatom[NetCurrentDesktop], XA_CARDINAL, 32, PropModeReplace, (unsigned char *)data, 1);
}
void setdesktopnames(void){
	XTextProperty text;
    Xutf8TextListToTextProperty(dpy, (char **)tags, TAGSLENGTH, XUTF8StringStyle, &text);

	XSetTextProperty(dpy, root, &text, netatom[NetDesktopNames]);
}

int
sendevent(Window w, Atom proto, int mask, long d0, long d1, long d2, long d3, long d4)
{
	int n;
	Atom *protocols, mt;
	int exists = 0;
	XEvent ev;

	if (proto == wmatom[WMTakeFocus] || proto == wmatom[WMDelete]) {
		mt = wmatom[WMProtocols];
		if (XGetWMProtocols(dpy, w, &protocols, &n)) {
			while (!exists && n--)
				exists = protocols[n] == proto;
			XFree(protocols);
		}
	}
	else {
		exists = True;
		mt = proto;
	}

	if (exists) {
		ev.type = ClientMessage;
		ev.xclient.window = w;
		ev.xclient.message_type = mt;
		ev.xclient.format = 32;
		ev.xclient.data.l[0] = d0;
		ev.xclient.data.l[1] = d1;
		ev.xclient.data.l[2] = d2;
		ev.xclient.data.l[3] = d3;
		ev.xclient.data.l[4] = d4;
		XSendEvent(dpy, w, False, mask, &ev);
	}
	return exists;
}

void
setnumdesktops(void){
	long data[] = { TAGSLENGTH };
	XChangeProperty(dpy, root, netatom[NetNumberOfDesktops], XA_CARDINAL, 32, PropModeReplace, (unsigned char *)data, 1);
}
void
setfocus(Client *c)
{
    if (!c->neverfocus) {
        XSetInputFocus(dpy, c->win, RevertToPointerRoot, CurrentTime);
        XChangeProperty(dpy, root, netatom[NetActiveWindow],
            XA_WINDOW, 32, PropModeReplace,
            (unsigned char *) &(c->win), 1);
    }

    /* Проверка на поддержку WM_TAKE_FOCUS */
    if (sendevent(c->win, wmatom[WMTakeFocus], NoEventMask, CurrentTime, 0, 0, 0, 0) == 0) {
        printf("Window does not support WM_TAKE_FOCUS: %ld\n", c->win);
    }
}

void
setfullscreen(Client *c, int fullscreen)
{
	if (fullscreen && !c->isfullscreen) {
		XChangeProperty(dpy, c->win, netatom[NetWMState], XA_ATOM, 32,
			PropModeReplace, (unsigned char*)&netatom[NetWMFullscreen], 1);
		c->isfullscreen = 1;
		c->oldstate = c->isfloating;
		c->oldbw = c->bw;
		c->bw = 0;
		c->isfloating = 1;
		resizeclient(c, c->mon->mx, c->mon->my, c->mon->mw, c->mon->mh);
		XRaiseWindow(dpy, c->win);
	} else if (!fullscreen && c->isfullscreen){
		XChangeProperty(dpy, c->win, netatom[NetWMState], XA_ATOM, 32,
			PropModeReplace, (unsigned char*)0, 0);
		c->isfullscreen = 0;
		c->isfloating = c->oldstate;
		c->bw = c->oldbw;
		c->x = c->oldx;
		c->y = c->oldy;
		c->w = c->oldw;
		c->h = c->oldh;
		resizeclient(c, c->x, c->y, c->w, c->h);
		arrange(c->mon);
	}
}

void
setlayout(const Arg *arg)
{
	if (!arg || !arg->v || arg->v != selmon->lt[selmon->sellt])
		selmon->sellt = selmon->pertag->sellts[selmon->pertag->curtag] ^= 1;
	if (arg && arg->v)
		selmon->lt[selmon->sellt] = selmon->pertag->ltidxs[selmon->pertag->curtag][selmon->sellt] = (Layout *)arg->v;
	strncpy(selmon->ltsymbol, selmon->lt[selmon->sellt]->symbol, sizeof selmon->ltsymbol);
	if (selmon->sel)
		arrange(selmon);
	else
		drawbar(selmon);
}

void
setcfact(const Arg *arg) {
	float f;
	Client *c;

	c = selmon->sel;

	if(!arg || !c || !selmon->lt[selmon->sellt]->arrange)
		return;
	f = arg->f + c->cfact;
	if(arg->f == 0.0)
		f = 1.0;
	else if(f < 0.25 || f > 4.0)
		return;
	c->cfact = f;
	arrange(selmon);
}

/* arg > 1.0 will set mfact absolutely */
void
setmfact(const Arg *arg)
{
	float f;

	if (!arg || !selmon->lt[selmon->sellt]->arrange)
		return;
	f = arg->f < 1.0 ? arg->f + selmon->mfact : arg->f - 1.0;
	if (f < 0.05 || f > 0.95)
		return;
	selmon->mfact = selmon->pertag->mfacts[selmon->pertag->curtag] = f;
	arrange(selmon);
}

void
setup(void)
{
  load_showtitle_state();
	int i;
	XSetWindowAttributes wa;
	Atom utf8string;
	struct sigaction sa;

	/* do not transform children into zombies when they terminate */
	sigemptyset(&sa.sa_mask);
	sa.sa_flags = SA_NOCLDSTOP | SA_NOCLDWAIT | SA_RESTART;
	sa.sa_handler = SIG_IGN;
	sigaction(SIGCHLD, &sa, NULL);

	/* clean up any zombies (inherited from .xinitrc etc) immediately */
	while (waitpid(-1, NULL, WNOHANG) > 0);

	/* init screen */
	screen = DefaultScreen(dpy);
	sw = DisplayWidth(dpy, screen);
	sh = DisplayHeight(dpy, screen);
	root = RootWindow(dpy, screen);
	drw = drw_create(dpy, screen, root, sw, sh);
	if (!drw_fontset_create(drw, fonts, LENGTH(fonts)))
		die("no fonts could be loaded.");
	lrpad = drw->fonts->h;
	bh = drw->fonts->h + 2;
	updategeom();
	sp = sidepad;
	vp = (topbar == 1) ? vertpad : - vertpad;

	/* init atoms */
	utf8string = XInternAtom(dpy, "UTF8_STRING", False);
	wmatom[WMProtocols] = XInternAtom(dpy, "WM_PROTOCOLS", False);
	wmatom[WMDelete] = XInternAtom(dpy, "WM_DELETE_WINDOW", False);
	wmatom[WMState] = XInternAtom(dpy, "WM_STATE", False);
	wmatom[WMTakeFocus] = XInternAtom(dpy, "WM_TAKE_FOCUS", False);
	netatom[NetActiveWindow] = XInternAtom(dpy, "_NET_ACTIVE_WINDOW", False);
	netatom[NetSupported] = XInternAtom(dpy, "_NET_SUPPORTED", False);
    netatom[NetDesktopViewport] = XInternAtom(dpy, "_NET_DESKTOP_VIEWPORT", False);
    netatom[NetActiveWindow] = XInternAtom(dpy, "_NET_ACTIVE_WINDOW", False);
	netatom[NetNumberOfDesktops] = XInternAtom(dpy, "_NET_NUMBER_OF_DESKTOPS", False);
	netatom[NetCurrentDesktop] = XInternAtom(dpy, "_NET_CURRENT_DESKTOP", False);
    netatom[NetWorkarea] = XInternAtom(dpy, "_NET_WORKAREA", False);
	netatom[NetDesktopNames] = XInternAtom(dpy, "_NET_DESKTOP_NAMES", False);
    netatom[NetWMWindowTypeDock] = XInternAtom(dpy, "_NET_WM_WINDOW_TYPE_DOCK", False);
    netatom[NetWMDesktop] = XInternAtom(dpy, "_NET_WM_DESKTOP", False);
	netatom[NetSystemTray] = XInternAtom(dpy, "_NET_SYSTEM_TRAY_S0", False);
	netatom[NetSystemTrayOP] = XInternAtom(dpy, "_NET_SYSTEM_TRAY_OPCODE", False);
	netatom[NetSystemTrayOrientation] = XInternAtom(dpy, "_NET_SYSTEM_TRAY_ORIENTATION", False);
	netatom[NetSystemTrayOrientationHorz] = XInternAtom(dpy, "_NET_SYSTEM_TRAY_ORIENTATION_HORZ", False);
	netatom[NetWMName] = XInternAtom(dpy, "_NET_WM_NAME", False);
	netatom[NetWMState] = XInternAtom(dpy, "_NET_WM_STATE", False);
	netatom[NetWMCheck] = XInternAtom(dpy, "_NET_SUPPORTING_WM_CHECK", False);
	netatom[NetWMFullscreen] = XInternAtom(dpy, "_NET_WM_STATE_FULLSCREEN", False);
	netatom[NetWMWindowType] = XInternAtom(dpy, "_NET_WM_WINDOW_TYPE", False);
	netatom[NetWMWindowTypeDialog] = XInternAtom(dpy, "_NET_WM_WINDOW_TYPE_DIALOG", False);
	netatom[NetClientList] = XInternAtom(dpy, "_NET_CLIENT_LIST", False);
    netatom[NetClientInfo] = XInternAtom(dpy, "_NET_CLIENT_INFO", False);

	xatom[Manager] = XInternAtom(dpy, "MANAGER", False);
	xatom[Xembed] = XInternAtom(dpy, "_XEMBED", False);
	xatom[XembedInfo] = XInternAtom(dpy, "_XEMBED_INFO", False);
	/* init cursors */
	cursor[CurNormal] = drw_cur_create(drw, XC_left_ptr);
	cursor[CurResize] = drw_cur_create(drw, XC_sizing);
	cursor[CurMove] = drw_cur_create(drw, XC_fleur);
	/* init appearance */
	scheme = ecalloc(LENGTH(colors), sizeof(Clr *));
	for (i = 0; i < LENGTH(colors); i++)
		scheme[i] = drw_scm_create(drw, colors[i], 3);
	/* init system tray */
	updatesystray();
	/* init bars */
	updatebars();
	updatestatus();
	updatebarpos(selmon);
	/* supporting window for NetWMCheck */
	wmcheckwin = XCreateSimpleWindow(dpy, root, 0, 0, 1, 1, 0, 0, 0);
	XChangeProperty(dpy, wmcheckwin, netatom[NetWMCheck], XA_WINDOW, 32,
		PropModeReplace, (unsigned char *) &wmcheckwin, 1);
	XChangeProperty(dpy, wmcheckwin, netatom[NetWMName], utf8string, 8,
		PropModeReplace, (unsigned char *) "dwm", 3);
	XChangeProperty(dpy, root, netatom[NetWMCheck], XA_WINDOW, 32,
		PropModeReplace, (unsigned char *) &wmcheckwin, 1);
	/* EWMH support per view */
	XChangeProperty(dpy, root, netatom[NetSupported], XA_ATOM, 32,
		PropModeReplace, (unsigned char *) netatom, NetLast);
	setnumdesktops();
	setcurrentdesktop();
	setdesktopnames();
	setviewport();
	XDeleteProperty(dpy, root, netatom[NetClientList]);
	XDeleteProperty(dpy, root, netatom[NetClientInfo]);
	/* select events */
	wa.cursor = cursor[CurNormal]->cursor;
	wa.event_mask = SubstructureRedirectMask|SubstructureNotifyMask
		|ButtonPressMask|PointerMotionMask|EnterWindowMask
		|LeaveWindowMask|StructureNotifyMask|PropertyChangeMask;
	XChangeWindowAttributes(dpy, root, CWEventMask|CWCursor, &wa);
	XSelectInput(dpy, root, wa.event_mask);
	grabkeys();
	focus(NULL);
	loadSystrayState();

}
void
setviewport(void){
	long data[] = { 0, 0 };
	XChangeProperty(dpy, root, netatom[NetDesktopViewport], XA_CARDINAL, 32, PropModeReplace, (unsigned char *)data, 2);
}




void
seturgent(Client *c, int urg)
{
	XWMHints *wmh;

	c->isurgent = urg;
	if (!(wmh = XGetWMHints(dpy, c->win)))
		return;
	wmh->flags = urg ? (wmh->flags | XUrgencyHint) : (wmh->flags & ~XUrgencyHint);
	XSetWMHints(dpy, c->win, wmh);
	XFree(wmh);
}

void
showhide(Client *c)
{
	if (!c)
		return;
	if (ISVISIBLE(c)) {
		/* show clients top down */
		XMoveWindow(dpy, c->win, c->x, c->y);
		if ((!c->mon->lt[c->mon->sellt]->arrange || c->isfloating) && !c->isfullscreen)
			resize(c, c->x, c->y, c->w, c->h, 0);
		showhide(c->snext);
	} else {
		/* hide clients bottom up */
		showhide(c->snext);
		XMoveWindow(dpy, c->win, WIDTH(c) * -2, c->y);
	}
}

void
spawn(const Arg *arg)
{
	struct sigaction sa;

		if (fork() == 0) {
		if (dpy)
			close(ConnectionNumber(dpy));
		setsid();

		sigemptyset(&sa.sa_mask);
		sa.sa_flags = 0;
		sa.sa_handler = SIG_DFL;
		sigaction(SIGCHLD, &sa, NULL);

		execvp(((char **)arg->v)[0], (char **)arg->v);
		die("dwm: execvp '%s' failed:", ((char **)arg->v)[0]);
	}
}

void
setclienttagprop(Client *c)
{
	long data[] = { (long) c->tags, (long) c->mon->num };
	XChangeProperty(dpy, c->win, netatom[NetClientInfo], XA_CARDINAL, 32,
			PropModeReplace, (unsigned char *) data, 2);
}

void
tag(const Arg *arg)
{
	Client *c;
	if (selmon->sel && arg->ui & TAGMASK) {
		c = selmon->sel;
		selmon->sel->tags = arg->ui & TAGMASK;
		setclienttagprop(c);
		focus(NULL);
		arrange(selmon);
        updatecurrentdesktop();

	}
}

void
tagmon(const Arg *arg)
{
	if (!selmon->sel || !mons->next)
		return;
	sendmon(selmon->sel, dirtomon(arg->i));
}

void
togglebar(const Arg *arg)
{
    selmon->showbar = selmon->pertag->showbars[selmon->pertag->curtag] = !selmon->showbar;
    updatebarpos(selmon);
    resizebarwin(selmon);

    if (showsystray) {
        XWindowChanges wc;
        if (!selmon->showbar)
            wc.y = -bh - vp; /* Учёт вертикального отступа */
        else {
            wc.y = vp; /* Учёт верхнего отступа */
            if (!selmon->topbar)
                wc.y = selmon->mh - bh - vp; /* Учёт нижнего отступа */
        }
        XConfigureWindow(dpy, systray->win, CWY, &wc);
    }

    arrange(selmon);
}
void
togglefloating(const Arg *arg)
{
	if (!selmon->sel)
		return;
	if (selmon->sel->isfullscreen) /* no support for fullscreen windows */
		return;
	selmon->sel->isfloating = !selmon->sel->isfloating || selmon->sel->isfixed;
	if (selmon->sel->isfloating)
		resize(selmon->sel, selmon->sel->x, selmon->sel->y,
			selmon->sel->w, selmon->sel->h, 0);
	arrange(selmon);
}

void
togglefullscr(const Arg *arg)
{
  if(selmon->sel)
    setfullscreen(selmon->sel, !selmon->sel->isfullscreen);
}

void
toggletag(const Arg *arg)
{
	unsigned int newtags;

	if (!selmon->sel)
		return;
	newtags = selmon->sel->tags ^ (arg->ui & TAGMASK);
	if (newtags) {
		selmon->sel->tags = newtags;
		setclienttagprop(selmon->sel);
		focus(NULL);
		arrange(selmon);
	}
	updatecurrentdesktop();
}

void
toggleview(const Arg *arg)
{
	unsigned int newtagset = selmon->tagset[selmon->seltags] ^ (arg->ui & TAGMASK);
	int i;

	if (newtagset) {
		selmon->tagset[selmon->seltags] = newtagset;

		if (newtagset == ~0) {
			selmon->pertag->prevtag = selmon->pertag->curtag;
			selmon->pertag->curtag = 0;
		}

		/* test if the user did not select the same tag */
		if (!(newtagset & 1 << (selmon->pertag->curtag - 1))) {
			selmon->pertag->prevtag = selmon->pertag->curtag;
			for (i = 0; !(newtagset & 1 << i); i++) ;
			selmon->pertag->curtag = i + 1;
		}

		/* apply settings for this view */
		selmon->nmaster = selmon->pertag->nmasters[selmon->pertag->curtag];
		selmon->mfact = selmon->pertag->mfacts[selmon->pertag->curtag];
		selmon->sellt = selmon->pertag->sellts[selmon->pertag->curtag];
		selmon->lt[selmon->sellt] = selmon->pertag->ltidxs[selmon->pertag->curtag][selmon->sellt];
		selmon->lt[selmon->sellt^1] = selmon->pertag->ltidxs[selmon->pertag->curtag][selmon->sellt^1];

		if (selmon->showbar != selmon->pertag->showbars[selmon->pertag->curtag])
			togglebar(NULL);

		focus(NULL);
		arrange(selmon);
	}
	updatecurrentdesktop();
}

void
unfocus(Client *c, int setfocus)
{
	if (!c)
		return;
	grabbuttons(c, 0);
	XSetWindowBorder(dpy, c->win, scheme[SchemeNorm][ColBorder].pixel);
	if (setfocus) {
		XSetInputFocus(dpy, root, RevertToPointerRoot, CurrentTime);
		XDeleteProperty(dpy, root, netatom[NetActiveWindow]);
	}
}



void
unmanage(Client *c, int destroyed)
{
    int i;
    Monitor *m = c->mon;
    XWindowChanges wc;

    // Удаляем клиента из перетагов
    for (i = 0; i < LENGTH(tags) + 1; i++)
        if (c->mon->pertag->sel[i] == c)
            c->mon->pertag->sel[i] = NULL;

    detach(c);
    detachstack(c);

    if (!destroyed) {
        wc.border_width = c->oldbw;
        XGrabServer(dpy); /* avoid race conditions */
        XSetErrorHandler(xerrordummy);
        XSelectInput(dpy, c->win, NoEventMask);
        XConfigureWindow(dpy, c->win, CWBorderWidth, &wc); /* restore border */
        XUngrabButton(dpy, AnyButton, AnyModifier, c->win);
        setclientstate(c, WithdrawnState);
        XSync(dpy, False);
        XSetErrorHandler(xerror);
        XUngrabServer(dpy);
    }

    // Удаляем окно из _NET_CLIENT_LIST
    int count = 0;
    for (Client *t = selmon->clients; t; t = t->next) {
        count++;
    }
    Window *windows = calloc(count, sizeof(Window)); // Динамическое выделение памяти
    count = 0; // Сброс счётчика
    for (Client *t = selmon->clients; t; t = t->next) {
        if (t != c) {
            windows[count++] = t->win;
        }
    }
    XChangeProperty(dpy, root, netatom[NetClientList], XA_WINDOW, 32,
                    PropModeReplace, (unsigned char *)windows, count);
    free(windows);

    free(c);
    focus(NULL);
    updateclientlist();
    arrange(m);
}

void
unmapnotify(XEvent *e)
{
	Client *c;
	XUnmapEvent *ev = &e->xunmap;

	if ((c = wintoclient(ev->window))) {
		if (ev->send_event)
			setclientstate(c, WithdrawnState);
		else
			unmanage(c, 0);
	}
	else if ((c = wintosystrayicon(ev->window))) {
		/* KLUDGE! sometimes icons occasionally unmap their windows, but do
		 * _not_ destroy them. We map those windows back */
		XMapRaised(dpy, c->win);
		updatesystray();
	}
}

void
updatebars(void)
{
	unsigned int w;
	Monitor *m;
	XSetWindowAttributes wa = {
		.override_redirect = True,
		.background_pixmap = ParentRelative,
		.event_mask = ButtonPressMask|ExposureMask
	};
	XClassHint ch = {"dwm", "dwm"};
	for (m = mons; m; m = m->next) {
		if (m->barwin)
			continue;
		w = m->ww;
		if (showsystray && m == systraytomon(m))
			w -= getsystraywidth();
		m->barwin = XCreateWindow(dpy, root, m->wx, m->by, w, bh, 0, DefaultDepth(dpy, screen),
				CopyFromParent, DefaultVisual(dpy, screen),
				CWOverrideRedirect|CWBackPixmap|CWEventMask, &wa);
		XDefineCursor(dpy, m->barwin, cursor[CurNormal]->cursor);
		if (showsystray && m == systraytomon(m))
			XMapRaised(dpy, systray->win);
		XMapRaised(dpy, m->barwin);
		XSetClassHint(dpy, m->barwin, &ch);
	}
}

void
updatebarpos(Monitor *m)
{
    m->wy = m->my;
    m->wh = m->mh;
    if (m->showbar) {
        m->wh -= bh + 2 * vp; /* Уменьшаем высоту на высоту панели и вертикальные отступы */
        m->by = m->topbar ? m->wy : m->wy + m->wh + vp;
        m->wy = m->topbar ? m->wy + bh + vp : m->wy;
    } else {
        m->by = -bh - vp; /* Если панель скрыта */
    }
}


void
updateclientlist(void)
{
    Client *c;
    Monitor *m;

    // Удаляем старый список
    XDeleteProperty(dpy, root, netatom[NetClientList]);

    // Добавляем все окна
    for (m = mons; m; m = m->next) {
        for (c = m->clients; c; c = c->next) {
            XChangeProperty(dpy, root, netatom[NetClientList],
                            XA_WINDOW, 32, PropModeAppend,
                            (unsigned char *)&(c->win), 1);
        }
    }
}


void
setactivewindow(Client *c)
{
    if (c) {
        XChangeProperty(dpy, root, netatom[NetActiveWindow], XA_WINDOW, 32,
                        PropModeReplace, (unsigned char *)&(c->win), 1);
    } else {
        XDeleteProperty(dpy, root, netatom[NetActiveWindow]);
    }
}



void updatecurrentdesktop(void) {
    unsigned long rawdata = selmon->tagset[selmon->seltags]; // Битовая маска текущих тегов
    int i = 0;

    // Поиск активного тега по битовой маске
    while (rawdata > 1) {
        rawdata >>= 1; // Сдвигаем битовую маску вправо
        i++;
    }

    long data[] = { i }; // Индекс активного тега
    XChangeProperty(dpy, root, netatom[NetCurrentDesktop], XA_CARDINAL, 32,
                    PropModeReplace, (unsigned char *)data, 1);
}


int
updategeom(void)
{
    int dirty = 0;

#ifdef XINERAMA
    if (XineramaIsActive(dpy)) {
        int i, j, n, nn;
        Client *c;
        Monitor *m;
        XineramaScreenInfo *info = XineramaQueryScreens(dpy, &nn);
        XineramaScreenInfo *unique = NULL;

        for (n = 0, m = mons; m; m = m->next, n++);
        /* only consider unique geometries as separate screens */
        unique = ecalloc(nn, sizeof(XineramaScreenInfo));
        for (i = 0, j = 0; i < nn; i++)
            if (isuniquegeom(unique, j, &info[i]))
                memcpy(&unique[j++], &info[i], sizeof(XineramaScreenInfo));
        XFree(info);
        nn = j;

        /* new monitors if nn > n */
        for (i = n; i < nn; i++) {
            for (m = mons; m && m->next; m = m->next);
            if (m)
                m->next = createmon();
            else
                mons = createmon();
        }
        for (i = 0, m = mons; i < nn && m; m = m->next, i++) {
            if (i >= n
            || unique[i].x_org != m->mx || unique[i].y_org != m->my
            || unique[i].width != m->mw || unique[i].height != m->mh)
            {
                dirty = 1;
                m->num = i;
                m->mx = m->wx = unique[i].x_org;
                m->my = m->wy = unique[i].y_org;
                m->mw = m->ww = unique[i].width;
                m->mh = m->wh = unique[i].height;

                /* Обработка окон типа dock */
                updatebarpos(m);
                long struts[4] = {0};
                Atom type;
                int format;
                unsigned long nitems, bytes_after;
                unsigned char *data = NULL;
                Window root_return, parent_return, *children = NULL;
                unsigned int nchildren;

                // Получаем список всех окон
                if (XQueryTree(dpy, root, &root_return, &parent_return, &children, &nchildren)) {
                    for (unsigned int k = 0; k < nchildren; k++) {
                        if (XGetWindowProperty(dpy, children[k], XInternAtom(dpy, "_NET_WM_STRUT_PARTIAL", False),
                                               0L, 4L, False, XA_CARDINAL, &type, &format,
                                               &nitems, &bytes_after, &data) == Success && data) {
                            memcpy(struts, data, sizeof(long) * 4);
                            XFree(data);

                            /* Корректируем размеры монитора */
                            if (struts[0] > 0) m->wx += struts[0]; // Левый отступ
                            if (struts[1] > 0) m->ww -= struts[1]; // Правый отступ
                            if (struts[2] > 0) m->wy += struts[2]; // Верхний отступ
                            if (struts[3] > 0) m->wh -= struts[3]; // Нижний отступ
                        }
                    }
                    if (children) {
                        XFree(children);
                    }
                }
            }
        }
        /* removed monitors if n > nn */
        for (i = nn; i < n; i++) {
            for (m = mons; m && m->next; m = m->next);
            while ((c = m->clients)) {
                dirty = 1;
                m->clients = c->next;
                detachstack(c);
                c->mon = mons;
                if (attachbelow)
                    attachBelow(c);
                else
                    attach(c);

                attachstack(c);
            }
            if (m == selmon)
                selmon = mons;
            cleanupmon(m);
        }
        free(unique);
    } else
#endif /* XINERAMA */
    { /* default monitor setup */
        if (!mons)
            mons = createmon();
        if (mons->mw != sw || mons->mh != sh) {
            dirty = 1;
            mons->mw = mons->ww = sw;
            mons->mh = mons->wh = sh;

            /* Корректируем размеры для окон dock */
            long struts[4] = {0};
            Atom type;
            int format;
            unsigned long nitems, bytes_after;
            unsigned char *data = NULL;
            Window root_return, parent_return, *children = NULL;
            unsigned int nchildren;

            if (XQueryTree(dpy, root, &root_return, &parent_return, &children, &nchildren)) {
                for (unsigned int k = 0; k < nchildren; k++) {
                    if (XGetWindowProperty(dpy, children[k], XInternAtom(dpy, "_NET_WM_STRUT_PARTIAL", False),
                                           0L, 4L, False, XA_CARDINAL, &type, &format,
                                           &nitems, &bytes_after, &data) == Success && data) {
                        memcpy(struts, data, sizeof(long) * 4);
                        XFree(data);

                        if (struts[0] > 0) mons->wx += struts[0]; // Левый отступ
                        if (struts[1] > 0) mons->ww -= struts[1]; // Правый отступ
                        if (struts[2] > 0) mons->wy += struts[2]; // Верхний отступ
                        if (struts[3] > 0) mons->wh -= struts[3]; // Нижний отступ
                    }
                }
                if (children) {
                    XFree(children);
                }
            }
            updatebarpos(mons);
        }
    }
    if (dirty) {
        selmon = mons;
        selmon = wintomon(root);
    }
    //updateworkarea();
    return dirty;

}

void
updatenumlockmask(void)
{
	unsigned int i, j;
	XModifierKeymap *modmap;

	numlockmask = 0;
	modmap = XGetModifierMapping(dpy);
	for (i = 0; i < 8; i++)
		for (j = 0; j < modmap->max_keypermod; j++)
			if (modmap->modifiermap[i * modmap->max_keypermod + j]
				== XKeysymToKeycode(dpy, XK_Num_Lock))
				numlockmask = (1 << i);
	XFreeModifiermap(modmap);
}

void
updatesizehints(Client *c)
{
	long msize;
	XSizeHints size;

	if (!XGetWMNormalHints(dpy, c->win, &size, &msize))
		/* size is uninitialized, ensure that size.flags aren't used */
		size.flags = PSize;
	if (size.flags & PBaseSize) {
		c->basew = size.base_width;
		c->baseh = size.base_height;
	} else if (size.flags & PMinSize) {
		c->basew = size.min_width;
		c->baseh = size.min_height;
	} else
		c->basew = c->baseh = 0;
	if (size.flags & PResizeInc) {
		c->incw = size.width_inc;
		c->inch = size.height_inc;
	} else
		c->incw = c->inch = 0;
	if (size.flags & PMaxSize) {
		c->maxw = size.max_width;
		c->maxh = size.max_height;
	} else
		c->maxw = c->maxh = 0;
	if (size.flags & PMinSize) {
		c->minw = size.min_width;
		c->minh = size.min_height;
	} else if (size.flags & PBaseSize) {
		c->minw = size.base_width;
		c->minh = size.base_height;
	} else
		c->minw = c->minh = 0;
	if (size.flags & PAspect) {
		c->mina = (float)size.min_aspect.y / size.min_aspect.x;
		c->maxa = (float)size.max_aspect.x / size.max_aspect.y;
	} else
		c->maxa = c->mina = 0.0;
	c->isfixed = (c->maxw && c->maxh && c->maxw == c->minw && c->maxh == c->minh);
	c->hintsvalid = 1;
}

void
updatestatus(void)
{
	if (!gettextprop(root, XA_WM_NAME, stext, sizeof(stext)))
		strcpy(stext, "dwm-"VERSION);
	drawbar(selmon);
	updatesystray();
}


void
updatesystrayicongeom(Client *i, int w, int h)
{
	if (i) {
		i->h = bh;
		if (w == h)
			i->w = bh;
		else if (h == bh)
			i->w = w;
		else
			i->w = (int) ((float)bh * ((float)w / (float)h));
		applysizehints(i, &(i->x), &(i->y), &(i->w), &(i->h), False);
		/* force icons into the systray dimensions if they don't want to */
		if (i->h > bh) {
			if (i->w == i->h)
				i->w = bh;
			else
				i->w = (int) ((float)bh * ((float)i->w / (float)i->h));
			i->h = bh;
		}
	}
}

void
updatesystrayiconstate(Client *i, XPropertyEvent *ev)
{
	long flags;
	int code = 0;

	if (!showsystray || !i || ev->atom != xatom[XembedInfo] ||
			!(flags = getatomprop(i, xatom[XembedInfo])))
		return;

	if (flags & XEMBED_MAPPED && !i->tags) {
		i->tags = 1;
		code = XEMBED_WINDOW_ACTIVATE;
		XMapRaised(dpy, i->win);
		setclientstate(i, NormalState);
	}
	else if (!(flags & XEMBED_MAPPED) && i->tags) {
		i->tags = 0;
		code = XEMBED_WINDOW_DEACTIVATE;
		XUnmapWindow(dpy, i->win);
		setclientstate(i, WithdrawnState);
	}
	else
		return;
	sendevent(i->win, xatom[Xembed], StructureNotifyMask, CurrentTime, code, 0,
			systray->win, XEMBED_EMBEDDED_VERSION);
}

void
updatesystray(void)
{
	XSetWindowAttributes wa;
	XWindowChanges wc;
	Client *i;
	Monitor *m = systraytomon(NULL);
	unsigned int x = m->mx + m->mw;
	unsigned int sw = TEXTW(stext) - lrpad + systrayspacing;
	unsigned int w = 1;

	if (!showsystray)
		return;
	if (systrayonleft)
		x -= sw + lrpad / 2;
	if (!systray) {
		/* init systray */
		if (!(systray = (Systray *)calloc(1, sizeof(Systray))))
			die("fatal: could not malloc() %u bytes\n", sizeof(Systray));
		systray->win = XCreateSimpleWindow(dpy, root, x, m->by, w, bh, 0, 0, scheme[SchemeSel][ColBg].pixel);
		wa.event_mask        = ButtonPressMask | ExposureMask;
		wa.override_redirect = True;
		wa.background_pixel  = scheme[SchemeNorm][ColBg].pixel;
		XSelectInput(dpy, systray->win, SubstructureNotifyMask);
		XChangeProperty(dpy, systray->win, netatom[NetSystemTrayOrientation], XA_CARDINAL, 32,
				PropModeReplace, (unsigned char *)&netatom[NetSystemTrayOrientationHorz], 1);
		XChangeWindowAttributes(dpy, systray->win, CWEventMask|CWOverrideRedirect|CWBackPixel, &wa);
		XMapRaised(dpy, systray->win);
		XSetSelectionOwner(dpy, netatom[NetSystemTray], systray->win, CurrentTime);
		if (XGetSelectionOwner(dpy, netatom[NetSystemTray]) == systray->win) {
			sendevent(root, xatom[Manager], StructureNotifyMask, CurrentTime, netatom[NetSystemTray], systray->win, 0, 0);
			XSync(dpy, False);
		}
		else {
			fprintf(stderr, "dwm: unable to obtain system tray.\n");
			free(systray);
			systray = NULL;
			return;
		}
	}
	for (w = 0, i = systray->icons; i; i = i->next) {
		/* make sure the background color stays the same */
		wa.background_pixel  = scheme[SchemeNorm][ColBg].pixel;
		XChangeWindowAttributes(dpy, i->win, CWBackPixel, &wa);
		XMapRaised(dpy, i->win);
		w += systrayspacing;
		i->x = w;
		XMoveResizeWindow(dpy, i->win, i->x, 0, i->w, i->h);
		w += i->w;
		if (i->mon != m)
			i->mon = m;
	}
	w = w ? w + systrayspacing : 1;
	x -= w;

  XMoveResizeWindow(dpy, systray->win, x - sp, m->by + vp, w, bh);
  wc.x = x - sp; wc.y = m->by + vp; wc.width = w; wc.height = bh;
	wc.stack_mode = Above; wc.sibling = m->barwin;
	XConfigureWindow(dpy, systray->win, CWX|CWY|CWWidth|CWHeight|CWSibling|CWStackMode, &wc);
	XMapWindow(dpy, systray->win);
	XMapSubwindows(dpy, systray->win);
	/* redraw background */
	XSetForeground(dpy, drw->gc, scheme[SchemeNorm][ColBg].pixel);
	XFillRectangle(dpy, systray->win, drw->gc, 0, 0, w, bh);
	XSync(dpy, False);
}


void
updatetitle(Client *c) {
    if (!gettextprop(c->win, netatom[NetWMName], c->name, sizeof c->name))
        gettextprop(c->win, XA_WM_NAME, c->name, sizeof c->name);
    if (c->name[0] == '\0') /* no name */
        strcpy(c->name, broken);
}

void
updatewindowtype(Client *c)
{
	Atom state = getatomprop(c, netatom[NetWMState]);
	Atom wtype = getatomprop(c, netatom[NetWMWindowType]);

	if (state == netatom[NetWMFullscreen])
		setfullscreen(c, 1);
	if (wtype == netatom[NetWMWindowTypeDialog])
		c->isfloating = 1;
}

void
updatewmhints(Client *c)
{
	XWMHints *wmh;

	if ((wmh = XGetWMHints(dpy, c->win))) {
		if (c == selmon->sel && wmh->flags & XUrgencyHint) {
			wmh->flags &= ~XUrgencyHint;
			XSetWMHints(dpy, c->win, wmh);
		} else
			c->isurgent = (wmh->flags & XUrgencyHint) ? 1 : 0;
		if (wmh->flags & InputHint)
			c->neverfocus = !wmh->input;
		else
			c->neverfocus = 0;
		XFree(wmh);
	}
}


void
viewnext(const Arg *arg) {
    unsigned int i;
    for (i = 0; i < LENGTH(tags); i++) {
        if (selmon->tagset[selmon->seltags] & (1 << i)) {
            view(&(Arg) { .ui = 1 << ((i + 1) % LENGTH(tags)) });
            return;
        }
    }
}

void
viewprev(const Arg *arg) {
    unsigned int i;
    for (i = 0; i < LENGTH(tags); i++) {
        if (selmon->tagset[selmon->seltags] & (1 << i)) {
            view(&(Arg) { .ui = 1 << ((i + LENGTH(tags) - 1) % LENGTH(tags)) });
            return;
        }
    }
}

void recompile_and_restart(const Arg *arg) {
    int status = system(RECOMPILE_COMMAND); // Выполняем команду перекомпиляции
    if (status != 0) {
        fprintf(stderr, "Ошибка при выполнении команды: %s\n", RECOMPILE_COMMAND);
        return;
    }
    system("make clean install"); // Перезапускаем dwm
}

void
view(const Arg *arg)
{
    int i;
    unsigned int tmptag;

    // Если мы переключаемся на тег 0
    if (arg->ui == ~0) {
        if (selmon->pertag->curtag == 0) {
            // Если мы уже находимся на теге 0, восстанавливаем прежнее состояние
            if (prevtags != 0) {
                selmon->tagset[selmon->seltags] = prevtags;
                setlayout(&((Arg) { .v = prevlayout }));
                focus(prevclient);
                arrange(selmon);
            }
            updatecurrentdesktop(); // Обновляем _NET_CURRENT_DESKTOP
            save_current_tag_to_file(); // Сохраняем текущий тег
            return;
        } else {
            prevtags = selmon->tagset[selmon->seltags];
            prevclient = selmon->sel;
            prevlayout = selmon->lt[selmon->sellt];
            selmon->pertag->curtag = 0;
            setlayout(&((Arg) { .v = TAG0_LAYOUT }));
        }
    }

    // Если тег уже активен, не делаем ничего
    if ((arg->ui & TAGMASK) == selmon->tagset[selmon->seltags]) {
        updatecurrentdesktop();
        save_current_tag_to_file();
        return;
    }

    selmon->seltags ^= 1; /* toggle sel tagset */
    if (arg->ui & TAGMASK) {
        selmon->tagset[selmon->seltags] = arg->ui & TAGMASK;
        selmon->pertag->prevtag = selmon->pertag->curtag;

        if (arg->ui != ~0) {
            for (i = 0; !(arg->ui & 1 << i); i++);
            selmon->pertag->curtag = i + 1;
        }
    } else {
        tmptag = selmon->pertag->prevtag;
        selmon->pertag->prevtag = selmon->pertag->curtag;
        selmon->pertag->curtag = tmptag;
    }

    selmon->nmaster = selmon->pertag->nmasters[selmon->pertag->curtag];
    selmon->mfact = selmon->pertag->mfacts[selmon->pertag->curtag];
    selmon->sellt = selmon->pertag->sellts[selmon->pertag->curtag];
    selmon->lt[selmon->sellt] = selmon->pertag->ltidxs[selmon->pertag->curtag][selmon->sellt];
    selmon->lt[selmon->sellt^1] = selmon->pertag->ltidxs[selmon->pertag->curtag][selmon->sellt^1];

    if (selmon->showbar != selmon->pertag->showbars[selmon->pertag->curtag])
        togglebar(NULL);

    // Поднимаем DOCK окна при переключении тегов
    for (Client *dock = selmon->clients; dock; dock = dock->next) {
        if (ISDOCK(dock)) {
            XRaiseWindow(dpy, dock->win);
        }
    }

    focus(selmon->pertag->sel[selmon->pertag->curtag]);
    arrange(selmon);
    updatecurrentdesktop(); // Обновляем _NET_CURRENT_DESKTOP
    save_current_tag_to_file(); // Сохраняем текущий тег
}


Client *
wintoclient(Window w)
{
	Client *c;
	Monitor *m;

	for (m = mons; m; m = m->next)
		for (c = m->clients; c; c = c->next)
			if (c->win == w)
				return c;
	return NULL;
}

Client *
wintosystrayicon(Window w) {
	Client *i = NULL;

	if (!showsystray || !w)
		return i;
	for (i = systray->icons; i && i->win != w; i = i->next) ;
	return i;
}

Monitor *
wintomon(Window w)
{
	int x, y;
	Client *c;
	Monitor *m;

	if (w == root && getrootptr(&x, &y))
		return recttomon(x, y, 1, 1);
	for (m = mons; m; m = m->next)
		if (w == m->barwin)
			return m;
	if ((c = wintoclient(w)))
		return c->mon;
	return selmon;
}

/* Selects for the view of the focused window. The list of tags */
/* to be displayed is matched to the focused window tag list. */
void
winview(const Arg* arg){
	Window win, win_r, win_p, *win_c;
	unsigned nc;
	int unused;
	Client* c;
	Arg a;

	if (!XGetInputFocus(dpy, &win, &unused)) return;
	while(XQueryTree(dpy, win, &win_r, &win_p, &win_c, &nc)
	      && win_p != win_r) win = win_p;

	if (!(c = wintoclient(win))) return;

	a.ui = c->tags;
	view(&a);
}

/* There's no way to check accesses to destroyed windows, thus those cases are
 * ignored (especially on UnmapNotify's). Other types of errors call Xlibs
 * default error handler, which may call exit. */
int
xerror(Display *dpy, XErrorEvent *ee)
{
	if (ee->error_code == BadWindow
	|| (ee->request_code == X_SetInputFocus && ee->error_code == BadMatch)
	|| (ee->request_code == X_PolyText8 && ee->error_code == BadDrawable)
	|| (ee->request_code == X_PolyFillRectangle && ee->error_code == BadDrawable)
	|| (ee->request_code == X_PolySegment && ee->error_code == BadDrawable)
	|| (ee->request_code == X_ConfigureWindow && ee->error_code == BadMatch)
	|| (ee->request_code == X_GrabButton && ee->error_code == BadAccess)
	|| (ee->request_code == X_GrabKey && ee->error_code == BadAccess)
	|| (ee->request_code == X_CopyArea && ee->error_code == BadDrawable))
		return 0;
	fprintf(stderr, "dwm: fatal error: request code=%d, error code=%d\n",
		ee->request_code, ee->error_code);
	return xerrorxlib(dpy, ee); /* may call exit */
}

int
xerrordummy(Display *dpy, XErrorEvent *ee)
{
	return 0;
}

/* Startup Error handler to check if another window manager
 * is already running. */
int
xerrorstart(Display *dpy, XErrorEvent *ee)
{
	die("dwm: another window manager is already running");
	return -1;
}

Monitor *
systraytomon(Monitor *m) {
	Monitor *t;
	int i, n;
	if(!systraypinning) {
		if(!m)
			return selmon;
		return m == selmon ? m : NULL;
	}
	for(n = 1, t = mons; t && t->next; n++, t = t->next) ;
	for(i = 1, t = mons; t && t->next && i < systraypinning; i++, t = t->next) ;
	if(systraypinningfailfirst && n < systraypinning)
		return mons;
	return t;
}

void
zoom(const Arg *arg)
{
	Client *c = selmon->sel;

	if (!selmon->lt[selmon->sellt]->arrange || !c || c->isfloating)
		return;
	if (c == nexttiled(selmon->clients) && !(c = nexttiled(c->next)))
		return;
	pop(c);
}

#include "attachbelow.h"

int
main(int argc, char *argv[])
{
    loadAttachBelow();   
    load_bottGaps_state();  
		MINIBOXloadState();
    smartgaps = loadSmartgapsState();
	if (argc == 2 && !strcmp("-v", argv[1]))
		die("dwm-"VERSION);
	else if (argc != 1)
		die("usage: dwm [-v]");
	if (!setlocale(LC_CTYPE, "") || !XSupportsLocale())
		fputs("warning: no locale support\n", stderr);
	if (!(dpy = XOpenDisplay(NULL)))
		die("dwm: cannot open display");
	checkotherwm();
	setup();
#ifdef __OpenBSD__
	if (pledge("stdio rpath proc exec", NULL) == -1)
		die("pledge");
#endif /* __OpenBSD__ */
	scan();
    switch_to_saved_tag();  // Восстанавливаем сохранённый тег
	run();
	cleanup();
	XCloseDisplay(dpy);
	return EXIT_SUCCESS;
    switch_to_saved_tag();

}
void togglesmartgaps(const Arg *arg) {
    smartgaps = !smartgaps;      // Переключение значения smartgaps
    saveSmartgapsState(smartgaps); // Сохранение текущего состояния
    arrange(NULL);               // Обновление расположения окон
}
