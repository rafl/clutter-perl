#include "clutter-perl-private.h"

MODULE = Clutter::Cogl::Material        PACKAGE = Clutter::Cogl::Material       PREFIX = cogl_material_

BOOT:
        cogl_perl_set_isa ("Clutter::Cogl::Material", "Clutter::Cogl::Handle");

=for position DESCRIPTION

=head1 DESCRIPTION

COGL allows creating and manipulating materials used to fill in
geometry. Materials may simply be lighting attributes (such as an
ambient and diffuse colour) or might represent one or more textures
blended together.

=cut

=for enum Clutter::Cogl::MaterialFilter
=cut

=for enum Clutter::Cogl::MaterialAlphaFunc
=cut

=for enum Clutter::Cogl::MaterialLayerType
=cut

=for position post_enums

=head1 BLEND STRINGS

Describing GPU blending and texture combining states is rather awkward
to do in a concise but also readable fashion. Cogl helps by supporting
string based descriptions using a simple syntax.

=head2 Some Examples

The following string replaces glBlendFunc[Separate] and
glBlendEquation[Separate]:

    RGBA = ADD (SRC_COLOR * (SRC_COLOR[A]), DST_COLOR * (1-SRC_COLOR[A]))"

In this case the blend string is actually slightly more verbose than the
GL counterpart:

    glBlendFunc (GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

Though, unless you are familiar with OpenGL or refer to its API documentation
you wouldn't know that the default function used by OpenGL is GL_FUNC_ADD
nor would you know that the above arguments determine what the source color
and destination color will be multiplied by before being adding.

The following string can be used for texture combining:

    RGB = REPLACE (PREVIOUS)
    A = MODULATE (PREVIOUS, TEXTURE)

In OpenGL terms, it replaces glTexEnv, and the above example is equivalent
to this OpenGL code:

    glTexEnvi (GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_COMBINE);
    glTexEnvi (GL_TEXTURE_ENV, GL_COMBINE_RGB, GL_REPLACE);
    glTexEnvi (GL_TEXTURE_ENV, GL_COMBINE_ALPHA, GL_REPLACE);
    glTexEnvi (GL_TEXTURE_ENV, GL_SRC0_RGB, GL_PREVIOUS);
    glTexEnvi (GL_TEXTURE_ENV, GL_OPERAND0_RGB, GL_SRC_COLOR);
    glTexEnvi (GL_TEXTURE_ENV, GL_COMBINE_ALPHA, GL_MODULATE);
    glTexEnvi (GL_TEXTURE_ENV, GL_SRC0_RGB, GL_PREVIOUS);
    glTexEnvi (GL_TEXTURE_ENV, GL_OPERAND0_RGB, GL_SRC_COLOR);
    glTexEnvi (GL_TEXTURE_ENV, GL_SRC1_RGB, GL_TEXTURE);
    glTexEnvi (GL_TEXTURE_ENV, GL_OPERAND1_RGB, GL_SRC_COLOR);

=head2 Blend Strings Syntax

=over

=item <statement>

  <channel-mask> = <function-name>(<arg-list>)

You can either use a single statement with an RGBA channel-mask or you can
use two statements; one with an A channel-mask and the other with an RGB
channel-mask.

=item <channel-mask>

  A or RGB or RGBA

=item <function-name>

  [A-Za-z_]*

=item <arg-list>

  <arg>,<arg>
  or <arg>
  or ""

I.e. functions may take 0 or more arguments

=item <arg>

  <color-source>
  1 - <color-source>            : Only intended for texture combining
  <color-source> * ( <factor> ) : Only intended for blending
  0                             : Only intended for blending

See the blending or texture combining sections for further notes and examples.

=item <color-source>

  <source-name>[<channel-mask>]
  <source-name>

See the blending or texture combining sections for the list of source-names
valid in each context.

If a channel mask is not given then the channel mask of the statement
is assumed instead.

=item <factor>

  0
  1
  <color-source>
  1 - <color-source>
  SRC_ALPHA_SATURATE

=back

=cut

=for apidoc
Creates a new white Clutter::Cogl::Material.
=cut
CoglHandle cogl_material_new (class);
    C_ARGS:
        /* void */

=for apidoc
=for signature $material->set_color ($color)
=for arg color (CoglColor)
Sets the basic color of the material, used when no lighting is enabled.
=cut
void cogl_material_set_color (CoglHandle material, SV *color);
    PREINIT:
        CoglColor c;
    CODE:
        cogl_perl_color_from_sv (color, &c);
        cogl_material_set_color (material, &c);

=for apidoc
=for signature (red, green, blue, alpha) = $material->get_color
=cut
SV *cogl_material_get_color (CoglHandle material);
    PREINIT:
        CoglColor c;
    CODE:
        cogl_material_get_color (material, &c);
        RETVAL = cogl_perl_color_to_sv (&c);
    OUTPUT:
        RETVAL

=for apidoc
=for arg color (CoglColor)
Exposing the standard OpenGL lighting model; this function sets
the material's ambient color. The ambient color affects the overall
color of the object. Since the diffuse color will be intense when
the light hits the surface directly, the ambient will most aparent
where the light hits at a slant.

The default value is: (0.2, 0.2, 0.2, 1.0)
=cut
void cogl_material_set_ambient (CoglHandle material, SV *color);
    PREINIT:
        CoglColor c;
    CODE:
        cogl_perl_color_from_sv (color, &c);
        cogl_material_set_ambient (material, &c);

=for apidoc
=for signature (red, green, blue, alpha) = $material->get_ambient
=cut
SV *cogl_material_get_ambient (CoglHandle material);
    PREINIT:
        CoglColor c;
    CODE:
        cogl_material_get_ambient (material, &c);
        RETVAL = cogl_perl_color_to_sv (&c);
    OUTPUT:
        RETVAL

=for apidoc
=for arg color (CoglColor)
Exposing the standard OpenGL lighting model; this function sets
the material's diffuse color. The diffuse color is most intense
where the light hits the surface directly; perpendicular to the
surface.

The default value is (0.8, 0.8, 0.8, 1.0)
=cut
void cogl_material_set_diffuse (CoglHandle material, SV *color);
    PREINIT:
        CoglColor c;
    CODE:
        cogl_perl_color_from_sv (color, &c);
        cogl_material_set_diffuse (material, &c);

=for apidoc
=for signature (red, green, blue, alpha) = $material->get_diffuse
=cut
SV *cogl_material_get_diffuse (CoglHandle material);
    PREINIT:
        CoglColor c;
    CODE:
        cogl_material_get_diffuse (material, &c);
        RETVAL = cogl_perl_color_to_sv (&c);
    OUTPUT:
        RETVAL

=for apidoc
=for arg color (CoglColor)
Exposing the standard OpenGL lighting model; this function sets
the material's specular color. The intensity of the specular color
depends on the viewport position, and is brightest along the lines
of reflection.

The default value is (0.0, 0.0, 0.0, 1.0)
=cut
void cogl_material_set_specular (CoglHandle material, SV *color);
    PREINIT:
        CoglColor c;
    CODE:
        cogl_perl_color_from_sv (color, &c);
        cogl_material_set_specular (material, &c);

=for apidoc
=for signature (red, green, blue, alpha) = $material->get_specular
=cut
SV *cogl_material_get_specular (CoglHandle material);
    PREINIT:
        CoglColor c;
    CODE:
        cogl_material_get_specular (material, &c);
        RETVAL = cogl_perl_color_to_sv (&c);
    OUTPUT:
        RETVAL

=for apidoc
This function sets the materials shininess which determines how
specular highlights are calculated. A higher shininess will produce
smaller brigher highlights. The I<shininess> parameter must be
a value between 0.0 and 1.0.

The default value is 0.0.
=cut
void cogl_material_set_shininess (CoglHandle material, float shininess);

float cogl_material_get_shininess (CoglHandle material);

=for apidoc
=for arg color (CoglColor)
Exposing the standard OpenGL lighting model; this function sets
the material's emissive color. It will look like the surface is
a light source emitting this color.

The default value is (0.0, 0.0, 0.0, 1.0)
=cut
void cogl_material_set_emission (CoglHandle material, SV *color);
    PREINIT:
        CoglColor c;
    CODE:
        cogl_perl_color_from_sv (color, &c);
        cogl_material_set_emission (material, &c);

=for apidoc
=for signature (red, green, blue, alpha) = $material->get_emission
=cut
SV *cogl_material_get_emission (CoglHandle material);
    PREINIT:
        CoglColor c;
    CODE:
        cogl_material_get_emission (material, &c);
        RETVAL = cogl_perl_color_to_sv (&c);
    OUTPUT:
        RETVAL

=for apidoc
Before a primitive is blended with the framebuffer, it goes through an
alpha test stage which lets you discard fragments based on the current
alpha value. This function lets you change the function used to evaluate
the alpha channel, and thus determine which fragments are discarded
and which continue on to the blending stage.

The default is 'always'.
=cut
void cogl_material_set_alpha_test_function (CoglHandle material, CoglMaterialAlphaFunc function, float reference);

=for apidoc __gerror__
If not already familiar; please refer to the L<BLEND STRINGS> section for an
overview of what blend strings are and their syntax.

Blending occurs after the alpha test function, and combines fragments with
the framebuffer.

Currently the only blend function Cogl exposes is ADD(). So any valid
blend statements will be of the form:

    <channel-mask> = ADD(SRC_COLOR*(<factor>), DST_COLOR*(<factor>))

B<Warning>: The brackets around blend factors are currently not optional!

This is the list of source-names usable as blend factors:

=over

=item SRC_COLOR

The color of the in comming fragment

=item DST_COLOR

The color of the framebuffer

=item CONSTANT

The constant set via Clutter::Cogl::Material::set_blend_constant()

=back

The source names can be used according to the color-source and factor
syntax, so for example "(1-SRC_COLOR[A])" would be a valid factor, as
would "(CONSTANT[RGB])".

These can also be used as factors:

=over

=item 0: (0, 0, 0, 0)

=item 1: (1, 1, 1, 1)

=item SRC_ALPHA_SATURATE_FACTOR: (f, f, f, 1)

Where f = MIN(SRC_COLOR[A], 1 - DST_COLOR[A])

=back

Remember; all color components are normalized to the range [0, 1] before
computing the result of blending.

B<Examples>

=over

=item Blend a non-premultiplied source over a destination with premultiplied alpha:

    "RGB = ADD(SRC_COLOR*(SRC_COLOR[A]), DST_COLOR*(1-SRC_COLOR[A]))"
    "A   = ADD(SRC_COLOR, DST_COLOR*(1-SRC_COLOR[A]))"

=item Blend a premultiplied source over a destination with premultiplied alpha:

    "RGBA = ADD(SRC_COLOR, DST_COLOR*(1-SRC_COLOR[A]))"

=back

The default blend string is:

    "RGBA = ADD (SRC_COLOR, DST_COLOR*(1-SRC_COLOR[A]))"

That gives normal alpha-blending when the calculated color for the material
is in premultiplied form.
=cut
gboolean cogl_material_set_blend (CoglHandle material, const gchar *blend_string);
    PREINIT:
        GError *error = NULL;
    CODE:
        RETVAL = cogl_material_set_blend (material, blend_string, &error);
        if (error)
                gperl_croak_gerror (NULL, error);
    OUTPUT:
        RETVAL

=for apidoc
=for arg color (CoglColor)
When blending is setup to reference a CONSTANT blend factor then
blending will depend on the constant set with this function.
=cut
void cogl_material_set_blend_constant (CoglHandle material, SV *color);
    PREINIT:
        CoglColor c;
    CODE:
        cogl_perl_color_from_sv (color, &c);
        cogl_material_set_blend_constant (material, &c);

=for apidoc
In addition to the standard OpenGL lighting model a Cogl material may have
one or more layers comprised of textures that can be blended together in
order, with a number of different texture combine modes. This function
defines a new texture layer.

The index values of multiple layers do not have to be consecutive; it is
only their relative order that is important.

B<Note>: In the future, we may define other types of material layers, such
as purely GLSL based layers.
=cut
void cogl_material_set_layer (CoglHandle material, gint layer_index, CoglHandle layer);

void cogl_material_remove_layer (CoglHandle material, gint layer_index);

=for apidoc __gerror__
If not already familiar; please refer to the L<BLEND STRINGS> section for an
overview of what blend strings are and their syntax.

These are all the functions available for texture combining:

=over

=item REPLACE(arg0) = arg0

=item MODULATE(arg0, arg1) = arg0 x arg1

=item ADD(arg0, arg1) = arg0 + arg1

=item ADD_SIGNED(arg0, arg1) = arg0 + arg1 - 0.5

=item INTERPOLATE(arg0, arg1, arg2) = arg0 x arg2 + arg1 x (1 - arg2)

=item SUBTRACT(arg0, arg1) = arg0 - arg1

=item DOT3_RGB(arg0, arg1) =

    4 x ((arg0[R] - 0.5) * (arg1[R] - 0.5) +
         (arg0[G] - 0.5) * (arg1[G] - 0.5) +
         (arg0[B] - 0.5) * (arg1[B] - 0.5))

=item DOT3_RGBA(arg0, arg1) =

    4 x ((arg0[R] - 0.5) * (arg1[R] - 0.5) +
         (arg0[G] - 0.5) * (arg1[G] - 0.5) +
         (arg0[B] - 0.5) * (arg1[B] - 0.5) +
         (arg0[A] - 0.5) * (arg1[A] - 0.5))

=back

The valid source names for texture combining are:

=over

=item TEXTURE

Use the color from the current texture layer

=item TEXTURE_0, TEXTURE_1, etc

Use the color from the specified texture layer

=item CONSTANT

Use the color from the constant given with
Clutter::Cogl::Material::set_layer_constant()

=item PRIMARY

Use the color of the material as set with
Clutter::Cogl::Material::set_color()

=item PREVIOUS

Either use the texture color from the previous layer, or if this is layer 0,
use the color of the material as set with
Clutter::Cogl::Material::set_color()

=back

B<Examples>:

This is effectively what the default blending is:

   RGBA = MODULATE (PREVIOUS, TEXTURE)

This could be used to cross-fade between two images, using the alpha
component of a constant as the interpolator. The constant color
is given by calling Clutter::Cogl::Material::set_layer_constant().

   RGBA = INTERPOLATE (PREVIOUS, TEXTURE, CONSTANT[A])

B<Note>: You can't give a multiplication factor for arguments as you can
with blending.
=cut
gboolean cogl_material_set_layer_combine (CoglHandle material, gint layer_index, const gchar *blend_string);
    PREINIT:
        GError *error = NULL;
    CODE:
        RETVAL = cogl_material_set_layer_combine (material, layer_index, blend_string, &error);
        if (error)
                gperl_croak_gerror (NULL, error);
    OUTPUT:
        RETVAL

=for apidoc
=for arg color (CoglColor)
When you are using the 'CONSTANT' color source in a layer combine
description then you can use this function to define its value.
=cut
void cogl_material_set_layer_combine_constant (CoglHandle material, gint layer_index, SV *color);
    PREINIT:
        CoglColor c;
    CODE:
        cogl_perl_color_from_sv (color, &c);
        cogl_material_set_layer_combine_constant (material, layer_index, &c);

=for apidoc
This function lets you set a matrix that can be used to e.g. translate
and rotate a single layer of a material used to fill your geometry.
=cut
void cogl_material_set_layer_matrix (CoglHandle material, gint layer_index, CoglMatrix *matrix);

=for apidoc
Changes the decimation and interpolation filters used when a texture is
drawn at other scales than 100%
=cut
void cogl_material_set_layer_filters (CoglHandle material, gint layer_index, CoglMaterialFilter min_filter, CoglMaterialFilter mag_filter);

=for apidoc
=for signature (layers) = $material->get_layers
This function lets you access a materials internal list of layers
for iteration. The returned list of materials is owned by Cogl and
should not be modified or freed.
=cut
void cogl_material_get_layers (CoglHandle material);
    PREINIT:
        const GList *layers, *l;
    PPCODE:
        layers = cogl_material_get_layers (material);
        if (layers == NULL)
                return;
        for (l = layers; l != NULL; l = l->next) {
                XPUSHs (sv_2mortal (newSVCoglHandle (l->data)));
        }

gint cogl_material_get_n_layers (CoglHandle material);

MODULE = Clutter::Cogl::Material        PACKAGE = Clutter::Cogl::MaterialLayer  PREFIX = cogl_material_layer_

BOOT:
        cogl_perl_set_isa ("Clutter::Cogl::MaterialLayer", "Clutter::Cogl::Handle");

=for enum Clutter::Cogl::MaterialLayerType
=cut

=for enum Clutter::Cogl::MaterialFilter
=cut

=for apidoc
Query the currently set downscaling filter for a cogl material layer.
=cut
CoglMaterialFilter cogl_material_layer_get_min_filter (CoglHandle layer);

=for apidoc
Query the currently set magnifying filter for a cogl material layer.
=cut
CoglMaterialFilter cogl_material_layer_get_mag_filter (CoglHandle layer);

=for apidoc
Retrieves the type of the layer

Currently there is only one type of layer defined, 'texture'; but considering
that we may add purely GLSL based layers in the future, you should write code
that checks the type first.
=cut
CoglMaterialLayerType cogl_material_layer_get_type (CoglHandle layer);

=for apidoc
This lets you extract a Clutter::Cogl::Texture handle for a specific layer.

B<Note>: In the future, we may support purely GLSL based layers which will
likely return I<undef> if you try to get the texture. Considering this, you
should call Clutter::Cogl::MaterialLayer::get_type() first, to check it is
of type 'texture'.
=cut
CoglHandle cogl_material_layer_get_texture (CoglHandle layer);

