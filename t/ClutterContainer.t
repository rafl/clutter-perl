package My::FooContainer::Meta;

use Clutter;

use Glib::Object::Subclass
    'Clutter::ChildMeta',
    properties => [
        Glib::ParamSpec->string(
            'foo-name',
            'Foo Name',
            'The name of the foo of a child of FooContainer',
            'blah',
            [ qw( readable writable ) ],
        ),
    ];

package My::FooContainer;

use Clutter;

use Glib::Object::Subclass
    'Clutter::Actor',
    interfaces => [ 'Clutter::Container', ],
    ;

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
    my ($self, $callback, $data) = @_;

    foreach my $child (@{$self->{children}}) {
        &$callback ($child, $data);
    }
}

sub CREATE_CHILD_META {
    my ($self, $actor) = @_;

    my $meta = My::FooContainer::Meta->new();
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

    warn("No meta-data available for $actor")
        unless $self->{meta}->{$actor};

    return $self->{meta}->{$actor};
}

sub INIT_INSTANCE {
    my ($self) = @_;

    $self->{children} = [];
    $self->{meta}     = {};

    $self->set_child_meta_type('My::FooContainer::Meta');
}

package main;

use Clutter::TestHelper tests => 10;

my $foo = My::FooContainer->new();
isa_ok($foo, 'My::FooContainer');
is($foo->get_child_meta_type(), 'My::FooContainer::Meta');

my $rect = Clutter::Rectangle->new();
$foo->add($rect);
is($rect->get_parent(), $foo, 'parent set');

my $meta = $foo->get_child_meta($rect);
ok($meta, 'child meta');

isa_ok($meta, 'My::FooContainer::Meta', 'meta isa check 1');
isa_ok($meta, 'Clutter::ChildMeta', 'meta isa check 2');

is($meta->get_container(), $foo, 'container set');
is($meta->get_actor(), $rect, 'actor set');

is($foo->child_get($rect, 'foo-name'), 'blah', 'child_get');
$foo->child_set($rect, 'foo-name', 'baz');
is($foo->child_get($rect, 'foo-name'), 'baz', 'child_set');

$foo->destroy();
