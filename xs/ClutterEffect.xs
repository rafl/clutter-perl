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


MODULE = Clutter::Effect    PACKAGE = Clutter::EffectTemplate   PREFIX = clutter_effect_template_

ClutterEffectTemplate *
clutter_effect_template_new (ClutterTimeline *timeline, SV *alpha_func)
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

