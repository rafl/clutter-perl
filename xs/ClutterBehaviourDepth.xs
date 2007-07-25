#include "clutterperl.h"

MODULE = Clutter::Behaviour::Depth PACKAGE = Clutter::Behaviour::Depth PREFIX = clutter_behaviour_depth_

ClutterBehaviour_noinc *
clutter_behaviour_depth_new (class, alpha=NULL, depth_start, depth_end)
        ClutterAlpha_ornull *alpha
        gint depth_start
        gint depth_end
    C_ARGS:
        alpha, depth_start, depth_end
