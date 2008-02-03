#include "clutterperl.h"

static GPerlCallback *
clutterperl_alpha_func_create (SV *func, SV *data)
{
        GType param_types[1] = { CLUTTER_TYPE_ALPHA, };

        return gperl_callback_new (func, data, 1, param_types, G_TYPE_UINT);
}

static guint32
clutterperl_alpha_func (ClutterAlpha *alpha,
                        gpointer      data)
{
        GPerlCallback *callback = data;
        GValue return_value = { 0, };
        guint32 retval;

        g_value_init (&return_value, callback->return_type);

        gperl_callback_invoke (callback, &return_value, alpha);

        retval = g_value_get_uint (&return_value);
        g_value_unset (&return_value);

        return retval;
}

static GPerlCallback *
clutterperl_effect_complete_func_create (SV *func, SV *data)
{
        GType param_types[1] = { CLUTTER_TYPE_ACTOR, };

        return gperl_callback_new (func, data, 1, param_types, G_TYPE_NONE);
}

static void
clutterperl_effect_complete (ClutterActor *actor,
                             gpointer      data)
{
        GPerlCallback *callback = data;

        if (callback) {
                gperl_callback_invoke (callback, NULL, actor);
                gperl_callback_destroy (callback);
        }
}

#if 0
static ClutterKnot **
clutterperl_knots_list_from_sv (SV *knots, gint *n_knots)
{
        ClutterKnot **retval;
        gint size, i;
        AV *av;

        if (!(knots && SvOK (knots)))
                return NULL;
        
        if ((!SvRV (knots)) || (SvTYPE (SvRV (knots)) != SVt_PVAV))
                croak("Invalid list of Clutter::Knot objects");

        av = (AV *) SvRV (knots);
        size = av_len (av);

        retval = gperl_alloc_temp (size * sizeof (ClutterKnot));
        memset (retval, 0, size * sizeof (ClutterKnot));

        for (i = 0; i < size; i++) {
                ClutterKnot *knot;
                SV **value;

                value = av_fetch (av, i, 0);
                if (value && SvOK (*value))
                        retval[i] = SvClutterKnot (*value);
        }

        if (n_knots)
          *n_knots = size;
        
        return retval;
}
#endif

MODULE = Clutter::Effect        PACKAGE = Clutter::Effect

=for object Clutter::Effect
=cut

ClutterTimeline_noinc *
move (class, template, actor, x, y, func=NULL, data=NULL)
        ClutterEffectTemplate *template
        ClutterActor *actor
        gint x
        gint y
        SV *func
        SV *data
    PREINIT:
        GPerlCallback *cb = NULL;
    CODE:
        if (func)
                cb = clutterperl_effect_complete_func_create (func, data);
        RETVAL = clutter_effect_move (template, actor,
                                      x, y,
                                      clutterperl_effect_complete, cb);
    OUTPUT:
        RETVAL

ClutterTimeline_noinc *
depth (class, template, actor, end, func=NULL, data=NULL)
        ClutterEffectTemplate *template
        ClutterActor *actor
        gint end
        SV *func
        SV *data
    PREINIT:
        GPerlCallback *cb = NULL;
    CODE:
        if (func)
                cb = clutterperl_effect_complete_func_create (func, data);
        RETVAL = clutter_effect_depth (template, actor,
                                       end,
                                       clutterperl_effect_complete, cb);
    OUTPUT:
        RETVAL

ClutterTimeline_noinc *
fade (class, template, actor, end, func=NULL, data=NULL)
        ClutterEffectTemplate *template
        ClutterActor *actor
        guint8 end
        SV *func
        SV *data
    PREINIT:
        GPerlCallback *cb = NULL;
    CODE:
        if (func)
                cb = clutterperl_effect_complete_func_create (func, data);
        RETVAL = clutter_effect_fade (template, actor,
                                      end,
                                      clutterperl_effect_complete, cb);
    OUTPUT:
        RETVAL

ClutterTimeline_noinc *
scale (class, template, actor, x_end, y_end, func=NULL, data=NULL)
        ClutterEffectTemplate *template
        ClutterActor *actor
        gdouble x_end
        gdouble y_end
        SV *func
        SV *data
    PREINIT:
        GPerlCallback *cb = NULL;
    CODE:
        if (func)
                cb = clutterperl_effect_complete_func_create (func, data);
        RETVAL = clutter_effect_scale (template, actor,
                                       x_end, y_end,
                                       clutterperl_effect_complete, cb);
    OUTPUT:
        RETVAL

ClutterTimeline_noinc *
rotate (class, template, actor, axis, angle, x=0, y=0, z=0, direction=CLUTTER_ROTATE_CW, func=NULL, data=NULL)
        ClutterEffectTemplate *template
        ClutterActor *actor
        ClutterRotateAxis axis
        gdouble angle
        gint x
        gint y
        gint z
        ClutterRotateDirection direction
        SV *func
        SV *data
    PREINIT:
        GPerlCallback *cb = NULL;
    CODE:
        if (func)
                cb = clutterperl_effect_complete_func_create (func, data);
        RETVAL = clutter_effect_rotate (template, actor,
                                        axis, angle,
                                        x, y, z,
                                        direction,
                                        clutterperl_effect_complete, cb);
    OUTPUT:
        RETVAL


MODULE = Clutter::Effect PACKAGE = Clutter::EffectTemplate PREFIX = clutter_effect_template_

=for object Clutter::Effect Simple animation functions
=cut

=for position DESCRIPTION

=head1 DESCRIPTION

Clutter::Effect contains a set of functions for simple, one-off animations
involving a single actor. It is a convenience wrapper around the more complex
an powerful animations objects, L<Clutter::Behaviour>, L<Clutter::Alpha> and
L<Clutter::Timeline>.

Effects are created from a I<template>, which binds a L<Clutter::Timeline>
and an I<alpha function>, similarly to how L<Clutter::Alpha> works. You can
reuse a template for multiple animations.

After you have created a Clutter::EffectTemplate you can call one of the
simple class methods, providing the template object and the parameters for
the animation. You can optionally pass a function reference, which will be
invoked when the animation stops. Every Clutter::Effect class method returns
a copy of the L<Clutter::Timeline> used in the template, so you can control
the animation with it.

=cut

ClutterEffectTemplate *
clutter_effect_template_new (class, ClutterTimeline *timeline, SV *alpha_func)
    PREINIT:
        GPerlCallback *callback = NULL;
    CODE:
        callback = clutterperl_alpha_func_create (alpha_func, NULL);
        RETVAL = clutter_effect_template_new_full (timeline,
                                                   clutterperl_alpha_func,
                                                   callback,
                                                   (GDestroyNotify) gperl_callback_destroy);
    OUTPUT:
        RETVAL

ClutterEffectTemplate *
clutter_effect_template_new_for_duration (class, duration, alpha_func)
        guint duration
        SV *alpha_func
    PREINIT:
        GPerlCallback *callback = NULL;
        ClutterTimeline *timeline;
    CODE:
        callback = clutterperl_alpha_func_create (alpha_func, NULL);
        timeline = clutter_timeline_new_for_duration (duration);
        RETVAL = clutter_effect_template_new_full (timeline,
                                                   clutterperl_alpha_func,
                                                   callback,
                                                   (GDestroyNotify) gperl_callback_destroy);
        g_object_unref (timeline);
    OUTPUT:
        RETVAL

void
clutter_effect_template_set_timeline_clone (template_, clone)
        ClutterEffectTemplate *template_
        gboolean clone

gboolean
clutter_effect_template_get_timeline_clone (template_)
        ClutterEffectTemplate *template_

