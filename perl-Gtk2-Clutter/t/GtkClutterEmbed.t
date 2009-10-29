use Test::More tests => 4;
use Gtk2::Clutter '-init';

use strict;

my $embed = Gtk2::Clutter::Embed->new();
isa_ok($embed, 'Gtk2::Widget', 'is a widget');

my $stage = $embed->get_stage();
isa_ok($stage, 'Clutter::Actor', 'is a bird');
isa_ok($stage, 'Clutter::Group', 'is a plane');
isa_ok($stage, 'Clutter::Stage', 'no, is a Clutter::Stage');

__END__

Copyright (C) 2006,2007,2008 OpenedHand Ltd
Copyright (C) 2009 Intel Corp

See the file AUTHORS for the full list.
See LICENSE for more information.
