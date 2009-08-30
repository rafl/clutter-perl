package Clutter::Ex::SampleChildMeta;

use strict;
use warnings;

use Glib qw( :constants );
use Clutter;

use Glib::Object::Subclass
    'Clutter::ChildMeta',
    properties => [
        Glib::ParamSpec->boolean(
            'allocate-hidden',
            'Allocate Hidden',
            'Allocate space when hidden',
            TRUE,
            [ qw( construct readable writable ) ],
        ),
    ];

sub SET_PROPERTY {
    my ($self, $pspec, $value) = @_;

    $self->{$pspec->get_name()} = $value;
}

sub GET_PROPERTY {
    my ($self, $pspec) = @_;

    return $self->{$pspec->get_name()};
}

sub INIT_INSTANCE {
    my ($self) = @_;

    $self->{allocate_hidden} = TRUE;
}

package Clutter::Ex::SampleBox;

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
use Glib qw( :constants );
use Clutter;

use Glib::Object::Subclass
    'Clutter::Actor',
    properties => [
        Glib::ParamSpec->enum(
            'orientation',
            'Orientation',
            'The packing orientation',
            'Clutter::Ex::Orientation',
            'horizontal',
            [ qw( readable writable ) ],
        ),
    ],
    interfaces => [ 'Clutter::Container', ];

sub INIT_INSTANCE {
    my ($self) = @_;

    $self->{children} = [ ];
    $self->{meta} = { };

    $self->{orientation} = 'horizontal';

    $self->set_child_meta_type('Clutter::Ex::SampleChildMeta');
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

sub ADD {
    my ($self, $child) = @_;

    push @{$self->{children}}, $child;
    $child->set_parent($self);

    $self->signal_emit('actor-added', $child);
    $self->queue_relayout();
}

sub REMOVE {
    my ($self, $child) = @_;

    my @children = ();
    foreach my $actor (@{$self->{children}}) {
        push @children, $actor unless $child eq $actor;
    }

    $self->{children} = \@children;

    $child->unparent();

    $self->signal_emit('actor-removed', $child);
    $self->queue_relayout();
}

sub FOREACH {
    my ($self, $func, $data) = @_;

    foreach my $child (@{$self->{children}}) {
        &$func ($child, $data);
    }
}

sub CREATE_CHILD_META {
    my ($self, $actor) = @_;

    my $meta = Clutter::Ex::SampleChildMeta->new();
    $meta->set_container($self);
    $meta->set_actor($actor);

    $self->{meta}->{$actor} = $meta;
}

sub DESTROY_CHILD_META {
    my ($self, $actor) = @_;

    delete $self->{meta}->{$actor};
}

sub GET_CHILD_META {
    my ($self, $actor) = @_;

    return $self->{meta}->{$actor};
}

sub PICK {
    my ($self, $pick_color) = @_;

    $self->SUPER::PICK($pick_color);

    foreach my $child (@{$self->{children}}) {
        $child->paint();
    }
}

sub PAINT {
    my ($self) = @_;

    foreach my $child (@{$self->{children}}) {
        $child->paint();
    }
}

sub GET_PREFERRED_WIDTH {
    my ($self, $for_height) = @_;

    my ($min, $natural) = (0, 0);

    foreach my $child (@{$self->{children}}) {
        next if (not $child->visible) and
                (not $self->child_get($child, 'allocate-hidden'));

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
    my ($self, $for_width) = @_;

    my ($min, $natural) = (0, 0);

    foreach my $child (@{$self->{children}}) {
        next if (not $child->visible) and
                (not $self->child_get($child, 'allocate-hidden'));

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
    my ($self, $allocation, $flags) = @_;

    $self->SUPER::ALLOCATE($allocation, $flags);

    my ($child_x, $child_y) = (0, 0);

    foreach my $child (@{$self->{children}}) {
        next if (not $child->visible) and
                (not $self->child_get($child, 'allocate-hidden'));

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
        $self->queue_relayout();
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

my $box = Clutter::Ex::SampleBox->new();
$box->set_reactive(TRUE);
$box->signal_connect(button_press_event => sub {
    my ($actor, $event) = @_;

    if ($actor->get_orientation() eq 'horizontal') {
        $actor->set_orientation('vertical');
    }
    else {
        $actor->set_orientation('horizontal');
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

    $box->add($rect);
    $box->child_set($rect, 'allocate-hidden', FALSE);

    $rect->hide() if $i % 2;
}

my $info = Clutter::Text->new();
$info->set_font_name('Sans 16px');
$info->set_text("Press 'q' to quit\n"
              . "Press 'h' to allocate hidden actors\n"
              . "Click the container actor to change its orientation");
$info->set_y($stage->get_height() - $info->get_height() - 10);

$stage->signal_connect(key_press_event => sub {
    my ($actor, $event, $container) = @_;

    if ($event->key_symbol eq $Clutter::Keysyms{q}) {
        Clutter->main_quit();
        return TRUE;
    }

    return FALSE unless $event->key_symbol eq $Clutter::Keysyms{h};

    foreach my $child ($container->get_children()) {
        my $value = $container->child_get($child, 'allocate-hidden');

        $container->child_set($child, 'allocate-hidden', not $value);
    }

    $container->queue_relayout();

    return TRUE;
}, $box);

$stage->add($box, $info);
$stage->show();

Clutter->main();

0;
