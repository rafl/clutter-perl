#include "clutterperl-private.h"

CoglMatrix *
cogl_perl_copy_matrix (const CoglMatrix *matrix)
{
        CoglMatrix *dest;
        const gfloat *array;

        dest = gperl_alloc_temp (sizeof (CoglMatrix));
        array = cogl_matrix_get_array (matrix);
        cogl_matrix_init_from_array (dest, array);

        return dest;
}

MODULE = Clutter::Cogl::Matrix  PACKAGE = Clutter::Cogl::Matrix PREFIX = cogl_matrix_

=for position DESCRIPTION

=head1 DESCRIPTION

A B<Clutter::Cogl::Matrix> holds a 4x4 transform matrix. This is a single
precision, column-major matrix which means it is compatible with what
OpenGL expects.

A lMatrix can represent transforms such as, rotations, scaling, translation,
sheering, and linear projections. You can combine these transforms by
multiplying multiple matrices in the order you want them applied.

The transformation of a vertex (x, y, z, w) by a Clutter::Cogl::Matrix is
given by:

    x_new = xx * x + xy * y + xz * z + xw * w
    y_new = yx * x + yy * y + yz * z + yw * w
    z_new = zx * x + zy * y + zz * z + zw * w
    w_new = wx * x + wy * y + wz * z + ww * w

Where w is normally 1

B<Note>: You must consider the members of the Clutter::Cogl::Matrix structure
read only, and all matrix modifications must be done via the Matrix API. This
allows Cogl to annotate the matrices internally. Violation of this will give
undefined results. If you need to initialize a matrix with a constant other
than the identity matrix you can use cogl_matrix_init_from_array().

=cut

CoglMatrix *cogl_matrix_init_identity (class);
    PREINIT:
        CoglMatrix matrix;
    CODE:
        cogl_matrix_init_identity (&matrix);
        RETVAL = cogl_perl_copy_matrix (&matrix);
    OUTPUT:
        RETVAL

CoglMatrix *cogl_matrix_multiply (CoglMatrix *op1, CoglMatrix *op2);
    PREINIT:
        CoglMatrix result;
    CODE:
        cogl_matrix_multiply (&result, op1, op2);
        RETVAL = cogl_perl_copy_matrix (&result);
    OUTPUT:
        RETVAL

void
cogl_matrix_rotate (CoglMatrix *matrix, float angle, float x, float y, float z)

void
cogl_matrix_translate (CoglMatrix *matrix, float x, float y, float z)

void
cogl_matrix_scale (CoglMatrix *matrix, double sx, double sy, double sz)

void
cogl_matrix_frustum (matrix, left, right, bottom, top, z_near, z_far)
        CoglMatrix *matrix
        float left
        float right
        float bottom
        float top
        float z_near
        float z_far

void
cogl_matrix_perspective (matrix, fov_y, aspect, z_near, z_far)
        CoglMatrix *matrix
        float fov_y
        float aspect
        float z_near
        float z_far

void
cogl_matrix_ortho (matrix, left, right, bottom, top, z_near, z_far)
        CoglMatrix *matrix
        float left
        float right
        float bottom
        float top
        float z_near
        float z_far

=for apidoc
=for signature array = $matrix->get_array
Converts I<matrix> to an array of 16 floating point values which
can be passed to OpenGL.
=cut
void
cogl_matrix_get_array (CoglMatrix *matrix)
    PREINIT:
        const float *array;
        int i;
    PPCODE:
        array = cogl_matrix_get_array (matrix);
        EXTEND (SP, 16);
        for (i = 0; i < 16; i++) {
                PUSHs (sv_2mortal (newSVnv (array[i])));
        }

=for apidoc
=for signature (x, y, z, w) = $matrix->transform_point (x, y, z, w)
=cut
void
cogl_matrix_transform_point (matrix, x, y, z, w)
        CoglMatrix *matrix
        float x
        float y
        float z
        float w
    PREINIT:
        float x_res, y_res, z_res, w_res;
    PPCODE:
        /* transform_point() parameters are in-out, so we need to
         * copy the arguments to avoid modifying them
         */
        x_res = x;
        y_res = y;
        z_res = z;
        w_res = w;
        cogl_matrix_transform_point (matrix, &x_res, &y_res, &z_res, &w_res);
        EXTEND (SP, 4);
        PUSHs (sv_2mortal (newSVnv (x_res)));
        PUSHs (sv_2mortal (newSVnv (y_res)));
        PUSHs (sv_2mortal (newSVnv (z_res)));
        PUSHs (sv_2mortal (newSVnv (w_res)));

