#include "clutter-gtk-perl.h"

MODULE = Gtk2::Clutter::Embed   PACKAGE = Gtk2::Clutter::Embed  PREFIX = gtk_clutter_embed_

=for apidoc
Creates a new Gtk2::Widget embedding a Clutter::Stage.

B<Note>: remember to use Gtk2::Clutter::Embed::get_stage() and
never use Clutter::Stage::get_default() or Clutter::Stage::new()
when using a Gtk2::Clutter::Embed.
=cut
GtkWidget *gtk_clutter_embed_new (class=NULL);
    C_ARGS:
        /* void */

=for apidoc
Retrieves the Clutter::Stage embedded by I<embed>
=cut
ClutterActor *gtk_clutter_embed_get_stage (GtkClutterEmbed *embed);
