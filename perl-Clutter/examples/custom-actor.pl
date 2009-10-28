package Clutter::Ex::Triangle;

use warnings;
use strict;

use Data::Dumper;

use Glib qw( :constants );
use Clutter;

=pod

=head1 NAME

Clutter::Ex::Triangle - Basic triangular actor

=head1 SYNOPSIS

  use Clutter qw( :init );
  use Clutter::Ex::Triangle;

  my $triangle = Clutter::Ex::Triangle->new();
  my $color = Clutter::Color->from_string('DarkBlue');
  $triangle->set_color($color);

  # - or -

  my $triangle = Clutter::Ex::Triangle->new_with_color($color);

  my $stage = Clutter::Stage->get_default();
  $stage->add($triangle);
  $triangle->set_reactive(1);
  $triangle->signal_connect(clicked => sub { Clutter->main_quit() });
  $triangle->show();

  Clutter->main();

=head1 DESCRIPTION

This page describes the API of C< Clutter::Ex::Triangle >, a simple actor
class providing a triangular shape.

=head1 HIERARCHY

  Glib::Object
  +----Glib::InitiallyUnowned
       +----Clutter::Actor
            +----Clutter::Ex::Triangle

=cut

use Glib::Object::Subclass
    'Clutter::Actor',
    signals => {
        clicked => {
            class_closure => undef,
            flags         => [ qw( run-last ) ],
            return_type   => undef,
            param_types   => [ ],
        },
        button_press_event   => \&on_button_press,
        button_release_event => \&on_button_release,
        leave_event          => \&on_leave,
    },
    properties => [
        Clutter::ParamSpec->color(
            'color',
            'Color',
            'Color of the triangle',
            Clutter::Color->new(255, 255, 255, 255),
            [ qw( readable writable ) ],
        ),
    ];

sub on_button_press {
    my ($self, $event) = @_;

    if ($event->button == 1) {
        $self->{is_pressed} = TRUE;

        Clutter->grab_pointer($self);

        return TRUE;
    }

    return FALSE;
}

sub on_button_release {
    my ($self, $event) = @_;

    if ($event->button == 1 and $self->{is_pressed}) {
        $self->{is_pressed} = FALSE;

        Clutter->ungrab_pointer();

        $self->signal_emit('clicked');

        return TRUE;
    }

    return FALSE;
}

sub on_leave {
    my ($self, $event) = @_;

    if ($self->{is_pressed}) {
        $self->{is_pressed} = FALSE;

        Clutter->ungrab_pointer();

        return TRUE;
    }

    return FALSE;
}

sub PICK {
    my ($self, $pick_color) = @_;

    # we override PICK because the actor has a non-rectangular shape

    # if pick should not paint, then skip it
    return unless $self->should_pick_paint();

    my $box = $self->get_allocation_box();

    Clutter::Cogl::Path->move_to($box->width() / 2, 0);
    Clutter::Cogl::Path->line_to($box->width(), $box->height());
    Clutter::Cogl::Path->line_to(0, $box->height());
    Clutter::Cogl::Path->line_to($box->width() / 2, 0);

    Clutter::Cogl->set_source_color([
        $pick_color->red(),
        $pick_color->green(),
        $pick_color->blue(),
        $pick_color->alpha(),
    ]);
    Clutter::Cogl::Path->fill();
}

sub PAINT {
    my ($self) = @_;

    my $box = $self->get_allocation_box();

    Clutter::Cogl::Path->move_to($box->width() / 2, 0);
    Clutter::Cogl::Path->line_to($box->width(), $box->height());
    Clutter::Cogl::Path->line_to(0, $box->height());
    Clutter::Cogl::Path->line_to($box->width() / 2, 0);

    my $color = $self->{color};

    # compute the real alpha of the actor, taking into
    # account the opacity set by the developer and the
    # composited opacity of the scenegraph
    my $real_alpha = $self->get_paint_opacity()
                   * $color->alpha()
                   / 255;

    $color->alpha($real_alpha);

    Clutter::Cogl->set_source_color([
        $color->red(),
        $color->green(),
        $color->blue(),
        $real_alpha,
    ]);
    Clutter::Cogl::Path->fill();
}

sub SET_PROPERTY {
    my ($self, $pspec, $value) = @_;

    $self->set_color($value) if ($pspec->name() eq 'color');
}

sub GET_PROPERTY {
    my ($self, $pspec) = @_;

    return $self->get_color() if ($pspec->name() eq 'color');
}

sub INIT_INSTANCE {
    my ($self) = @_;

    # default: white
    $self->{color} = Clutter::Color->new(255, 255, 255, 255);
}

=pod

=head1 METHODS

=over

=item B<< actor = Clutter::Ex::Triangle->new >>

Creates a new Clutter::Ex::Triangle actor.

=item B<< actor = Clutter::Ex::Triangle->new_with_color($color) >>

  * $color (Clutter::Color)

Creates a new Clutter::Ex::Triangle with the given I<color>.

=cut

sub new_with_color {
    my ($class, $color) = @_;

    return Glib::Object->new('Clutter::Ex::Triangle', color => $color);
}

=pod

=item B<< $triangle->set_color($color) >>

  * $color (Clutter::Color)

Sets the color of the triangle to I<color>.

=cut

sub set_color {
    my ($self, $color) = @_;

    $self->{color} = $color;
    $self->notify('color');

    $self->queue_redraw() if $self->visible();
}

=pod

=item B<< color = $triangle->get_color >>

Retrieves the L<Clutter::Color> used by the triangle.

=cut

sub get_color {
    my ($self) = @_;

    return $self->{color};
}

=pod

=back

=head1 SIGNALS

=over

=item B<clicked ($triangle)>

  * $triangle (Clutter::Ex::Triangle)

The C<clicked> signal is emitted each time the mouse is pressed and then
released within the actor's area.

=back

=head1 PROPERTIES

=over

=item 'color' (Clutter::Color : readable / writable)

Color of the triangle

=back

=head1 SEE ALSO

L<Clutter>, L<Glib::Object>, L<Glib::InitiallyUnowned>, L<Clutter::Actor>

=head1 COPYRIGHT

Copyright (C) 2007  OpenedHand Ltd.

This module is free software; you can redistribute it and/or modify it
under the terms of the GNU Lesser General Public License version 2.1, or
under the terms of the Artistic License. See Clutter for the full copyright
notice.

=cut

# aaw, demo it already!

package main;

use Glib qw( :constants );
use Clutter qw( :init );

my $stage = Clutter::Stage->new();
$stage->set_size(640, 480);
$stage->set_color(Clutter::Color->from_string('Black'));
$stage->signal_connect(destroy => sub { Clutter->main_quit() });

my $triangle = Clutter::Ex::Triangle->new();
$triangle->set_color(Clutter::Color->from_string('DarkBlue'));
$triangle->set_reactive(TRUE);
$triangle->set_size(200, 200);
$triangle->set_anchor_point(100, 100);
$triangle->set_position(320, 240);
$stage->add($triangle);
$triangle->signal_connect(clicked => sub {
    print "You clicked me!\n";
    Clutter->main_quit();
});

my $label = Clutter::Text->new();
$label->set_font_name('Sans 36px');
$label->set_text('Click me!');
$label->set_color(Clutter::Color->from_string('Red'));
$label->set_position(
    (640 - $label->get_width()) / 2,
     $triangle->get_y() + $triangle->get_height(),
);
$stage->add($label);

$stage->show();

Clutter->main();

0;
