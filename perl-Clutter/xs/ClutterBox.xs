#include "clutter-perl-private.h"

MODULE = Clutter::Box   PACKAGE = Clutter::Box  PREFIX = clutter_box_

ClutterActor_noinc *clutter_box_new (class, ClutterLayoutManager *manager);
    C_ARGS:
        manager

void clutter_box_set_layout_manager (ClutterBox *box, ClutterLayoutManager *manager);

ClutterLayoutManager *clutter_box_get_layout_manager (ClutterBox *box);

void clutter_box_set_color (ClutterBox *box, const ClutterColor *color);

ClutterColor_copy *clutter_box_get_color (ClutterBox *box);
    PREINIT:
        ClutterColor color = { 0, };
    CODE:
        clutter_box_get_color (box, &color);
        RETVAL = &color;
    OUTPUT:
        RETVAL

##void clutter_box_packv (ClutterBox           *box,
##                        ClutterActor         *actor,
##                        guint                 n_properties,
##                        const gchar * const   properties[],
##                        const GValue         *values);
