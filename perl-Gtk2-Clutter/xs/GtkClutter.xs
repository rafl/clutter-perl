#include "clutter-gtk-perl.h"

MODULE = Gtk2::Clutter  PACKAGE = Gtk2::Clutter         PREFIX = gtk_clutter_

BOOT:
#include "register.xsh"
#include "boot.xsh"
        gperl_handle_logs_for ("Clutter-Gtk");


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
