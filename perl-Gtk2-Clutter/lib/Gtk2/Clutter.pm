#
# Copyright (c) 2009  Intel Corp (see the file AUTHORS)
#
# This library is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 2.1 of the License, or (at your option) any later version.
#
# This library is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Library General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public
# License along with this library; if not, write to the 
# Free Software Foundation, Inc., 59 Temple Place - Suite 330, 
# Boston, MA  02111-1307  USA.

package Gtk2::Clutter;

use 5.008;
use strict;
use warnings;

use Glib;
use Cairo;
use Pango;
use Gtk2;
use Clutter;

use Exporter;
require DynaLoader;

# the version scheme is:
#
#   CLUTTER_MAJOR
#   dot
#   CLUTTER_MINOR * 100 + CLUTTER_MICRO * 10 + bindings release
#
# where CLUTTER_MAJOR, CLUTTER_MINOR and CLUTTER_MICRO are the components
# of the minimum required Clutter version.
#
# this scheme allocates enough space for ten releases of the bindings
# for each point release of libclutter, which should be enough even in
# case of brown paper bag releases. -- ebassi
our $VERSION = '0.100';
$VERSION = eval $VERSION;

our @ISA = qw( DynaLoader Exporter );

sub dl_load_flags { $^O eq 'darwin' ? 0x00 : 0x01 }

sub import {
    my $class = shift;

    my $init = 0;

    foreach (@_) {
        if    (/^[-:]?init$/) { $init = 1;           }
        else                  { $class->VERSION($_); }
    }

    Gtk2::Clutter->init() if $init == 1;
}

Gtk2::Clutter->bootstrap($VERSION);

# Preloaded methods go here

1;

__END__

=pod

=head1 NAME

Gtk2::Clutter - Integration between Gtk2 and Clutter

=head1 SYNOPSIS

  # initialize Gtk2 and Clutter in the right order
  use Gtk2::Clutter qw( :init );

  my $w = Gtk2::Window->new('toplevel');
  $w->signal_connect(destroy => sub { Gtk2->main_quit });
  $w->set_default_size(640, 480);

  my $e = Gtk2::Clutter::Embed->new();
  $w->add($e);
  $e->show();

  # retrieve the Stage embedded
  my $s = $e->get_stage();

  my $r = Clutter::Rectangle->new(Clutter::Color->new(255, 0, 0, 255));
  $s->add($r);
  $r->set_size(200, 200);
  $r->set_anchor_point_from_gravity('center');
  $r->set_position($s->get_width() / 2, $s->get_height() / 2);

  # keep the Rectangle centered when the Stage changes size
  $s->signal_connect(allocation_changed => sub {
      my ($stage, $allocation, $flags)

      $r->set_position(
          $allocation->get_width() / 2,
          $allocation->get_height() / 2
      );
  });

  $w->show();

  Gtk2->main();

=head1 ABSTRACT

Perl bindings for the Clutter-GTK integration library for Clutter
and GTK+. This module allows you to combine Clutter scenegraph
elements inside GTK+ applications.

=head1 DESCRIPTION

B<Gtk2::Clutter> is a module that allows the Perl developer to write
GTK+ applications (using the Gtk2 module) and embed Clutter scenegraphs
inside the application user interface.

Clutter is a GObject based library for creating fast, visually rich
graphical user interfaces.  It is intended for creating single window
heavily stylised applications such as media box UI's, presentations or
kiosk style programs in preference to regular 'desktop' style
applications.

GTK+ is a GObject based toolkit for creating modern Graphical User
Interface application.

For more informations about Clutter, visit:

  http://www.clutter-project.org

For more informations about GTK+, visit:

  http://www.gtk.org

=head1 SEE ALSO

L<Gtk2::Clutter::index>, L<Gtk2>, L<Clutter>, L<Cairo>, L<Pango>, L<Glib>.

=head1 AUTHOR

Emmanuele Bassi E<lt>ebassi (AT) linux.intel.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2006, 2007, 2008  OpenedHand Ltd
Copyright (C) 2009 Intel Corporation

This module is free software; you can redistribute it and/or
modify it under the terms of:

=over 4

=item the GNU Lesser General Public License, version 2.1; or

=item the Artistic License, version 2.0.

=back

This module is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

You should have received a copy of the GNU Library General Public
License along with this module; if not, see L<http://www.gnu.org/licenses/>.

For the terms of The Artistic License, see L<perlartistic>.

=cut
