#include "clutterperl.h"

MODULE = Gtk2::ClutterEmbed     PACKAGE = Gtk2::ClutterEmbed    PREFIX = gtk_clutter_

GtkWidget *
gtk_clutter_new (class)
    C_ARGS:
        /* void */

ClutterActor *
gtk_clutter_get_stage (GtkClutter *clutter)
