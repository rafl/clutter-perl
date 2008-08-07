use Clutter::TestHelper tests => 13;

my $timeline = Clutter::Timeline->new(10, 10);
isa_ok($timeline, 'Clutter::Timeline', 'is a timeline');

is($timeline->get_n_frames(), 10, 'n-frames');
is($timeline->get_speed(), 10, 'fps');

$timeline->set_loop(TRUE);
isnt($timeline->get_loop(), FALSE, 'we are loopy');

is($timeline->is_playing(), FALSE, 'we are not playing');

$timeline->set_delay(100);
is($timeline->get_delay(), 100, 'delay');

$timeline->add_marker_at_frame('foo', 5);
is($timeline->has_marker('foo'), TRUE, 'marker at frame');

$timeline->set_speed(60);
is($timeline->get_speed(), 60, 'fps');

$timeline->set_duration(1000);
is($timeline->get_duration(), 1000, 'duration updates');

$timeline->add_marker_at_time('bar', 500);
is($timeline->has_marker('bar'), TRUE, 'marker at time');

my @markers = sort { $a cmp $b } $timeline->list_markers(-1);
is_deeply(\@markers, [ qw( bar foo ) ], 'all markers');

$timeline->add_marker_at_frame('baz', 5);
@markers = sort { $a cmp $b } $timeline->list_markers(5);
is_deeply(\@markers, [ qw( baz foo ) ], 'all markers at frame');

$timeline->remove_marker('foo');
isnt($timeline->has_marker('foo'), TRUE, 'marker remove');
