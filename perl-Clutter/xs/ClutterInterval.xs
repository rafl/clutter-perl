#include "clutter-perl-private.h"

#define GET_METHOD(obj,name)    \
        HV *stash = gperl_object_stash_from_type (G_OBJECT_TYPE (obj)); \
        GV *slot  = gv_fetchmethod (stash, name);

#define METHOD_EXISTS   (slot && GvCV (slot))

#define PREP(obj)       \
        dSP;            \
        ENTER;          \
        SAVETMPS;       \
        PUSHMARK (SP);  \
        PUSHs (sv_2mortal (newSVGObject (G_OBJECT (obj))));

#define CALL_SCALAR                             \
        PUTBACK;                                \
        call_sv ((SV *) GvCV (slot), G_SCALAR); \
        SPAGAIN;

#define FINISH          \
        FREETMPS;       \
        LEAVE;

static gboolean
clutterperl_interval_validate (ClutterInterval *interval,
                               GParamSpec      *pspec)
{
        gboolean retval = FALSE;

        GET_METHOD (interval, "VALIDATE");

        if (METHOD_EXISTS) {
                PREP (interval);

                XPUSHs (sv_2mortal (newSVGParamSpec (pspec)));

                CALL_SCALAR;

                {
                        SV *sv_ret = POPs;
                        retval = Sv_TRUE (sv_ret);
                }

                FINISH;
        }

        return retval;
}

static gboolean
clutterperl_interval_compute_value (ClutterInterval *interval,
                                    gdouble          factor,
                                    GValue          *value)
{
        gboolean retval = FALSE;

        GET_METHOD (interval, "COMPUTE_VALUE");

        if (METHOD_EXISTS) {
                PREP (interval);

                XPUSHs (sv_2mortal (newSVnv (factor)));

                CALL_SCALAR;

                {
                        SV *sv_ret = POPs;

                        if (gperl_sv_is_defined (sv_ret)) {
                                gperl_value_from_sv (value, sv_ret);
                                retval = TRUE;
                        }
                }

                FINISH;
        }
        else {
                ClutterIntervalClass *klass;
                ClutterIntervalClass *parent;

                klass = CLUTTER_INTERVAL_GET_CLASS (klass);
                parent = g_type_class_peek_parent (klass);

                retval = parent->compute_value (interval, factor, value);
        }

        return retval;
}

static void
clutterperl_interval_class_init (ClutterIntervalClass *klass)
{
        klass->validate = clutterperl_interval_validate;
        klass->compute_value = clutterperl_interval_compute_value;
}

static void
clutterperl_interval_sink (GObject *object)
{
        g_object_ref_sink (object);
        g_object_unref (object);
}

MODULE = Clutter::Interval      PACKAGE = Clutter::Interval     PREFIX = clutter_interval_

BOOT:
        gperl_register_sink_func (CLUTTER_TYPE_INTERVAL, clutterperl_interval_sink);

=for object Clutter::Interval - An object holding an interval of two values
=cut

=for position DESCRIPTION

=head1 SYNOPSIS

    my $interval = Clutter::Interval->new('Glib::Int', 0, 11);
    my $value = $interval->compute_value(0.5);

=head1 DESCRIPTION

B<Clutter::Interval> is a simple object providing a strongly-typed storage
for a interval between two values.

B<Note>: Once a Clutter::Interval for a specific type has been instantiated
the Clutter::Interval I<value-type> property cannot be changed anymore.

Clutter::Interval is used by #ClutterAnimation to define the interval of
values that an implicit animation should tween over.

B<Note>: Currently, you cannot subclass a Clutter::Interval to override the
interval validation and the value computation; this requires additional
support inside the Glib Perl bindings that is not currently available.

=cut

=for apidoc
Creates a new Clutter::Interval, representing an interval of values with
the given I<type>
=cut
ClutterInterval *
clutter_interval_new (class, const gchar *type, SV *initial=NULL, SV *final=NULL)
    PREINIT:
        GValue final_value = { 0, };
        GType gtype = G_TYPE_INVALID;
    CODE:
        gtype = gperl_type_from_package (type);
        if (gtype == G_TYPE_INVALID) {
                croak ("Invalid type '%s' for the interval", type);
        }
        RETVAL = clutter_interval_new (gtype);
        if (initial) {
                GValue value = { 0, };
                g_value_init (&value, gtype);
                if (gperl_value_from_sv (&value, initial)) {
                        clutter_interval_set_initial_value (RETVAL, &value);
                        g_value_unset (&value);
                }
                else {
                        croak ("Unable to convert scalar into a valid initial value");
                }
        }
        if (final) {
                GValue value = { 0, };
                g_value_init (&value, gtype);
                if (gperl_value_from_sv (&value, final)) {
                        clutter_interval_set_final_value (RETVAL, &value);
                        g_value_unset (&value);
                }
                else {
                        croak ("Unable to convert scalar into a valid final value");
                }
        }
    OUTPUT:
        RETVAL

