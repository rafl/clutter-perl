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

MODULE = Clutter::Shader        PACKAGE = Clutter::Shader       PREFIX = clutter_shader_

=for object Clutter::Shader - Programmable pipeline abstraction
=cut

=for position DESCRIPTION

=head1 DESCRIPTION

B<Clutter::Shader> is an object providing an abstraction over the
OpenGL programmable pipeline. By using Clutter::Shader instances it
is possible to override the drawing pipeline by using small programs
also known as "shaders".

=cut

ClutterShader_noinc *
clutter_shader_new (class)
    C_ARGS:
        /* void */

void
clutter_shader_set_is_enabled (ClutterShader *shader, gboolean enabled)

gboolean
clutter_shader_get_is_enabled (ClutterShader *shader)

=for apidoc __gerror__
=cut
gboolean
clutter_shader_compile (ClutterShader *shader)
    PREINIT:
        GError *error = NULL;
    CODE:
        RETVAL = clutter_shader_compile (shader, &error);
        if (error)
                gperl_croak_gerror (NULL, error);
    OUTPUT:
        RETVAL

void
clutter_shader_release (ClutterShader *shader)

gboolean
clutter_shader_is_compiled (ClutterShader *shader)

void
clutter_shader_set_vertex_source (ClutterShader *shader, const gchar *source)
    CODE:
        clutter_shader_set_vertex_source (shader, source, -1);

const gchar *
clutter_shader_get_vertex_source (ClutterShader *shader)

void
clutter_shader_set_fragment_source (ClutterShader *shader, const gchar *source)
    CODE:
        clutter_shader_set_fragment_source (shader, source, -1);

const gchar *
clutter_shader_get_fragment_source (ClutterShader *shader)
