#include "clutter-perl-private.h"

static const char *
get_package (CoglHandle handle)
{
        const char *package;

        if (cogl_is_texture (handle)) {
                package = "Clutter::Cogl::Texture";
        }
        else if (cogl_is_offscreen (handle)) {
                package = "Clutter::Cogl::Offscreen";
        }
        else if (cogl_is_vertex_buffer (handle)) {
                package = "Clutter::Cogl::VertexBuffer";
        }
        else if (cogl_is_shader (handle)) {
                package = "Clutter::Cogl::Shader";
        }
        else if (cogl_is_program (handle)) {
                package = "Clutter::Cogl::Program";
        }
        else if (cogl_is_material (handle)) {
                package = "Clutter::Cogl::Material";
        }
        else if (cogl_is_bitmap (handle)) {
                package = "Clutter::Cogl::Bitmap";
        }
        else {
                warn ("Unknown handle type");
                package = "Clutter::Cogl::Handle";
        }

        return package;
}

SV *
cogl_perl_handle_to_sv (CoglHandle handle)
{
        SV *sv = newSV (0);

        sv_setref_pv (sv, get_package (handle), handle);

        return sv;
}

MODULE = Clutter::Cogl::Handle  PACKAGE = Clutter::Cogl::Handle  PREFIX = cogl_handle_

=for object Clutter::Cogl::Handle - Base class for COGL objects
=cut

=for position DESCRIPTION

=head1 DESCRIPTION

B<Clutter::Cogl::Handle> is an opaque data type that is used to
store a handle to a GL or GLES resource. A handle can point to a
texture, or a shader program, or an offscreen buffer.

The nature and contents of the handle are completely shielded
from the Perl developer; a handle can only be used with the
Clutter::Cogl functions.

=cut

void DESTROY (CoglHandle handle)
    CODE:
        cogl_handle_unref (handle);
