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
use Cairo;
use Pango;

use Exporter;
require DynaLoader;

# the version scheme is:
#   CLUTTER_MAJOR
#   dot
#   CLUTTER_MINOR * 100 + CLUTTER_MICRO * 10 + bindings release
#
# this scheme allocates enough space for ten releases
# of the bindings for each point release of libclutter,
# which should be enough even in case of brown paper
# bag releases. -- ebassi
our $VERSION = '1.000';

our @ISA = qw( DynaLoader Exporter );

sub dl_load_flags { $^O eq 'darwin' ? 0x00 : 0x01 }

use constant {
    EVENT_STOP      => 1,
    EVENT_PROPAGATE => !1,
};

sub import {
    my $class = shift;

    # Clutter::Threads->init() must be called before calling Clutter->init(),
    # but we don't want to force the order of the options passed, so we store
    # the choices and call everything in the correct order later.
    my $init         = 0;
    my $threads_init = 0;

    foreach (@_) {
        if    (/^[-:]?init$/)         { $init = 1;           }
        elsif (/^[-:]?threads-init$/) { $threads_init = 1;   }
        else                          { $class->VERSION($_); }
    }

    Clutter::Threads->init() if $threads_init == 1;
    Clutter->init()          if $init         == 1;
}

Clutter->bootstrap($VERSION);

# Preloaded methods go here

package Clutter::Color;

use overload
    '==' => \&Clutter::Color::equal,
    '+' => \&Clutter::Color::add,
    '-' => \&Clutter::Color::subtract,
    fallback => 1;

package Clutter::Knot;

use overload
    '==' => \&Clutter::Knot::equal,
    fallback => 1;

package Clutter::Vertex;

use overload
    '==' => \&Clutter::Vertex::equal,
    fallback => 1;

package Clutter::Cogl::Matrix;

use overload
    '*' => \&Clutter::Cogl::Matrix::multiply,
    fallback => 1;

package Clutter::Script;

sub _do_connect {
  my ($object,
      $signal_name,
      $user_data,
      $connect_object,
      $flags,
      $handler) = @_;

  my $func = ($flags & 'after') ? 'signal_connect_after' : 'signal_connect';

  # we get connect_object when we're supposed to call
  # signal_connect_object, which ensures that the data (an object)
  # lives as long as the signal is connected.  the bindings take
  # care of that for us in all cases, so we only have signal_connect.
  # if we get a connect_object, just use that instead of user_data.
  $object->$func($signal_name => $handler,
                 $connect_object ? $connect_object : $user_data);
}

sub connect_signals {
  my $script    = shift;
  my $user_data = shift;

  # $script->connect_signals ($user_data)
  # $script->connect_signals ($user_data, $package)
  if ($#_ <= 0) {
    my $package = shift;

    $package = caller unless defined $package;

    $script->connect_signals_full(sub {
      my ($script,
          $object,
          $signal_name,
          $handler_name,
          $connect_object,
          $flags) = @_;

      no strict qw/refs/;

      my $handler = $handler_name;
      if (ref $package) {
        $handler = sub { $package->$handler_name(@_) };
      } else {
        if ($package && $handler !~ /::/) {
          $handler = $package.'::'.$handler_name;
        }
      }

      _do_connect ($object, $signal_name, $user_data, $connect_object,
                   $flags, $handler);
    });
  }

  # $script->connect_signals ($user_data, %handlers)
  else {
    my %handlers = @_;

    $script->connect_signals_full(sub {
      my ($script,
          $object,
          $signal_name,
          $handler_name,
          $connect_object,
          $flags) = @_;

      return unless exists $handlers{$handler_name};

      _do_connect ($object, $signal_name, $user_data, $connect_object,
                   $flags, $handlers{$handler_name});
    });
  }
}

package Clutter::Container::ForeachFunc;

use overload
    '&{}' => sub { \&Clutter::Container::ForeachFunc::invoke },
    fallback => 1;

package Clutter;

1;

__END__

=pod

=head1 NAME

Clutter - Simple GL-based canvas library

=head1 SYNOPSIS

  use Clutter qw( :init );
  
  # create the main stage
  my $stage = Clutter::Stage->get_default();
  $stage->set_color(Clutter::Color->parse('DarkSlateGray'));
  $stage->signal_connect('key-press-event' => sub { Clutter->main_quit() });
  $stage->set_size(800, 600);
  
  # add an actor and place it right in the middle
  my $label = Clutter::Text->new("Sans 30", "Hello, Clutter!");
  $label->set_color(Clutter::Color->new(0xff, 0xcc, 0xcc, 0xdd));
  $label->set_anchor_point($label->get_width() / 2,
                           $label->get_height() / 2);
  $label->set_position($stage->get_width() / 2, $stage->get_height() / 2);
  $stage->add($label);

  $stage->show_all();
  
  Clutter->main();
  
  0;

=head1 DESCRIPTION

Clutter is a GObject based library for creating fast, visually rich
graphical user interfaces.  It is intended for creating single window
heavily stylised applications such as media box UI's, presentations or
kiosk style programs in preference to regular 'desktop' style
applications.

Clutter's underlying graphics rendering is OpenGL (version 1.2+)
based.  The clutter API is intended to be easy to use, attempting to
hide many of the GL complexities.  It targets mainly 2D based graphics
and is definetly not intended to be a general interface for all OpenGL
functionality.

As well as OpenGL Clutter depends on and uses Glib, Glib::Object,
Pango and Cairo.

For more informations about Clutter, visit:

  http://www.clutter-project.org

You can also subscribe to the Clutter mailing list by sending a
blank message E<lt>clutter+subscribe AT o-hand.comE<gt>, then follow
the instructions in resulting reply.

=head1 SEE ALSO

L<Clutter::index>, L<Cairo>, L<Pango>, L<Glib>.

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
