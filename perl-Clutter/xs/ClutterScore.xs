/* Clutter.
 *
 * Perl bindings for the OpenGL based 'interactive canvas' library.
 *
 * Clutter Authored By Matthew Allum  <mallum@openedhand.com>
 * Perl bindings by Emmanuele Bassi  <ebassi@openedhand.com>
 * 
 * Copyright (C) 2006 OpenedHand
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the
 * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
 * Boston, MA 02111-1307, USA.
 */

#include "clutter-perl-private.h"

MODULE = Clutter::Score PACKAGE = Clutter::Score        PREFIX = clutter_score_

=for object Clutter::Score - Controller for multiple timelines
=cut

=for position DESCRIPTION

=head1 SYNOPSIS

    my $t1 = Clutter::Timeline->new(200);
    my $t2 = Clutter::Timeline->new(200);
    my $t3 = Clutter::Timeline->new(500);

    my $score = Clutter::Score->new();
    $score->append(undef, $t1); # appends t1 to the beginning
    $score->append($t1,   $t2); # appends t2 to t1
    $score->append($t1,   $t3); # appends t3 to t1

=head1 DESCRIPTION

B<Clutter::Score is a base class for sequencing multiple timelines in order.

Using Clutter::Score it is possible to start multiple timelines at the
same time or launch multiple timelines when a particular timeline has
emitted the Clutter::Timeline::completed signal.

Each time a L<Clutter::Timeline> is started and completed, a signal will be
emitted.

A Clutter::Score takes a reference on the timelines it manages, so scalars
referencing timelines can be safely discarded as long as the score remains
referenced.

New timelines can be appended to the Clutter::Score using the append()
method, and removed using the remove() one.

Timelines can also be appended to a specific marker on the parent timeline,
using Clutter::Score::append_at_marker().

The score can be cleared using Clutter::Score::remove_all().

The list of timelines can be retrieved using Clutter::Score::list_timelines().

The score state is controlled using Clutter::Score::start(),
Clutter::Score::pause(), Clutter::Score::stop() and
Clutter::Score::rewind().

The state can be queried using Clutter::Score::is_playing().

=cut

=for position SEE_ALSO

=head1 SEE ALSO

L<Clutter::Timeline>

=cut

ClutterScore_noinc *
clutter_score_new (class)
    C_ARGS:
        /* void */

void
clutter_score_set_loop (ClutterScore *score, gboolean loop)

gboolean
clutter_score_get_loop (ClutterScore *score)

guint
clutter_score_append (score, parent, timeline)
        ClutterScore *score
        ClutterTimeline_ornull *parent
        ClutterTimeline *timeline

void
clutter_score_remove (ClutterScore *score, guint id)

void
clutter_score_remove_all (ClutterScore *score)

ClutterTimeline_noinc *
clutter_score_get_timeline (ClutterScore *score, guint id)

=for apidoc
=for signature timelines = $score->list_timelines
=cut
void
clutter_score_list_timelines (ClutterScore *score)
    PREINIT:
        GSList *timelines = NULL;
    PPCODE:
        timelines = clutter_score_list_timelines (score);
        if (timelines) {
                GSList *l;
                EXTEND (SP, g_slist_length (timelines));
                for (l = timelines; l; l = l->next)
                        PUSHs (sv_2mortal (newSVClutterTimeline (l->data)));
        }

void
clutter_score_start (ClutterScore *score)

void
clutter_score_stop (ClutterScore *score)

void
clutter_score_pause (ClutterScore *score)

void
clutter_score_rewind (ClutterScore *score)

gboolean
clutter_score_is_playing (ClutterScore *score)

