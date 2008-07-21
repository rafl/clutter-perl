#include "clutterperl.h"

MODULE = Clutter::Gst::VideoTexture     PACKAGE = Clutter::Gst::VideoTexture    PREFIX = clutter_gst_video_texture_

ClutterActor_noinc *
clutter_gst_video_texture_new (class)
    C_ARGS:
        /* void */

GstElement *
clutter_gst_video_texture_get_playbin (ClutterGstVideoTexture *texture)
