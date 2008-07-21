#include "clutterperl.h"

MODULE = Clutter::Gtk   PACKAGE = Clutter::Gtk  PREFIX = clutter_gtk_

=for apidoc
Special initialization function for the GTK+ integration.

You should use this function instead of Gtk2::init and Clutter::init
if you plan to use the L<Gtk2::ClutterEmbed> widget.
=cut
ClutterInitError
clutter_gtk_init (class=NULL)
    PREINIT:
        GPerlArgv *pargv;
    CODE:
        pargv = gperl_argv_new ();
        RETVAL = gtk_clutter_init (&pargv->argc, &pargv->argv);
        gperl_argv_update (pargv); 
        gperl_argv_free (pargv);
    OUTPUT:
        RETVAL

