#include "clutter-gst-perl.h"

MODULE = Clutter::GStreamer     PACKAGE = Clutter::GStreamer    PREFIX = clutter_gst_

BOOT:
#include "register.xsh"
#include "boot.xsh"
        gperl_handle_logs_for ("Clutter-Gst");

ClutterInitError clutter_gst_init (class=NULL);
    PREINIT:
        GPerlArgv *pargv;
    CODE:
        pargv = gperl_argv_new ();
        RETVAL = clutter_gst_init (&pargv->argc, &pargv->argv);
        gperl_argv_update (pargv);
        gperl_argv_free (pargv);
    OUTPUT:
        RETVAL
