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

MODULE = Clutter::Backend       PACKAGE = Clutter::Backend      PREFIX = clutter_backend_

=for object Clutter::Backend - Clutter Backend abstraction
=cut

=for position DESCRIPTION

=head1 DESCRIPTION

Clutter can be compiled against different backends. Each backend
has to implement a set of functions, in order to be used by Clutter.

B<Clutter::Backend is the base class abstracting the various implementation;
it provides a basic API to query the backend for generic information
and settings.

=cut

ClutterBackend_noinc *
clutter_backend_get_default (class)
    CODE:
        RETVAL = clutter_get_default_backend ();
    OUTPUT:
        RETVAL

=for apidoc
Sets the time, in millisecond, between two button press events that will be
used to verify if a double click event should be emitted.
=cut
void
clutter_backend_set_double_click_time (ClutterBackend *backend, guint msec)

=for apidoc
Gets the time set using Clutter::Backend-E<gt>set_double_click_time().
=cut
guint
clutter_backend_get_double_click_time (ClutterBackend *backend)

=for apidoc
Sets the distance, in pixels, between to button press events that will be
used to verify if a double click event should be emitted.
=cut
void
clutter_backend_set_double_click_distance (ClutterBackend *backend, guint distance)

=for apidoc
Gets the distance set using Clutter::Backend-E<gt>set_double_click_distance().
=cut
guint
clutter_backend_get_double_click_distance (ClutterBackend *backend)

=for apidoc
Sets the resolution, in dpi, of the backend. The resolution is used when
transforming the font size from points to pixels.

Applications should never use this function.
=cut
void
clutter_backend_set_resolution (ClutterBackend *backend, gdouble dpi)

=for apidoc
Gets the resolution, in dpi, of the backend.
=cut
gdouble
clutter_backend_get_resolution (ClutterBackend *backend)

const cairo_font_options_t *
clutter_backend_get_font_options (ClutterBackend *backend)

void
clutter_backend_set_font_options (ClutterBackend *backend, const cairo_font_options_t_ornull *options)

