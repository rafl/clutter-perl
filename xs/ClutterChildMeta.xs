#include "clutter-perl-private.h"

MODULE = Clutter::ChildMeta     PACKAGE = Clutter::ChildMeta    PREFIX = clutter_child_meta_

=for object Clutter::ChildMeta - Wrapper for actors inside a container
=cut

=for position DESCRIPTION

=head1 DESCRIPTION

B<Clutter::ChildMeta> is a wrapper object created by L<Clutter::Container>
implementations in order to store child-specific data and properties.

A Clutter::ChildMeta wraps a L<Clutter::Actor> inside a L<Clutter::Container>
and it is used to store child properties that can later be accessed using
Clutter::Container::child_set() and Clutter::Container::child_get().

See the L<Clutter::Container> documentation on how to create ChildMeta
objects when implementing a Container actor.

=cut

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
