#include "clutter-gtk-perl.h"

MODULE = Gtk2::Clutter  PACKAGE = Gtk2::Clutter         PREFIX = gtk_clutter_

BOOT:
#include "register.xsh"
#include "boot.xsh"
        gperl_handle_logs_for ("Clutter-Gtk");

=for object Gtk2::Clutter::main
=cut

=for apidoc
Initializes Clutter and Gtk2::Clutter.

This function should be called instead of Clutter->init() and
Gtk2->init().
=cut
ClutterInitError
gtk_clutter_init (class=NULL)
    PREINIT:
        GPerlArgv *pargv;
    CODE:
        pargv = gperl_argv_new ();
        RETVAL = gtk_clutter_init (&pargv->argc, &pargv->argv);
        gperl_argv_update (pargv);
        gperl_argv_free (pargv);
    OUTPUT:
        RETVAL
