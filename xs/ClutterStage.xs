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

ClutterActor *
clutter_stage_get_default (class)
    C_ARGS:
        /* void */

## Window   clutter_stage_get_xwindow         (ClutterStage *stage);
##
## gboolean clutter_stage_set_xwindow_foreign (ClutterStage *stage,
##                                             Window        xid);

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
clutter_stage_get_actor_at_pos (ClutterStage *stage, gint x, gint y)

GdkPixbuf_noinc *
clutter_stage_snapshot (ClutterStage *stage, gint x, gint y, gint width, gint height)
