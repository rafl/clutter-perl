use Clutter::TestHelper tests => 11;
use Clutter::Keysyms;

my $event;

# Nothing
$event = Clutter::Event->new('nothing');
isa_ok($event, 'Clutter::Event');

# ButtonPress
# ButtonRelease
$event = Clutter::Event->new('button-press');
isa_ok($event, 'Clutter::Event::Button');
isa_ok($event, 'Clutter::Event');

my $timestamp = time ();
$event->set_time($timestamp);
is($event->get_time(), $timestamp, 'time');

is($event->click_count(1), 0, 'click count/1');
is($event->click_count, 1, 'click count/2');

is_deeply([ $event->get_coords() ], [ 0, 0 ], 'coords');

# KeyPress
# KeyRelease
$event = Clutter::Event->new('key-release');
isa_ok($event, 'Clutter::Event::Key');
isa_ok($event, 'Clutter::Event');

is($event->key_symbol($Clutter::Keysyms{'Escape'}), 0, 'key symbol/1');
is($event->key_symbol(), $Clutter::Keysyms{'Escape'}, 'key symbol/2');
