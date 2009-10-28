use Clutter::TestHelper tests => 10;

my $timeline = Clutter::Timeline->new(100);
isa_ok($timeline, 'Clutter::Timeline', 'is a timeline');

$timeline->set_loop(TRUE);
isnt($timeline->get_loop(), FALSE, 'we are loopy');

is($timeline->is_playing(), FALSE, 'we are not playing');

$timeline->set_delay(100);
is($timeline->get_delay(), 100, 'delay');

$timeline->add_marker_at_time('foo', 50);
is($timeline->has_marker('foo'), TRUE, 'marker at frame');

$timeline->set_duration(1000);
is($timeline->get_duration(), 1000, 'duration updates');

$timeline->add_marker_at_time('bar', 50);
is($timeline->has_marker('bar'), TRUE, 'marker at time');

my @markers = sort { $a cmp $b } $timeline->list_markers(-1);
is_deeply(\@markers, [ qw( bar foo ) ], 'all markers');

$timeline->add_marker_at_time('baz', 50);
@markers = sort { $a cmp $b } $timeline->list_markers(50);
is_deeply(\@markers, [ qw( bar baz foo ) ], 'all markers at time');

$timeline->remove_marker('foo');
isnt($timeline->has_marker('foo'), TRUE, 'marker remove');
