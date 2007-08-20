use Clutter::TestHelper tests => 5;

my $alpha = Clutter::Alpha->new();
isa_ok($alpha, 'Clutter::Alpha', 'is an alpha');

is($alpha->get_alpha(), 0, 'empty alpha');
is($alpha->get_timeline(), undef, 'empty timeline');

my $timeline = Clutter::Timeline->new(10, 10);
$alpha->set_timeline($timeline);
ok(1);

is($alpha->get_timeline(), $timeline, 'same timeline');
