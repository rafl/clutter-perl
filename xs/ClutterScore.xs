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

