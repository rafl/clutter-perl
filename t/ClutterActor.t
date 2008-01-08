package My::FooActor;

use Clutter;

use Glib::Object::Subclass
    'Clutter::Actor';

sub QUERY_COORDS
{
    my ($self, $box) = @_;

    if (exists ($self->{coords})) {
        return ($self->{coords}->x1, $self->{coords}->y1,
                $self->{coords}->x2, $self->{coords}->y2);
    }

    # we have to transform the pixels here
    return (Clutter::Units->FROM_INT(0),
            Clutter::Units->FROM_INT(0),
            Clutter::Units->FROM_INT(100),
            Clutter::Units->FROM_INT(100));
}

sub REQUEST_COORDS
{
    my ($self, $box) = @_;

    $self->{coords} = $box;

    $self->SUPER::REQUEST_COORDS($box);
}

package My::BarActor;

use Clutter;

use Glib::Object::Subclass
    'My::FooActor';

sub QUERY_COORDS
{
    my ($self, $box) = @_;

    return (Clutter::Units->FROM_DEVICE(100),
            Clutter::Units->FROM_DEVICE(100),
            Clutter::Units->FROM_DEVICE(150),
            Clutter::Units->FROM_DEVICE(150));
}

sub REQUEST_COORDS {
    my ($self, $box) = shift;

    $self->SUPER::REQUEST_COORDS($box);
}

package main;

use Clutter::TestHelper tests => 7;

my $foo_actor = My::FooActor->new();
isa_ok($foo_actor, 'Clutter::Actor', 'foo');

is($foo_actor->get_width(), 100, 'foo::query-coords #1');
is($foo_actor->get_height(), 100, 'foo::query-coords #2');

my $bar_actor = My::BarActor->new();
isa_ok($bar_actor, 'Clutter::Actor', 'bar');
isa_ok($bar_actor, 'Clutter::Actor', 'foo');

is($bar_actor->get_width(), 50, 'bar::query-coords #1');
is($bar_actor->get_height(), 50, 'bar::query-coords #2');
