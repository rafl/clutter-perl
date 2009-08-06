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

MODULE = Clutter::Timeline	PACKAGE = Clutter::Timeline	PREFIX = clutter_timeline_

ClutterTimeline_noinc *
clutter_timeline_new (class=NULL, guint duration)
    C_ARGS:
        duration

ClutterTimeline_noinc *
clutter_timeline_clone (class, ClutterTimeline *timeline)
    C_ARGS:
        timeline

guint
clutter_timeline_get_duration (ClutterTimeline *timeline)

void
clutter_timeline_set_duration (ClutterTimeline *timeline, guint msecs)

ClutterTimelineDirection
clutter_timeline_get_direction (ClutterTimeline *timeline)

void
clutter_timeline_set_direction (ClutterTimeline *timeline, ClutterTimelineDirection direction)

void
clutter_timeline_start (ClutterTimeline *timeline)

void
clutter_timeline_pause (ClutterTimeline *timeline)

void
clutter_timeline_stop (ClutterTimeline *timeline)

void
clutter_timeline_set_loop (ClutterTimeline *timeline, gboolean loop)

gboolean
clutter_timeline_get_loop (ClutterTimeline *timeline)

void
clutter_timeline_rewind (ClutterTimeline *timeline)

void
clutter_timeline_skip (ClutterTimeline *timeline, guint n_msecs)

void
clutter_timeline_advance (ClutterTimeline *timeline, guint n_msecs)

gboolean
clutter_timeline_is_playing (ClutterTimeline *timeline)

void
clutter_timeline_set_delay (ClutterTimeline *timeline, guint msecs)

guint
clutter_timeline_get_delay (ClutterTimeline *timeline)

gdouble
clutter_timeline_get_progress (ClutterTimeline *timeline)

guint
clutter_timeline_get_delta (ClutterTimeline *timeline)

void
clutter_timeline_add_marker_at_time (timeline, marker_name, msecs)
        ClutterTimeline *timeline
        const gchar     *marker_name
        guint            msecs

void
clutter_timeline_remove_marker (timeline, marker_name)
        ClutterTimeline *timeline
        const gchar     *marker_name

=for apidoc
=for signature markers = $timeline->list_markers ($msecs)
Retrieves all the markers at I<msecs>. If I<msecs> is
omitted or is a negative number, all the markers of I<timeline>
are returned
=cut
void
clutter_timeline_list_markers (ClutterTimeline *timeline, guint msecs=-1)
    PREINIT:
        gchar **markers;
        gsize n_markers, i;
    PPCODE:
        markers = clutter_timeline_list_markers (timeline,
                                                 msecs,
                                                 &n_markers);
        if (markers) {
                EXTEND (SP, n_markers);
                for (i = 0; i < n_markers; i++) {
                        PUSHs (sv_2mortal (newSVGChar (markers[i])));
                        g_free (markers[i]);
                }
                g_free (markers);
        }

gboolean
clutter_timeline_has_marker (timeline, marker_name)
        ClutterTimeline *timeline
        const gchar     *marker_name

void
clutter_timeline_advance_to_marker (timeline, marker_name)
        ClutterTimeline *timeline
        const gchar     *marker_name

