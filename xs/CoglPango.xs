#include "clutter-perl-private.h"

MODULE = Clutter::Cogl::Pango PACKAGE = Clutter::Cogl::Pango::FontMap PREFIX = cogl_pango_font_map_

PangoFontMap_noinc *cogl_pango_font_map_new (class);
    C_ARGS:
        /* void */

void cogl_pango_font_map_set_use_mipmapping (CoglPangoFontMap *font_map, gboolean use_mipmapping);

gboolean cogl_pango_font_map_get_use_mipmapping (CoglPangoFontMap *font_map);

PangoRenderer *cogl_pango_font_map_get_renderer (CoglPangoFontMap *font_map);


MODULE = Clutter::Cogl::Pango PACKAGE = Clutter::Cogl::Pango PREFIX = cogl_pango_

void cogl_pango_render_layout_subpixel (class, layout, x, y, color, flags=0);
        PangoLayout *layout
        int x
        int y
        SV *color
        int flags
    PREINIT:
        CoglColor c;
    CODE:
        cogl_perl_color_from_sv (color, &c);
        cogl_pango_render_layout_subpixel (layout, x, y, &c, flags);

void cogl_pango_render_layout (class, layout, x, y, color, flags=0)
        PangoLayout *layout
        int x
        int y
        SV *color
        int flags
    PREINIT:
        CoglColor c;
    CODE:
        cogl_perl_color_from_sv (color, &c);
        cogl_pango_render_layout (layout, x, y, &c, flags);

void cogl_pango_render_layout_line (class, line, x, y, color)
        PangoLayoutLine *line
        int x
        int y
        SV *color
    PREINIT:
        CoglColor c;
    CODE:
        cogl_perl_color_from_sv (color, &c);
        cogl_pango_render_layout_line (line, x, y, &c);

void cogl_pango_ensure_glyph_cache_for_layout (class, PangoLayout *layout);
    C_ARGS:
        layout
