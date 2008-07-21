package My::FooActor;

use Clutter;

use Glib::Object::Subclass
    'Clutter::Actor';

sub GET_PREFERRED_WIDTH
{
    my ($self, $for_height) = @_;

    # we have to transform the pixels here
    return (Clutter::Units->FROM_INT(0),
            Clutter::Units->FROM_INT(100));
}

sub GET_PREFERRED_HEIGHT
{
    my ($self, $for_width) = @_;

    # we have to transform the pixels here
    return (Clutter::Units->FROM_INT(0),
            Clutter::Units->FROM_INT(100));
}

sub ALLOCATE
{
    my ($self, $box, $origin_changed) = @_;

    $self->SUPER::ALLOCATE($box, $origin_changed);

    $self->{coords} = $box;
}

package My::BarActor;

use Clutter;

use Glib::Object::Subclass
    'My::FooActor';

sub GET_PREFERRED_WIDTH
{
    my ($self, $for_height) = @_;

    return (0, Clutter::Units->FROM_DEVICE(50));
}

sub ALLOCATE {
    my ($self, $box, $origin_changed) = @_;

    $self->SUPER::ALLOCATE($box, $origin_changed);
}

package main;

use Clutter::TestHelper tests => 7;

my $foo_actor = My::FooActor->new();
isa_ok($foo_actor, 'Clutter::Actor', 'foo');

my @foo_width = $foo_actor->get_preferred_width(-1);
is_deeply(\@foo_width,
          [ 0, Clutter::Units->FROM_DEVICE(100) ],
          'foo::width');

my @foo_height = $foo_actor->get_preferred_height(-1);
is_deeply(\@foo_height,
          [ 0, Clutter::Units->FROM_DEVICE(100) ],
          'foo::height');

my $bar_actor = My::BarActor->new();
isa_ok($bar_actor, 'Clutter::Actor', 'bar');
isa_ok($bar_actor, 'Clutter::Actor', 'foo');

my @bar_width = $bar_actor->get_preferred_width(-1);
is_deeply(\@bar_width,
          [ 0, Clutter::Units->FROM_DEVICE(50) ],
          'bar::width');

my @bar_height = $bar_actor->get_preferred_height(-1);
is_deeply(\@bar_height,
          [ 0, Clutter::Units->FROM_DEVICE(100) ],
          'bar::height');
