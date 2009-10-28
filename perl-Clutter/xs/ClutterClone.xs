#include "clutter-perl-private.h"

MODULE = Clutter::Clone PACKAGE = Clutter::Clone        PREFIX = clutter_clone_

=for object Clutter::Clone - An actor that displays a clone of a source actor
=cut

=for position DESCRIPTION

=head1 SYNOPSIS

    my $clone = Clutter::Clone->new($actor);

=head1 DESCRIPTION

B<Clutter::Clone> is a L<Clutter::Actor> which draws with the paint
function of another actor, scaled to fit its own allocation.

Clutter::Clone can be used to efficiently clone any other actor, including
containers.

B<Note>: This is different from Clutter::Texture::new_from_actor()
which requires support for FBOs in the underlying GL implementation.

=cut

ClutterActor *clutter_clone_new (class, ClutterActor *source);
    C_ARGS:
        source

void clutter_clone_set_source (ClutterClone *clone, ClutterActor *source);

ClutterActor *clutter_clone_get_source (ClutterClone *clone);
