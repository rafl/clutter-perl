package Clutter::Ex::Behaviour::Rotate;

# behaviour.pl: Example showing the behaviours API in Clutter
# Copyright (C) 2007  OpenedHand, Ltd.
# Author: Emmanuele Bassi
#
# This is free software. Permission to redistribute and/or modify it under
# the same terms of Perl itself.

use strict;
use warnings;

use Glib;
use Clutter;

# we need to register these enums first hand, so that the
# object registering code can find them when defining the
# properties of the Clutter::Ex::Behaviour::Rotate.
sub BEGIN {
    Glib::Type->register_enum(
        'Clutter::Ex::RotateDirection',
        'clockwise',
        'anticlockwise',
    );

    Glib::Type->register_enum(
        'Clutter::Ex::RotateAxis',
        'x',
        'y',
        'z',
    );
}

use Glib::Object::Subclass
    'Clutter::Behaviour',
    signals => { },
    properties => [
        Glib::ParamSpec->double(
            'angle-start',
            'Angle Start',
            'Initial angle value',
            0.0, 359.0, 0.0,
            [ qw( readable writable ) ],
        ),
        Glib::ParamSpec->double(
            'angle-end',
            'Angle End',
            'Final angle value',
            0.0, 359.0, 359.0,
            [ qw( readable writable ) ],
        ),
        Glib::ParamSpec->enum(
            'direction',
            'Direction',
            'Direction of the rotation',
            'Clutter::Ex::RotateDirection',
            'clockwise',
            [ qw( readable writable ) ],
        ),
        Glib::ParamSpec->enum(
            'axis',
            'Axis',
            'Axis of the rotation',
            'Clutter::Ex::RotateAxis',
            'z',
            [ qw( readable writable ) ],
        ),
    ]
    ;

sub INIT_INSTANCE {
    my ($self) = @_;

    $self->{angle_start} =   0.0;
    $self->{angle_end}   = 359.0;
    $self->{direction}   = 'clockwise';
    $self->{axis}        = 'z-axis';
}

sub ALPHA_NOTIFY {
    my ($self, $alpha_value) = @_;

    my @actors = $self->get_actors();
    return unless scalar @actors;

    my $angle = $alpha_value
              * ($self->{angle_end} - $self->{angle_start})
              + $self->{angle_start};

    foreach my $actor (@actors) {
        $actor->set_rotation('z-axis', $angle,
                             $actor->get_x() - 20,
                             $actor->get_y() - 20,
                             0);
    }
}

package main;

use strict;
use warnings;

use Glib qw( :constants );
use Clutter qw( :init );

my $stage = Clutter::Stage->get_default();
$stage->set_color(Clutter::Color->new(0xcc, 0xcc, 0xcc, 0xff));
$stage->signal_connect(key_press_event => sub { Clutter->main_quit(); });

my $group = Clutter::Group->new();
$group->set_position(100, 100);
$stage->add($group);

my $rect = Clutter::Rectangle->new();
$rect->set_size(100, 100);
$rect->set_position(0, 0);
$rect->set_color(Clutter::Color->new(0x33, 0x22, 0x22, 0xff));
$rect->set_border_width(5);
$rect->set_border_color(Clutter::Color->new(0xff, 0xcc, 0xcc, 0xff));

$group->add($rect);

my $hand;
eval { $hand = Clutter::Texture->new('redhand.png') };
if ($@) {
    warn ("Unable to load 'redhand.png': $@");
}
else {
    $hand->set_position(5, 5);
    $rect->set_size($hand->get_width()  + 10,
                    $hand->get_height() + 10);

    $group->add($hand);
}

my $timeline = Clutter::Timeline->new(4000);
$timeline->set_loop(TRUE);

my $o_behave = Clutter::Behaviour::Opacity->new(
    Clutter::Alpha->new($timeline, 'linear'),
    0x33, 0xff
);
$o_behave->apply($group);

my $p_behave = Clutter::Behaviour::Path->new(
    Clutter::Alpha->new($timeline, 'ease-in-out-sine'),
    Clutter::Path->new(
        [ 'move-to', [ [ 100, 100 ] ] ],
        [ 'line-to', [ [   0, 250 ] ] ],
        [ 'line-to', [ [ 250, 250 ] ] ],
        [ 'line-to', [ [ 250, 150 ] ] ],
        [ 'close',                    ],
    ),
);
$p_behave->apply($group);

my $r_behave = Clutter::Ex::Behaviour::Rotate->new(
    alpha => Clutter::Alpha->new($timeline, 'ease-in-cubic'),
);
$r_behave->apply($group);

$timeline->start();

$stage->show();

Clutter->main();

0;
