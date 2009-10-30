package Clutter::Ex::SampleLayout;

use Glib qw( :constants );

sub BEGIN {
    Glib::Type->register_enum(
        'Clutter::Ex::Orientation',
        'horizontal',
        'vertical',
    );
}

use strict;
use warnings;

use List::Util qw( min max );
use Clutter;

use Glib::Object::Subclass
    'Clutter::LayoutManager',
    properties => [
        Glib::ParamSpec->enum(
            'orientation',
            'Orientation',
            'The packing orientation',
            'Clutter::Ex::Orientation',
            'horizontal',
            [ qw( readable writable ) ],
        ),
    ];

sub INIT_INSTANCE {
    my ($self) = @_;

    $self->{orientation} = 'horizontal';
    $self->{container}   = undef;
}

sub SET_PROPERTY {
    my ($self, $pspec, $value) = @_;

    $self->set_orientation($value)
        if $pspec->get_name() eq 'orientation';
}

sub GET_PROPERTY {
    my ($self, $pspec) = @_;

    return $self->get_orientation()
        if $pspec->get_name() eq 'orientation';
}

sub SET_CONTAINER {
    my ($self, $container) = @_;

    $self->{container} = $container;
}

sub GET_PREFERRED_WIDTH {
    my ($self, $container, $for_height) = @_;

    my ($min, $natural) = (0, 0);

    foreach my $child ($container->get_children()) {
        next unless $child->visible;

        my (
            $child_min,
            $child_natural
        ) = $child->get_preferred_width($for_height);

        if ($self->{orientation} eq 'horizontal') {
            $min += $child_min;
            $natural += $child_natural;
        }
        else {
            $min = max ($min, $child_min);
            $natural = max ($natural, $child_natural);
        }
    }

    return ($min, $natural);
}

sub GET_PREFERRED_HEIGHT {
    my ($self, $container, $for_width) = @_;

    my ($min, $natural) = (0, 0);

    foreach my $child ($container->get_children()) {
        next unless $child->visible;

        my (
            $child_min,
            $child_natural,
        ) = $child->get_preferred_height($for_width);

        if ($self->{orientation} eq 'horizontal') {
            $min = max ($min, $child_min);
            $natural = max ($natural, $child_natural);
        }
        else {
            $min += $child_min;
            $natural += $child_natural;
        }
    }

    return ($min, $natural);
}

sub ALLOCATE {
    my ($self, $container, $allocation, $flags) = @_;

    my ($child_x, $child_y) = (0, 0);

    foreach my $child ($container->get_children()) {
        next unless $child->visible;

        my ($child_width, $child_height, $min, $natural);

        ($min, $natural) =
            $child->get_preferred_width($allocation->height);
        $child_width = max ($min, min ($natural, $allocation->width));

        ($min, $natural) =
            $child->get_preferred_height($child_width);
        $child_height = max ($min, min ($natural, $allocation->height));

        $child->allocate(
            Clutter::ActorBox->new(
                $child_x,
                $child_y,
                $child_x + $child_width,
                $child_y + $child_height,
            ),
            $flags,
        );

        if ($self->{orientation} eq 'horizontal') {
            $child_x += $child_width;
        }
        else {
            $child_y += $child_height;
        }
    }
}

sub set_orientation {
    my ($self, $orientation) = @_;

    unless ($self->{orientation} eq $orientation) {
        $self->{orientation} = $orientation;
        $self->{container}->queue_relayout()
            if defined $self->{container};
        $self->notify('orientation');
    }
}

sub get_orientation {
    my ($self) = @_;

    return $self->{orientation};
}

package main;

use strict;
use warnings;

use Glib qw( :constants );
use Clutter qw( :init );
use Clutter::Keysyms;

my $stage = Clutter::Stage->get_default();

my $layout = Clutter::Ex::SampleLayout->new();

my $box = Clutter::Box->new($layout);
$box->set_reactive(TRUE);
$box->signal_connect(button_press_event => sub {
    my ($actor, $event) = @_;

    if ($layout->get_orientation() eq 'horizontal') {
        $layout->set_orientation('vertical');
    }
    else {
        $layout->set_orientation('horizontal');
    }
});

foreach my $i (0 .. 9) {
    my $rect = Clutter::Rectangle->new();

    my $color = Clutter::Color->new(
        int(rand(255)),
        int(rand(255)),
        int(rand(255)),
        255,
    );

    $rect->set_color($color);
    $rect->set_size(50, 50);
    $rect->set_reactive(TRUE);
    $rect->signal_connect(button_press_event => sub {
        print "Clicked child number: ", $i, "\n";

        return $Clutter::EVENT_PROPAGATE;
    });

    $box->add($rect);

    $rect->hide() if $i % 2;
}

my $info = Clutter::Text->new();
$info->set_font_name('Sans 16px');
$info->set_text("Press 'q' to quit\n"
              . "Click the container actor to change its orientation");
$info->set_y($stage->get_height() - $info->get_height() - 10);

$stage->signal_connect(key_press_event => sub {
    my ($actor, $event, $container) = @_;

    if ($event->key_symbol eq $Clutter::Keysyms{q}) {

        Clutter->main_quit();
    }

    return $Clutter::EVENT_STOP;
}, $box);

$stage->add($box, $info);
$stage->show();

Clutter->main();

0;
