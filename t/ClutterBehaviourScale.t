use Clutter::TestHelper tests => 7;

my $behaviour = Clutter::Behaviour::Scale->new(undef,
                                               1.0, 1.0,
                                               2.0, 2.0,
                                               'center');

isa_ok($behaviour, 'Clutter::Behaviour::Scale', 'is a scale');
isa_ok($behaviour, 'Clutter::Behaviour', 'is a behaviour');

is($behaviour->get('x-scale-start'), 1.0, 'scale start');
is($behaviour->get('y-scale-end'), 2.0, 'scale end');
is($behaviour->get('scale-gravity'), 'center', 'scale gravity');

$behaviour->set_gravity('none');
is($behaviour->get_gravity(), 'none', 'gravity accessor');

$behaviour->set_bounds(1.0, 1.0, 0.5, 0.5);
ok(eq_array($behaviour->get_bounds(), [ 1.0, 1.0, 0.5, 0.5 ]), 'bounds accessor');
