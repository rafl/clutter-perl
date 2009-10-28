#include "clutter-perl-private.h"

MODULE = Clutter::ParamSpec     PACKAGE = Clutter::ParamSpec    PREFIX = clutter_param_spec_

BOOT:
        gperl_register_param_spec (CLUTTER_TYPE_PARAM_COLOR, "Clutter::Param::Color");
        gperl_register_param_spec (CLUTTER_TYPE_PARAM_UNITS, "Clutter::Param::Units");

=for object Clutter::ParamSpec - ParamSpecs for installing new properties
=cut

GParamSpec *
clutter_param_spec_color (class, name, nick, blurb, default_value, flags)
        const gchar *name
        const gchar *nick
        const gchar *blurb
        ClutterColor *default_value
        GParamFlags flags
    C_ARGS:
        name, nick, blurb, default_value, flags

GParamSpec *
clutter_param_spec_units (class, name, nick, blurb, unit_type, minimum, maximum, default_value, flags)
        const gchar *name
        const gchar *nick
        const gchar *blurb
        ClutterUnitType unit_type
        gfloat minimum
        gfloat maximum
        gfloat default_value
        GParamFlags flags
    C_ARGS:
        name, nick, blurb, unit_type, minimum, maximum, default_value, flags

