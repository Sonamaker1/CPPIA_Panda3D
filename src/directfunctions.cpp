#include "directfunctions.h"

void setBackgroundColor(struct Direct *self, LColor input) {
    self->window->get_graphics_window()->get_active_display_region(0)->set_clear_color(input);
}
void setMouseCamTask(struct Direct *self, bool input ){

}

NodePath getCamera(struct Direct *self){
    return self->window->get_camera_group();
}

void printLog(struct Direct *self, const char* input) {
    nout << "cppia: " << input << "\n";
}

int initDirect(Direct * D, WindowFramework * win){
    D->window = win;
    D->data = 42;
    D->setBackgroundColor = setBackgroundColor;
    D->printLog = printLog;
    return 0;
}
