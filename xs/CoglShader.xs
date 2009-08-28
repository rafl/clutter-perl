#include "clutter-perl-private.h"

MODULE = Clutter::Cogl::Shader  PACKAGE = Clutter::Cogl::Shader PREFIX = cogl_shader_

BOOT:
        cogl_perl_set_isa ("Clutter::Cogl::Shader", "Clutter::Cogl::Handle");

=for apidoc Clutter::Cogl::Shader - GLSL shader wrapper for Cogl
=cut

CoglHandle cogl_shader_new (class, CoglShaderType shader_type);
    CODE:
        RETVAL = cogl_create_shader (shader_type);
    OUTPUT:
        RETVAL

void cogl_shader_set_source (CoglHandle shader, const gchar *source);
    CODE:
        cogl_shader_source (shader, source);

void cogl_shader_compile (CoglHandle shader);

gchar_own *cogl_shader_get_info_log (CoglHandle shader);

CoglShaderType cogl_shader_get_type (CoglHandle shader);

MODULE = Clutter::Cogl::Shader  PACKAGE = Clutter::Cogl::Program  PREFIX = cogl_program_

BOOT:
        cogl_perl_set_isa ("Clutter::Cogl::Program", "Clutter::Cogl::Handle");


=for apidoc Clutter::Cogl::Program - Shader wrapper for Cogl
=cut

CoglHandle cogl_program_new (class);
    CODE:
        RETVAL = cogl_create_program ();
    OUTPUT:
        RETVAL

void cogl_program_attach_shader (CoglHandle program, CoglHandle shader);

void cogl_program_link (CoglHandle program);

void cogl_program_use (CoglHandle program);

gint cogl_program_get_uniform_location (CoglHandle program, const gchar *name);

##cogl_program_uniform_* is a bit lame; we should accept a SV* and
##decompose it into:
##      SvIOK -> uniform_1i
##      SvNOK -> uniform_1f
##      SvRV  -> uniform_int, uniform_float (uniform_matrix)

