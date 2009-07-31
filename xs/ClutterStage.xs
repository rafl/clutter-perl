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

MODULE = Clutter::Stage		PACKAGE = Clutter::Stage	PREFIX = clutter_stage_

ClutterActor_noinc *
clutter_stage_get_default (class)
    C_ARGS:
        /* void */

ClutterActor_noinc *
clutter_stage_new (class)
    C_ARGS:
        /* void */

void
clutter_stage_set_color (ClutterStage *stage, ClutterColor *color)

ClutterColor_copy *
clutter_stage_get_color (ClutterStage *stage)
    PREINIT:
        ClutterColor color;
    CODE:
        clutter_stage_get_color (stage, &color);
	RETVAL = &color;
    OUTPUT:
        RETVAL

ClutterActor_noinc *
clutter_stage_get_actor_at_pos (ClutterStage *stage, ClutterPickMode mode, gfloat x, gfloat y)

void
clutter_stage_set_fullscreen (ClutterStage *stage, gboolean fullscreen)

gboolean
clutter_stage_get_fullscreen (ClutterStage *stage)

void
clutter_stage_show_cursor (ClutterStage *stage)

void
clutter_stage_hide_cursor (ClutterStage *stage)

void
clutter_stage_set_title (ClutterStage *stage, const gchar_ornull *title)

const gchar *
clutter_stage_get_title (ClutterStage *stage)

void
clutter_stage_event (ClutterStage *stage, ClutterEvent *event)

=for apidoc
=for signature (fovy, aspect, z_near, z_far) = $stage->get_perspective
=cut
void
clutter_stage_get_perspective (ClutterStage *stage)
    PREINIT:
        ClutterPerspective persp;
    PPCODE:
        clutter_stage_get_perspective (stage, &persp);
        EXTEND (SP, 4);
        PUSHs (sv_2mortal (newSVnv (persp.fovy)));
        PUSHs (sv_2mortal (newSVnv (persp.aspect)));
        PUSHs (sv_2mortal (newSVnv (persp.z_near)));
        PUSHs (sv_2mortal (newSVnv (persp.z_far)));

void
clutter_stage_set_perspective (stage, fovy, aspect, z_near, z_far)
        ClutterStage *stage
        double fovy
        double aspect
        double z_near
        double z_far
    PREINIT:
        ClutterPerspective persp;
    CODE:
        persp.fovy = fovy;
        persp.aspect = aspect;
        persp.z_near = z_near;
        persp.z_far = z_far;
        clutter_stage_set_perspective (stage, &persp);

void
clutter_stage_set_user_resizable (ClutterStage *stage, gboolean resizable)

gboolean
clutter_stage_get_user_resizable (ClutterStage *stage)

void
clutter_stage_set_use_fog (ClutterStage *stage, gboolean use_fog)

gboolean
clutter_stage_get_use_fog (ClutterStage *stage)

void
clutter_stage_set_fog (stage, z_near, z_far)
        ClutterStage *stage
        gdouble z_near
        gdouble z_far
    PREINIT:
        ClutterFog fog;
    CODE:
        fog.z_near = z_near;
        fog.z_far = z_far;
        clutter_stage_set_fog (stage, &fog);

=for apidoc
=for signature (z_near, z_far) = $stage->get_fog
=cut
void
clutter_stage_get_fog (ClutterStage *stage)
    PREINIT:
        ClutterFog fog = { 0, };
    PPCODE:
        clutter_stage_get_fog (stage, &fog);
        EXTEND (SP, 2);
        PUSHs (sv_2mortal (newSVnv (fog.z_near)));
        PUSHs (sv_2mortal (newSVnv (fog.z_far)));

void
clutter_stage_set_key_focus (ClutterStage *stage, ClutterActor_ornull *actor)

ClutterActor *
clutter_stage_get_key_focus (ClutterStage *stage)

gboolean
clutter_stage_is_default (ClutterStage *stage)
