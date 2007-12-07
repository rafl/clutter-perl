#include "clutterperl.h"

MODULE = Clutter::Behaviour::Depth PACKAGE = Clutter::Behaviour::Depth PREFIX = clutter_behaviour_depth_

ClutterBehaviour_noinc *
clutter_behaviour_depth_new (class, alpha=NULL, depth_start, depth_end)
        ClutterAlpha_ornull *alpha
        gint depth_start
        gint depth_end
    C_ARGS:
        alpha, depth_start, depth_end

void
clutter_behaviour_depth_set_bounds (behaviour, start, end)
        ClutterBehaviourDepth *behaviour
        gint start
        gint end
    CODE:
        g_object_set (G_OBJECT (behaviour),
                      "depth-start", start,
                      "depth-end", end,
                      NULL);

=for apidoc
=for signature (start, end) = $behaviour->get_bounds
=cut
void
clutter_behaviour_depth_get_bounds (ClutterBehaviourDepth *behaviour)
    PREINIT:
        gint start, end;
    PPCODE:
        g_object_get (G_OBJECT (behaviour),
                      "depth-start", &start,
                      "depth-end", &end,
                      NULL);
        EXTEND (SP, 2);
        PUSHs (sv_2mortal (newSViv (start)));
        PUSHs (sv_2mortal (newSViv (end)));

