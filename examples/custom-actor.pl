package Clutter::Ex::Triangle;

use warnings;
use strict;

use Glib qw( :constants );
use OpenGL;
use Clutter;

=pod

=head1 NAME

Clutter::Ex::Triangle - Basic triangular actor

=head1 SYNOPSIS

  use Clutter::Ex::Triangle;

  my $triangle = Clutter::Ex::Triangle->new();
  my $color = Clutter::Color->parse('DarkBlue');
  $triangle->set_color($color);

  my $triangle = Clutter::Ex::Triangle->new_with_color($color);

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
        Glib::ParamSpec->boxed(
            'color',
            'Color',
            'Color of the triangle',
            'Clutter::Color',
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

    my $opacity = $self->get_opacity();

    glColor4ub($pick_color->red(),
               $pick_color->green(),
               $pick_color->blue(),
               $opacity);

    glEnable(GL_BLEND);

    glBegin(GL_POLYGON);
    glVertex2i($self->get_width() / 2, 0);
    glVertex2i($self->get_width(), $self->get_height());
    glVertex2i(0, $self->get_height());
    glEnd();
}

sub PAINT {
    my ($self) = @_;

    my $opacity = $self->get_opacity();

    glColor4ub($self->{color}->red(),
               $self->{color}->green(),
               $self->{color}->blue(),
               $opacity);

    glEnable(GL_BLEND);

    glBegin(GL_POLYGON);
    glVertex2i($self->get_width() / 2, 0);
    glVertex2i($self->get_width(), $self->get_height());
    glVertex2i(0, $self->get_height());
    glEnd();
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

Creates a new C< Clutter::Ex::Triangle > actor.

=item B<< actor = Clutter::Ex::Triangle->new_with_color($color) >>

  * $color (L<Clutter::Color>)

Creates a new C< Clutter::Ex::Triangle > with the given I<color>.

=cut

sub new_with_color {
    my ($class, $color) = @_;

    return Glib::Object->new('Clutter::Ex::Triangle', color => $color);
}

=pod

=item B<< $triangle->set_color($color) >>

  * $color (L<Clutter::Color>)

=cut

sub set_color {
    my ($self, $color) = @_;

    $self->{color} = $color;
    $self->set_opacity($color->alpha());

    $self->notify('color');
}

=pod

=item B<< color = $triangle->get_color >>

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

=item 'color' (Clutter::Color : readable / writable / private)

Color of the triangle

=back

=head1 SEE ALSO

Clutter, Glib::Object, Glib::InitiallyUnowned, Clutter::Actor

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

my $stage = Clutter::Stage->get_default();
$stage->set_size(640, 480);
$stage->set_color(Clutter::Color->parse('Black'));

my $triangle = Clutter::Ex::Triangle->new();
$triangle->set_color(Clutter::Color->parse('Red'));
$triangle->set_opacity(255);
$triangle->set_reactive(TRUE);
$stage->add($triangle);
$triangle->set_position((640 - 100) / 2, (480 - 100) / 2);
$triangle->set_size(100, 100);
$triangle->signal_connect(clicked => sub { Clutter->main_quit(); });

$triangle->show();

$stage->show();

Clutter->main();

0;
