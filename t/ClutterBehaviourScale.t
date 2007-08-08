use Clutter::TestHelper tests => 5;

my $behaviour = Clutter::Behaviour::Scale->new(undef, 0, 0, 'center');
isa_ok($behaviour, 'Clutter::Behaviour::Scale', 'is a scale');
isa_ok($behaviour, 'Clutter::Behaviour', 'is a behaviour');

is($behaviour->get('scale-begin'), 0, 'scale begin');
is($behaviour->get('scale-end'), 0, 'scale end');
is($behaviour->get('scale-gravity'), 'center', 'scale gravity');
