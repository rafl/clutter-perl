#include "clutter-perl-private.h"

MODULE = Clutter::Behaviour::Path       PACKAGE = Clutter::Behaviour::Path      PREFIX = clutter_behaviour_path_

ClutterBehaviour_noinc *
clutter_behaviour_path_new (class, alpha=NULL, path=NULL)
        ClutterAlpha_ornull *alpha
        ClutterPath_ornull *path
    CODE:
        RETVAL = clutter_behaviour_path_new (alpha, path);
    OUTPUT:
        RETVAL

ClutterPath_noinc *
clutter_behaviour_path_get_path (ClutterBehaviourPath *behaviour)

void
clutter_behaviour_path_set_path (ClutterBehaviourPath *behaviour, ClutterPath_ornull *path)
