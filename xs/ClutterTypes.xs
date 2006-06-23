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


MODULE = Clutter::Types		PACKAGE = Clutter::Color


ClutterColor_copy *
new (class, red, green, blue, alpha)
	guint8 red
	guint8 green
	guint8 blue
	guint8 alpha
    PREINIT:
        ClutterColor color;
    CODE:
        color.red = red;
	color.green = green;
	color.blue = blue;
	color.alpha = alpha;
        RETVAL = &color;
    OUTPUT:
        RETVAL

=for apidoc Clutter::Color::red
=for signature integer = $color->red
=for signature oldvalue = $color->red ($newvalue)
=for arg newvalue (integer)
=cut

=for apidoc Clutter::Color::green
=for signature integer = $color->green
=for signature oldvalue = $color->green ($newvalue)
=for arg newvalue (integer)
=cut

=for apidoc Clutter::Color::blue
=for signature integer = $color->blue
=for signature oldvalue = $color->blue ($newvalue)
=for arg newvalue (integer)
=cut

=for apidoc Clutter::Color::alpha
=for signature integer = $color->alpha
=for signature oldvalue = $color->alpha ($newvalue)
=for arg newvalue (integer)
=cut

guint8
red (ClutterColor *color, SV *newvalue = 0)
    ALIAS:
        Clutter::Color::green = 1
	Clutter::Color::blue  = 2
	Clutter::Color::alpha = 3
    CODE:
        switch (ix) {
		case 0: RETVAL = color->red;   break;
		case 1: RETVAL = color->green; break;
		case 2: RETVAL = color->blue;  break;
		case 3: RETVAL = color->alpha; break;
		default:
			RETVAL = 0;
			g_assert_not_reached ();
	}
	if (newvalue) {
	        switch (ix) {
			case 0: color->red   = SvIV (newvalue); break;
			case 1: color->green = SvIV (newvalue); break;
			case 2: color->blue  = SvIV (newvalue); break;
			case 3: color->alpha = SvIV (newvalue); break;
			default:
				g_assert_not_reached ();
		}
	}
    OUTPUT:
        RETVAL

=for apidoc
=for signature (red, green, blue, alpha) = $color->values
=cut
void
values (ClutterColor *color)
    PPCODE:
        EXTEND (SP, 4);
	PUSHs (sv_2mortal (newSViv (color->red)));
	PUSHs (sv_2mortal (newSViv (color->green)));
	PUSHs (sv_2mortal (newSViv (color->blue)));
	PUSHs (sv_2mortal (newSViv (color->alpha)));



MODULE = Clutter::Types		PACKAGE = Clutter::Geometry


ClutterGeometry_copy *
new (class, x, y, width, height)
	gint x
	gint y
	gint width
	gint height
    PREINIT:
        ClutterGeometry geometry;
    CODE:
        geometry.x = x;
	geometry.y = y;
	geometry.width = width;
	geometry.height = height;
    	RETVAL = &geometry;
    OUTPUT:
        RETVAL

=for apidoc Clutter::Geometry::x
=for signature integer = $geometry->x
=for signature oldvalue = $geometry->x ($newvalue)
=for arg newvalue (integer)
=cut

=for apidoc Clutter::Geometry::y
=for signature integer = $geometry->y
=for signature oldvalue = $geometry->y ($newvalue)
=for arg newvalue (integer)
=cut

=for apidoc Clutter::Geometry::width
=for signature integer = $geometry->width
=for signature oldvalue = $geometry->width ($newvalue)
=for arg newvalue (integer)
=cut

=for apidoc Clutter::Geometry::height
=for signature integer = $geometry->height
=for signature oldvalue = $geometry->height ($newvalue)
=for arg newvalue (integer)
=cut

gint
x (ClutterGeometry *geometry, SV *newvalue = 0)
    ALIAS:
        Clutter::Geometry::y      = 1
	Clutter::Geometry::width  = 2
	Clutter::Geometry::height = 3
    CODE:
        switch (ix) {
		case 0: RETVAL = geometry->x;      break;
		case 1: RETVAL = geometry->y;      break;
		case 2: RETVAL = geometry->width;  break;
		case 3: RETVAL = geometry->height; break;
		default:
			RETVAL = 0;
			g_assert_not_reached ();
	}
	if (newvalue) {
	        switch (ix) {
			case 0: geometry->x      = SvIV (newvalue); break;
			case 1: geometry->y      = SvIV (newvalue); break;
			case 2: geometry->width  = SvIV (newvalue); break;
			case 3: geometry->height = SvIV (newvalue); break;
			default:
				g_assert_not_reached ();
		}
	}
    OUTPUT:
        RETVAL

=for apidoc
=for signature (x, y, width, height) = $geometry->values
=cut
void
values (ClutterGeometry *geometry)
    PPCODE:
        EXTEND (SP, 4);
	PUSHs (sv_2mortal (newSViv (geometry->x)));
	PUSHs (sv_2mortal (newSViv (geometry->y)));
	PUSHs (sv_2mortal (newSViv (geometry->width)));
	PUSHs (sv_2mortal (newSViv (geometry->height)));
