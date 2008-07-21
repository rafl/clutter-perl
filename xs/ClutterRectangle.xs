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

MODULE = Clutter::Rectangle	PACKAGE = Clutter::Rectangle	PREFIX = clutter_rectangle_


ClutterActor_noinc *
clutter_rectangle_new (class, color=NULL)
	ClutterColor_ornull *color
    CODE:
    	if (color)
		RETVAL = clutter_rectangle_new_with_color (color);
	else
        	RETVAL = clutter_rectangle_new ();
    OUTPUT:
        RETVAL
	
ClutterColor_copy *
clutter_rectangle_get_color (ClutterRectangle *rectangle)
    PREINIT:
        ClutterColor color;
    CODE:
        clutter_rectangle_get_color (rectangle, &color);
	RETVAL = &color;
    OUTPUT:
        RETVAL

void
clutter_rectangle_set_color (ClutterRectangle *rectangle, ClutterColor *color)

guint
clutter_rectangle_get_border_width (ClutterRectangle *rectangle)

void
clutter_rectangle_set_border_width (ClutterRectangle *rectangle, guint border_width)

ClutterColor_copy *
clutter_rectangle_get_border_color (ClutterRectangle *rectangle)
    PREINIT:
        ClutterColor color;
    CODE:
        clutter_rectangle_get_border_color (rectangle, &color);
        RETVAL = &color;
    OUTPUT:
        RETVAL

void
clutter_rectangle_set_border_color (ClutterRectangle *rectangle, ClutterColor *color)
