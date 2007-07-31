#include "clutterperl.h"

MODULE = Clutter::Gst   PACKAGE = Clutter::Gst  PREFIX = clutter_gst_

ClutterInitError
clutter_gst_init (class=NULL)
    PREINIT:
        GPerlArgv *pargv;
    CODE:
        pargv = gperl_argv_new ();
        RETVAL = clutter_gst_init (&pargv->argc, &pargv->argv);
        gperl_argv_update (pargv); 
        gperl_argv_free (pargv);
    OUTPUT:
        RETVAL

