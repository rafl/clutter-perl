use strict;
use warnings;

use Glib qw( :constants );
use Gtk2;
use Clutter;

Clutter->init();

my $stage = Clutter::Stage->get_default();
$stage->set_color(Clutter::Color->new(0xcc, 0xcc, 0xcc, 0xff));
$stage->signal_connect(key_press_event => sub { Clutter->main_quit(); });

my $pixbuf;
eval { $pixbuf = Gtk2::Gdk::Pixbuf->new_from_file('redhand.png'); };
if ($@) {
    die ("Unable to load 'redhand.png': $@");
}

my $group = Clutter::Group->new();
$stage->add($group);
$group->show();

my $rect = Clutter::Rectangle->new();
$rect->set_position(0, 0);
$rect->set_size($pixbuf->get_width()  + 5,
                $pixbuf->get_height() + 5);
$rect->set_color(Clutter::Color->new(0x33, 0x22, 0x22, 0xff));
$rect->set_border_width(10);
$rect->set_border_color(Clutter::Color->new(0xff, 0xcc, 0xcc, 0xff));
$rect->show();

my $hand = Clutter::Texture->new($pixbuf);
$hand->set_position(5, 5);
$hand->show();

$group->add($rect, $hand);

my $timeline = Clutter::Timeline->new(100, 26);
$timeline->set(loop => TRUE);

my $alpha = Clutter::Alpha->new($timeline, \&Clutter::Alpha::sine);
my $o_behave = Clutter::Behaviour::Opacity->new($alpha, 0x33, 0xff);
$o_behave->apply($group);

my $p_behave = Clutter::Behaviour::Path->new($alpha,
    [
        [   0,   0 ],
        [   0, 300 ],
        [ 300, 300 ],
        [ 300,   0 ],
        [   0,   0 ],
    ]);
$p_behave->apply($group);

$timeline->start();

$stage->show_all();

Clutter->main();

0;
