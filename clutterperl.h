#ifndef _CLUTTER_PERL_H_
#define _CLUTTER_PERL_H_

#include <gtk2perl.h>
#include <clutter/clutter.h>

#ifdef CLUTTERPERL_GST
#include <clutter-gst/clutter-gst.h>
#endif

#include "clutterperl-autogen.h"

const char *clutterperl_event_get_package (ClutterEvent *event);

#endif /* _CLUTTER_PERL_H_ */
