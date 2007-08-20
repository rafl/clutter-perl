use Clutter::TestHelper tests => 6;

my $timeline = Clutter::Timeline->new(10, 10);
isa_ok($timeline, 'Clutter::Timeline', 'is a timeline');

is($timeline->get_n_frames(), 10, 'n-frames');
is($timeline->get_speed(), 10, 'fps');

$timeline->set_loop(TRUE);
isnt($timeline->get_loop(), FALSE, 'we are loopy');

is($timeline->is_playing(), FALSE, 'we are not playing');

$timeline->set_delay(100);
is($timeline->get_delay(), 100, 'delay');

use Clutter::TestHelper tests => 6;

my $timeline = Clutter::Timeline->new(10, 10);
isa_ok($timeline, 'Clutter::Timeline', 'is a timeline');

is($timeline->get_n_frames(), 10, 'n-frames');
is($timeline->get_speed(), 10, 'fps');

$timeline->set_loop(TRUE);
isnt($timeline->get_loop(), FALSE, 'we are loopy');

is($timeline->is_playing(), FALSE, 'we are not playing');

$timeline->set_delay(100);
is($timeline->get_delay(), 100, 'delay');

