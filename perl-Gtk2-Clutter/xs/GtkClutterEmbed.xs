#include "clutter-gtk-perl.h"

MODULE = Gtk2::Clutter::Embed   PACKAGE = Gtk2::Clutter::Embed  PREFIX = gtk_clutter_embed_

GtkWidget *gtk_clutter_embed_new (class=NULL);
    C_ARGS:
        /* void */

ClutterActor *gtk_clutter_embed_get_stage (GtkClutterEmbed *embed);
