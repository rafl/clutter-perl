#include "clutter-perl-private.h"

MODULE = Clutter::ChildMeta     PACKAGE = Clutter::ChildMeta    PREFIX = clutter_child_meta_

void
clutter_child_meta_set_container (ClutterChildMeta *meta, ClutterContainer *container)
    CODE:
        meta->container = container;

void
clutter_child_meta_set_actor (ClutterChildMeta *meta, ClutterActor *actor)
    CODE:
        meta->actor = actor;

ClutterContainer *
clutter_child_meta_get_container (ClutterChildMeta *meta)

ClutterActor *
clutter_child_meta_get_actor (ClutterChildMeta *meta)
