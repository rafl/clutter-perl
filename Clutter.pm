#
# Copyright (c) 2006  OpenedHand Ltd. (see the file AUTHORS)
#
# This library is free software; you can redistribute it and/or
# modify it under the terms of the GNU Library General Public
# License as published by the Free Software Foundation; either
# version 2 of the License, or (at your option) any later version.
#
# This library is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Library General Public License for more details.
#
# You should have received a copy of the GNU Library General Public
# License along with this library; if not, write to the 
# Free Software Foundation, Inc., 59 Temple Place - Suite 330, 
# Boston, MA  02111-1307  USA.

package Clutter;

use 5.008;
use strict;
use warnings;

use Glib;

require DynaLoader;

our @ISA = qw(DynaLoader);

# the version scheme is:
#   CLUTTER_MAJOR
#   dot
#   CLUTTER_MINOR * 100 + CLUTTER_MICRO
#   bindings release
# this scheme allocates enough space for ten releases
# of the bindings for each point release of libclutter,
# which should be enough even in case of brown paper
# bag releases. -- ebassi
our $VERSION = '0.200';

sub import {
    my $class = shift;

    my $init = 0;

    foreach (@_) {
	    if (/^-?init$/) {
            $init = 1;
        }
        else {
            $class->VERSION($_);
        }
    }

    Clutter->init() if $init;
}

sub dl_load_flags { $^O eq 'darwin' ? 0x00 : 0x01 }

require XSLoader;
XSLoader::load('Clutter', $VERSION);

# Preloaded methods go here

package Clutter::Alpha;

sub ramp
{
    my $alpha = shift;
    my $timeline = $alpha->get_timeline();

    my $current_frame_num = $timeline->get_current_frame();
    my $n_frames = $timeline->get_n_frames();

    if ($current_frame_num > ($n_frames / 2)) {
        return ($n_frames - $current_frame_num)
               * Clutter::Alpha->MAX_ALPHA
               / ($n_frames / 2);
    } else {
        return $current_frame_num
               * Clutter::Alpha->MAX_ALPHA
               / ($n_frames / 2);
    }
}

sub ramp_dec
{
    my $alpha = shift;
    my $timeline = $alpha->get_timeline();

    my $current_frame_num = $timeline->get_current_frame();
    my $n_frames = $timeline->get_n_frames();

    return ($n_frames - $current_frame_num)
           * Clutter::Alpha->MAX_ALPHA
           / $n_frames;
}

sub ramp_inc
{
    my $alpha = shift;
    my $timeline = $alpha->get_timeline();

    my $current_frame_num = $timeline->get_current_frame();
    my $n_frames = $timeline->get_n_frames();

    return $current_frame_num
           * Clutter::Alpha->MAX_ALPHA
           / $n_frames;
}

sub sine
{
    use Math::Trig ':pi';

    my $alpha = shift;
    my $timeline = $alpha->get_timeline();

    my $current_frame_num = $timeline->get_current_frame();
    my $n_frames = $timeline->get_n_frames();

    my $x = ($current_frame_num * pi2) / $n_frames;
    my $sine = (sin ($x - (pip2)) + 1) * .5;

    return ($sine * Clutter::Alpha->MAX_ALPHA);
}

package Clutter;

1;

__END__

=pod

=head1 NAME

Clutter - Simple GL-based canvas library

=head1 SYNOPSIS

  use Clutter '-init';

  my $stage = Clutter::Stage->get_default;
  $stage->set_size(800, 600);

  my $label = Clutter::Label->new("Sans 30", "Clutter");
  $label->set_position($stage->get_width / 2,
                       $stage->get_height / 2);
  $stage->add($label);

  $stage->show_all;

  Clutter->main;

  0;

=head1 DESCRIPTION

Clutter is a GObject based library for creating fast, visually rich
graphical user interfaces.  It is intended for creating single window
heavily stylised applications such as media box ui's, presentations or
kiosk style programs in preference to regular 'desktop' style
applications.

Clutter's underlying graphics rendering is OpenGL (version 1.2+)
based.  The clutter API is intended to be easy to use, attempting to
hide many of the GL complexities.  It targets mainly 2D based graphics
and is definetly not intended to be a general interface for all OpenGL
functionality.

As well as OpenGL Clutter depends on and uses Glib, Glib::Object,
Gtk2::Pango, Gtk2::Gdk::Pixbuf and GStreamer.

=head1 DIFFERENCES FROM C API

FIXME

=head1 AUTHOR

Emmanuele Bassi E<lt>ebassi (AT) openedhand (DOT) comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2006  OpenedHand Ltd.

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Library General Public
License as published by the Free Software Foundation; either
version 2 of the License, or (at your option) any later version.

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Library General Public License for more details.

You should have received a copy of the GNU Library General Public
License along with this library; if not, write to the 
Free Software Foundation, Inc., 59 Temple Place - Suite 330, 
Boston, MA  02111-1307  USA.

=cut
