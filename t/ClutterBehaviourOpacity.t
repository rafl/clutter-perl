use Test::More tests => 4;
use Clutter;

Clutter->init();

my $behaviour = Clutter::Behaviour::Opacity->new(undef, 0, 0);
isa_ok($behaviour, 'Clutter::Behaviour::Opacity', 'is an opacity');
isa_ok($behaviour, 'Clutter::Behaviour', 'is a behaviour');

$behaviour = Clutter::Behaviour::Opacity->new(undef, 0xff, 0x33);
is($behaviour->get('opacity-start'), 0xff, 'opacity start');
isnt($behaviour->get('opacity-end'), 0x00, 'opacity end');
