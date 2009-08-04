package My::FooInterval;

use Clutter;

use Glib::Object::Subclass
    'Clutter::Interval',
    properties => [
        Glib::ParamSpec->float(
            'threshold',
            'Threshold',
            'Threshold for the switch',
            0.1, 0.9, 0.5,
            [ qw( readable writable ) ],
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

    $self->{threshold} = 0.5;
}

sub COMPUTE_VALUE {
    my ($self, $factor) = @_;

    my ($initial, $final) = $self->get_interval();

    return $final if $factor > $self->{threshold};

    return $initial;
}

sub set_threshold {
    my ($self, $factor) = @_;

    $self->{threshold} = $factor;

    $self->notify('threshold');
}

sub get_threshold {
    my ($self) = @_;

    return $self->{threshold}
}

package main;

use Clutter::TestHelper tests => 14;

my $interval = Clutter::Interval->new('Glib::Int');
isa_ok($interval, 'Clutter::Interval', 'is an interval');

$interval->set_initial_value(0);
is($interval->get_initial_value(), 0, 'initial value/1');

$interval->set_final_value(42);
is($interval->get_final_value(), 42, 'final value/1');

$interval->set_interval(42, 47);
is($interval->get_initial_value(), 42, 'initial value/2');
is($interval->get_final_value(), 47, 'final value/2');

my @values = $interval->get_interval();
is_deeply(\@values, [ 42, 47 ], 'interval');

SKIP: {
    skip 'no support for GParamSpecGType in perl-Glib', 8;

    $interval = My::FooInterval->new(value_type => 'Glib::Boolean');
    isa_ok($interval, 'My::FooInterval', 'is a foo interval');
    isa_ok($interval, 'Clutter::Interval', 'is a clutter interval');

    $interval->set_interval(FALSE, TRUE);
    is($interval->compute_value(0.3), FALSE, 'compute value/1');
    is($interval->compute_value(0.7), TRUE, 'compute value/2');
    is($interval->compute_value(0.9), TRUE, 'compute value/3');

    $interval->set_threshold(0.8);
    is($interval->compute_value(0.3), FALSE, 'compute value after set threshold/1');
    is($interval->compute_value(0.7), FALSE, 'compute value after set threshold/2');
    is($interval->compute_value(0.9), TRUE, 'compute value after set threshold/3');
}