=for apidoc
Gets the type of the values inside the I<interval>
=cut
const gchar *clutter_interval_get_value_type (ClutterInterval *interval);
    PREINIT:
        GType type = 0;
    CODE:
        type = clutter_interval_get_value_type (interval);
        RETVAL = gperl_package_from_type (type);
    OUTPUT:
        RETVAL

=for apidoc
Sets the I<initial> value of the I<interval>
=cut
void clutter_interval_set_initial_value (ClutterInterval *interval, SV *initial);
    PREINIT:
        GValue value = { 0, };
    CODE:
        g_value_init (&value, clutter_interval_get_value_type (interval));
        if (gperl_value_from_sv (&value, initial)) {
                clutter_interval_set_initial_value (interval, &value);
                g_value_unset (&value);
        }
        else {
                croak ("Unable to convert scalar into a valid initial value");
        }

=for apidoc
Gets the I<initial> value of the I<interval>
=cut
SV *clutter_interval_get_initial_value (ClutterInterval *interval);
    PREINIT:
        const GValue *value;
    CODE:
        value = clutter_interval_peek_initial_value (interval);
        RETVAL = gperl_sv_from_value (value);
    OUTPUT:
        RETVAL

=for apidoc
Sets the I<final> value of the I<interval>
=cut
void clutter_interval_set_final_value (ClutterInterval *interval, SV *final);
    PREINIT:
        GValue value = { 0, };
    CODE:
        g_value_init (&value, clutter_interval_get_value_type (interval));
        if (gperl_value_from_sv (&value, final)) {
                clutter_interval_set_final_value (interval, &value);
                g_value_unset (&value);
        }
        else {
                croak ("Unable to convert scalar into a valid final value");
        }

=for apidoc
Gets the final value of the I<interval>
=cut
SV *clutter_interval_get_final_value (ClutterInterval *interval);
    PREINIT:
        const GValue *value;
    CODE:
        value = clutter_interval_peek_final_value (interval);
        RETVAL = gperl_sv_from_value (value);
    OUTPUT:
        RETVAL

=for apidoc
Sets the I<initial> and I<final> values of the interval. The
values must be compatible with the type set when creating the I<interval>
itself
=cut
void clutter_interval_set_interval (ClutterInterval *interval, SV *initial, SV *final);
    PREINIT:
        GValue value = { 0, };
    CODE:
        g_value_init (&value, clutter_interval_get_value_type (interval));
        if (gperl_value_from_sv (&value, initial)) {
                clutter_interval_set_initial_value (interval, &value);
                g_value_unset (&value);
        }
        else {
                croak ("Unable to convert scalar into a valid initial value");
        }
        g_value_init (&value, clutter_interval_get_value_type (interval));
        if (gperl_value_from_sv (&value, final)) {
                clutter_interval_set_final_value (interval, &value);
                g_value_unset (&value);
        }
        else {
                croak ("Unable to convert scalar into a valid final value");
        }

=for apidoc
=for signature (initial, final) = $interval->get_interval ()
Gets the I<initial> and I<final> values of the I<interval>
=cut
void clutter_interval_get_interval (ClutterInterval *interval);
    PPCODE:
        EXTEND (SP, 2);
        PUSHs (sv_2mortal (gperl_sv_from_value (clutter_interval_peek_initial_value (interval))));
        PUSHs (sv_2mortal (gperl_sv_from_value (clutter_interval_peek_final_value (interval))));

gboolean clutter_interval_validate (ClutterInterval *interval, GParamSpec *pspec);

=for apidoc
=for signature value = $interval->compute_value ($factor)
Computes the value of the I<interval> given the I<factor>
=cut
SV *
clutter_interval_compute_value (ClutterInterval *interval, gdouble factor)
    PREINIT:
        GValue value = { 0, };
    CODE:
        g_value_init (&value, clutter_interval_get_value_type (interval));
        if (clutter_interval_compute_value (interval, factor, &value)) {
                RETVAL = gperl_sv_from_value (&value);
                g_value_unset (&value);
        }
        else {
                RETVAL = &PL_sv_undef;
        }
    OUTPUT:
        RETVAL

