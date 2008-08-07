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

#include "clutterperl.h"

MODULE = Clutter::Timeline	PACKAGE = Clutter::Timeline	PREFIX = clutter_timeline_

ClutterTimeline_noinc *
clutter_timeline_new (class, n_frames, fps)
	guint n_frames
	guint fps
    C_ARGS:
        n_frames, fps

ClutterTimeline_noinc *
clutter_timeline_new_for_duration (class, msecs)
        guint msecs
    C_ARGS:
        msecs

ClutterTimeline_noinc *
clutter_timeline_clone (class, ClutterTimeline *timeline)
    C_ARGS:
        timeline

guint
clutter_timeline_get_duration (ClutterTimeline *timeline)

void
clutter_timeline_set_duration (ClutterTimeline *timeline, guint msecs)

guint
clutter_timeline_get_speed (ClutterTimeline *timeline)

void
clutter_timeline_set_speed (ClutterTimeline *timeline, guint fps)

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
clutter_timeline_skip (ClutterTimeline *timeline, guint nframes)

void
clutter_timeline_advance (ClutterTimeline *timeline, guint frame_num)

gint
clutter_timeline_get_current_frame (ClutterTimeline *timeline)

void
clutter_timeline_set_n_frames (ClutterTimeline *timeline, guint n_frames)

guint
clutter_timeline_get_n_frames (ClutterTimeline *timeline)

gboolean
clutter_timeline_is_playing (ClutterTimeline *timeline)

void
clutter_timeline_set_delay (ClutterTimeline *timeline, guint msecs)

guint
clutter_timeline_get_delay (ClutterTimeline *timeline)

gdouble
clutter_timeline_get_progress (ClutterTimeline *timeline)

=for apidoc
=for signature frames = $timeline->get_delta
=for signature (frames, msecs) = $timeline->get_delta
=cut
void
clutter_timeline_get_delta (ClutterTimeline *timeline)
    PREINIT:
        guint frames, msecs;
    PPCODE:
        frames = clutter_timeline_get_delta (timeline, &msecs);
        XPUSHs (sv_2mortal (newSVuv (frames)));
        if (GIMME_V == G_ARRAY) {
                XPUSHs (sv_2mortal (newSVuv (msecs)));
        }

void
clutter_timeline_add_marker_at_frame (timeline, marker_name, frame_num)
        ClutterTimeline *timeline
        const gchar     *marker_name
        guint            frame_num

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
=for signature markers = $timeline->list_markers ($frame_num)
Retrieves all the markers at I<frame_num>. If I<frame_num> is
omitted or is a negative number, all the markers of I<timeline>
are returned
=cut
void
clutter_timeline_list_markers (timeline, frame_num=-1)
        ClutterTimeline *timeline
        gint             frame_num
    PREINIT:
        gchar **markers;
        gsize n_markers, i;
    PPCODE:
        markers = clutter_timeline_list_markers (timeline,
                                                 frame_num,
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

