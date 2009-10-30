#include "clutter-perl-private.h"

static GPerlBoxedWrapperClass clutter_units_wrapper_class;

static SV *
clutter_units_wrap (GType        gtype,
                    const gchar *package,
                    gpointer     boxed,
                    gboolean     own)
{
        ClutterUnits *units = boxed;
        ClutterUnitType units_type;
        gfloat units_value;
        HV *hv;

        if (!units)
                return &PL_sv_undef;

        units_type = clutter_units_get_unit_type (units);
        units_value = clutter_units_get_unit_value (units);

        hv = newHV ();
        (void) hv_store (hv, "type", 4, newSVClutterUnitType (units_type), 0);
        (void) hv_store (hv, "value", 5, newSVnv (units_value), 0);

        if (own)
                clutter_units_free (units);

        return newRV_noinc ((SV *) hv);
}

static gpointer
clutter_units_unwrap (GType        gtype,
                      const gchar *package,
                      SV          *sv)
{
        ClutterUnits *units;
        gint enum_val = 0;
        HV *hv;
        SV **svp;

        if (!sv || !SvOK (sv) || !SvRV (sv) || SvTYPE (SvRV (sv)) != SVt_PVHV)
                return NULL;

        units = gperl_alloc_temp (sizeof (ClutterUnits));

        hv = (HV *) SvRV (sv);

        svp = hv_fetch (hv, "type", 4, FALSE);
        if (!gperl_sv_is_defined (*svp))
                croak ("Undefined unit type");

        if (looks_like_number (*svp)) {
                enum_val = SvIV (*svp);
        }
        else {
                gboolean res;

                res = gperl_try_convert_enum (CLUTTER_TYPE_UNIT_TYPE, *svp, &enum_val);
                if (!res) {
                        croak ("Unable to convert unit type");
                }
        }

        units->unit_type = (ClutterUnitType) enum_val;

        svp = hv_fetch (hv, "value", 5, FALSE);
        if (!gperl_sv_is_defined (*svp))
                croak ("Undefined unit value");

        units->value = SvNV (*svp);

        return units;
}

MODULE = Clutter::Units PACKAGE = Clutter::Units        PREFIX = clutter_units_

BOOT:
        PERL_UNUSED_VAR (file);
        clutter_units_wrapper_class = * gperl_default_boxed_wrapper_class ();
        clutter_units_wrapper_class.wrap = clutter_units_wrap;
        clutter_units_wrapper_class.unwrap = clutter_units_unwrap;
        gperl_register_boxed (CLUTTER_TYPE_UNITS, "Clutter::Units",
                              &clutter_units_wrapper_class);

=for object Clutter::Units - A logical distance unit
=cut

=for position DESCRIPTION

=head1 SYNOPSIS

    $units = { type => 'mm', value => 12.0 };
    $pixels = $units->to_pixels();

    $units = Clutter::Units->from_em(3, "Sans 16px");
    print $units->{value};      # "3"
    print $units->to_string();  # "3 em"

    $units = Clutter::Units->from_string("12 pt");
    print $units->{type};       # "pt"
    print $units->to_pixels();

=head1 DESCRIPTION

B<Clutter::Units> is a data structure holding a logical distance value
along with its type, expressed as a value of the Clutter::UnitType
enumeration.

It is possible to use Clutter::Units to store a position or a size in
units different than pixels, and convert them whenever needed (for
instance inside the Clutter::Actor::allocate() virtual function, or
inside the Clutter::Actor::get_preferred_width() and
Clutter::Actor::get_preferred_height() virtual functions).

A Clutter::Units is represented by a hash reference with two keys,
I<type>, holding the unit type; and I<value>, holding the value for
the specified type.

The I<type> key can contain one of the following:

=over

=item B<px>     : pixels

=item B<em>     : em

=item B<pt>     : typographic points

=item B<mm>     : millimeters

=item B<cm>     : centimeters

=back

The I<value> key must contain a double.

=cut

=for enum Clutter::UnitType
=cut

ClutterUnits_copy* clutter_units_from_pixels (class, gint pixels);
    PREINIT:
        ClutterUnits units;
    CODE:
        clutter_units_from_pixels (&units, pixels);
        RETVAL = &units;
    OUTPUT:
        RETVAL

ClutterUnits_copy* clutter_units_from_em (class, gfloat em, const gchar *font_name=NULL);
    PREINIT:
        ClutterUnits units;
    CODE:
        if (font_name != NULL) {
                clutter_units_from_em_for_font (&units, font_name, em);
        }
        else {
                clutter_units_from_em (&units, em);
        }
        RETVAL = &units;
    OUTPUT:
        RETVAL

ClutterUnits_copy* clutter_units_from_mm (class, gfloat mm);
    PREINIT:
        ClutterUnits units;
    CODE:
        clutter_units_from_mm (&units, mm);
        RETVAL = &units;
    OUTPUT:
        RETVAL

ClutterUnits_copy* clutter_units_from_pt (class, gfloat pt);
    PREINIT:
        ClutterUnits units;
    CODE:
        clutter_units_from_pt (&units, pt);
        RETVAL = &units;
    OUTPUT:
        RETVAL

#if CLUTTER_CHECK_VERSION(1, 1, 2)

ClutterUnits_copy* clutter_units_from_cm (class, gfloat cm);
    PREINIT:
        ClutterUnits units;
    CODE:
        clutter_units_from_cm (&units, cm);
        RETVAL = &units;
    OUTPUT:
        RETVAL

#endif /* CLUTTER_CHECK_VERSION(1, 1, 2) */

ClutterUnits_copy* clutter_units_from_string (class, const gchar *string);
    PREINIT:
        ClutterUnits units;
    CODE:
        clutter_units_from_string (&units, string);
        RETVAL = &units;
    OUTPUT:
        RETVAL

gfloat clutter_units_to_pixels (ClutterUnits *units);

gchar_own* clutter_units_to_string (ClutterUnits *units);
