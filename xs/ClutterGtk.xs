#include "clutterperl.h"

MODULE = Gtk2::ClutterEmbed     PACKAGE = Gtk2::ClutterEmbed    PREFIX = gtk_clutter_embed_

GtkWidget *
gtk_clutter_embed_new (class)
    C_ARGS:
        /* void */

ClutterActor *
gtk_clutter_embed_get_stage (GtkClutterEmbed *embed)
