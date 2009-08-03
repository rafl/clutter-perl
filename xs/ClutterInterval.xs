#include "clutterperl-private.h"

static void
clutterperl_interval_sink (GObject *object)
{
        g_object_ref_sink (object);
        g_object_unref (object);
}

MODULE = Clutter::Interval      PACKAGE = Clutter::Interval     PREFIX = clutter_interval_

BOOT:
        gperl_register_sink_func (CLUTTER_TYPE_INTERVAL, clutterperl_interval_sink);


