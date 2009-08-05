#include "clutterperl-private.h"

MODULE = Clutter::Clone PACKAGE = Clutter::Clone        PREFIX = clutter_clone_

ClutterActor *clutter_clone_new (class, ClutterActor *source);
    C_ARGS:
        source

void clutter_clone_set_source (ClutterClone *clone, ClutterActor *source);

ClutterActor *clutter_clone_get_source (ClutterClone *clone);
