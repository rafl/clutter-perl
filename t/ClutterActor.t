package My::FooActor;

use Clutter;

use Glib::Object::Subclass
    'Clutter::Actor';

sub QUERY_COORDS
{
    my ($self) = @_;

    if ($self->{coords}) {
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
    my ($self, $coords) = @_;

    $self->{coords} = $coords;

    $self->SUPER::REQUEST_COORDS($coords);
}

package My::BarActor;

use Clutter;

use Glib::Object::Subclass
    'My::FooActor';

sub QUERY_COORDS
{
    my $self = shift;

    # this will return units
    my @coords = $self->SUPER::QUERY_COORDS();

    return (Clutter::Units->FROM_INT(100),
            Clutter::Units->FROM_INT(100),
            $coords[2] + Clutter::Units->FROM_INT(100),
            $coords[3] + Clutter::Units->FROM_INT(100));
}

package main;

use Clutter::TestHelper tests => 6;

my $foo_actor = My::FooActor->new();
isa_ok($foo_actor, 'Clutter::Actor', 'isa check');

is($foo_actor->get_width(), 100, 'foo::query-coords #1');
is($foo_actor->get_height(), 100, 'foo::query-coords #2');

my $bar_actor = My::BarActor->new();
isa_ok($bar_actor, 'Clutter::Actor', 'isa check');

is($bar_actor->get_width(), 100, 'bar::query-coords #1');
is($bar_actor->get_height(), 100, 'bar::query-coords #2');
