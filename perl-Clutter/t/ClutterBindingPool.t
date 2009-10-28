use Clutter::TestHelper tests => 7;
use Clutter::Keysyms;

sub test_fake {
    my ($pool, $action, $key, $modifiers) = @_;

    $pool->{"$action"} = 'called';

    return TRUE;
}

my $pool = Clutter::BindingPool->new('Test');
$pool->install_action('go-up', $Clutter::Keysyms{Up}, [], \&test_fake);
$pool->install_action('go-down', $Clutter::Keysyms{Down}, [], \&test_fake);
$pool->install_action('go-right', $Clutter::Keysyms{Right}, [], \&test_fake);

is($pool->activate($Clutter::Keysyms{Left}, [], $pool), FALSE, 'no left');
is($pool->activate($Clutter::Keysyms{Up}, [], $pool), TRUE, 'go up');
is($pool->{'go-up'}, 'called', 'go up called');

$pool->block_action('go-down');
is($pool->activate($Clutter::Keysyms{Down}, [], $pool), FALSE, 'blocked up');
is($pool->{'go-down'}, undef, 'go down not called');

is($pool->find_action($Clutter::Keysyms{Right}, []), 'go-right', 'find action');
$pool->remove_action($Clutter::Keysyms{Right}, []);
is($pool->activate($Clutter::Keysyms{Right}, [], $pool), FALSE, 'no right');
