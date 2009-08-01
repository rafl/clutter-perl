package My::FooActor;

use Clutter;

use Glib::Object::Subclass
    'Clutter::Actor';

sub GET_PREFERRED_WIDTH
{
    my ($self, $for_height) = @_;

    return (0.0, 100.0);
}

sub GET_PREFERRED_HEIGHT
{
    my ($self, $for_width) = @_;

    return (0.0, 100.0);
}

sub ALLOCATE
{
    my ($self, $box, $flags) = @_;

    $self->SUPER::ALLOCATE($box, $flags);

    $self->{coords} = $box;
}

sub APPLY_TRANSFORM
{
    my ($self, $matrix) = @_;

    $self->SUPER::APPLY_TRANSFORM($matrix);

    $matrix->translate(-100, 0, 0);
}

package My::BarActor;

use Clutter;

use Glib::Object::Subclass
    'My::FooActor';

sub GET_PREFERRED_WIDTH
{
    my ($self, $for_height) = @_;

    return (0, 50);
}

sub ALLOCATE {
    my ($self, $box, $origin_changed) = @_;

    $self->SUPER::ALLOCATE($box, $origin_changed);
}

package main;

use Clutter::TestHelper tests => 8;

my $foo_actor = My::FooActor->new();
isa_ok($foo_actor, 'Clutter::Actor', 'foo');

my @foo_width = $foo_actor->get_preferred_width(-1);
is_deeply(\@foo_width, [ 0, 100 ], 'foo::width');

my @foo_height = $foo_actor->get_preferred_height(-1);
is_deeply(\@foo_height, [ 0, 100 ], 'foo::height');

my $bar_actor = My::BarActor->new();
isa_ok($bar_actor, 'Clutter::Actor', 'bar');
isa_ok($bar_actor, 'Clutter::Actor', 'foo');

my @bar_width = $bar_actor->get_preferred_width(-1);
is_deeply(\@bar_width, [ 0, 50 ], 'bar::width');

my @bar_height = $bar_actor->get_preferred_height(-1);
is_deeply(\@bar_height, [ 0, 100 ], 'bar::height');

my $matrix = $foo_actor->get_transformation_matrix();
isa_ok($matrix, 'Clutter::Cogl::Matrix', 'foo::matrix');
