#include "clutterperl.h"

MODULE = Clutter::Gst::Audio    PACKAGE = Clutter::Gst::Audio   PREFIX = clutter_gst_audio_


ClutterGstAudio_noinc *
clutter_gst_audio_new (class)
    C_ARGS:
        /* void */

GstElement *
clutter_gst_audio_get_playbin (ClutterGstAudio *audio)
