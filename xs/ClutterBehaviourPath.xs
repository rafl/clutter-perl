#include "clutter-perl-private.h"

MODULE = Clutter::Behaviour::Path       PACKAGE = Clutter::Behaviour::Path      PREFIX = clutter_behaviour_path_

=for object Clutter::Behaviour::Path - A behaviour for moving actors along a Clutter::Path
=cut

=for position DESCRIPTION

=head1 SYNOPSIS

    my $path = Clutter::Path->new('M 10,10 C 20,20 20,20 10,30 z');

    my $behaviour = Clutter::Behaviour::Path->new($alpha, $path);
    $behaviour->apply($rectangle);

=head1 DESCRIPTION

L<Clutter::Behaviour::Path> interpolates actors along a defined path.

A path is described by a L<Clutter::Path> object. The path can contain
straight line parts and bezier curves. If the path contains 'move-to' nodes
then the actors will jump to those coordinates. This can be used make
disjoint paths.

When creating a path behaviour in a L<Clutter::Script>, you can specify
the path property directly as a string. For example:

    {
      "id"     : "spline-path",
      "type"   : "ClutterBehaviourPath",
      "path"   : "M 50 50 L 100 100",
      "alpha"  : {
        "timeline" : "main-timeline",
        "function" : "ramp
      }
    }

B<Note>: If the alpha function is a periodic function, i.e. it returns to
0 after reaching the maximum alpha value, then the actors will walk the
path backwards to the starting node.

=cut

=for position SEE_ALSO

=head1 SEE ALSO

L<Clutter::Path>, L<Clutter::Behaviour>, L<Clutter::Alpha>

=cut

ClutterBehaviour_noinc *
clutter_behaviour_path_new (class, alpha=NULL, path=NULL)
        ClutterAlpha_ornull *alpha
        ClutterPath_ornull *path
    CODE:
        RETVAL = clutter_behaviour_path_new (alpha, path);
    OUTPUT:
        RETVAL

ClutterPath *
clutter_behaviour_path_get_path (ClutterBehaviourPath *behaviour)

void
clutter_behaviour_path_set_path (ClutterBehaviourPath *behaviour, ClutterPath_ornull *path)
