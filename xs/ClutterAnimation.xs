#include "clutterperl-private.h"

MODULE = Clutter::Animation     PACKAGE = Clutter::Animation    PREFIX = clutter_animation_

=for enum Clutter::AnimationMode
=cut

ClutterAnimation *clutter_animation_new (class);
    C_ARGS:
        /* void */

void clutter_animation_set_object (ClutterAnimation *animation, GObject *object);

GObject *clutter_animation_get_object (ClutterAnimation *animation);

void clutter_animation_set_mode (ClutterAnimation *animation, SV *mode);
    CODE:
        clutter_animation_set_mode (animation, clutter_perl_animation_mode_from_sv (mode));

SV *clutter_animation_get_mode (ClutterAnimation *animation);
    CODE:
        clutter_perl_animation_mode_to_sv (clutter_animation_get_mode (animation));

void clutter_animation_set_duration (ClutterAnimation *animation, gint msecs);

guint clutter_animation_get_duration (ClutterAnimation *animation);

void clutter_animation_set_loop (ClutterAnimation *animation, gboolean loop);

gboolean clutter_animation_get_loop (ClutterAnimation *animation);

void clutter_animation_set_timeline (ClutterAnimation *animation, ClutterTimeline *timeline);

ClutterTimeline *clutter_animation_get_timeline (ClutterAnimation *animation);

void clutter_animation_set_alpha (ClutterAnimation *animation, ClutterAlpha *alpha);

ClutterAlpha *clutter_animation_get_alpha (ClutterAnimation *animation);

ClutterAnimation *clutter_animation_bind (animation, property_name, final)
        ClutterAnimation *animation
        const gchar *property_name
        SV *final
    PREINIT:
        GValue value = { 0, };
        GObject *obj;
        GObjectClass *klass;
        GParamSpec *pspec;
    CODE:
        obj = clutter_animation_get_object (animation);
        if (obj == NULL) {
                croak ("No object to animate has been set");
        }
        klass = G_OBJECT_GET_CLASS (obj);
        pspec = g_object_class_find_property (klass, property_name);
        if (pspec == NULL) {
                croak ("No property named '%s' for object of type '%s'",
                       property_name,
                       G_OBJECT_TYPE_NAME (obj));
        }
        g_value_init (&value, G_PARAM_SPEC_VALUE_TYPE (pspec));
        if (!gperl_value_from_sv (&value, final)) {
                croak ("Unable to convert value");
        }
        RETVAL = clutter_animation_bind (animation, property_name, &value);
        g_value_unset (&value);
    OUTPUT:
        RETVAL


ClutterAnimation *clutter_animation_bind_interval (animation, property_name, interval)
        ClutterAnimation *animation
        const gchar *property_name
        ClutterInterval *interval

gboolean clutter_animation_has_property (ClutterAnimation *animation, const gchar *property_name);

void clutter_animation_update_interval (animation, property_name, interval)
        ClutterAnimation *animation
        const gchar *property_name
        ClutterInterval *interval

void clutter_animation_unbind_property (ClutterAnimation *animation, const gchar *property_name);

ClutterInterval_noinc *clutter_animation_get_interval (ClutterAnimation *animation, const gchar *property_name);

void clutter_animation_completed (ClutterAnimation *animation);

