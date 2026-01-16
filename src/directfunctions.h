#ifndef DIRECTFUNCTIONS_H
#define DIRECTFUNCTIONS_H

#include "pandaFramework.h"
struct Direct;
struct DirectObject;
typedef void (*Method)(struct Direct *self);
typedef void (*IntMethod)(struct Direct *self, int input );
typedef void (*BoolMethod)(struct Direct *self, bool input );
typedef void (*NodeMethod)(struct Direct *self, NodePath input );
typedef void (*ColorMethod)(struct Direct *self, LColor input );
typedef void (*StringMethod)(struct Direct *self, const char* input );
typedef void (*DirectMethod)(struct Direct *self, DirectObject input);
int initDirect(Direct * D, WindowFramework * win);

struct DirectObject {
    int data;
};

struct Direct {
    PandaFramework framework;
    WindowFramework * window;
    ColorMethod setBackgroundColor;
    StringMethod printLog;
    int data;
};

typedef struct Direct Direct_t;

NodePath getCamera(struct Direct *self);
#endif // DIRECTFUNCTIONS_H
