use warnings;
use strict;

use Glib ':constants';
use Clutter ':gtk-init';

my $window = Gtk2::Window->new('toplevel');
$window->signal_connect(destroy => sub { Gtk2->main_quit(); });
$window->set_title('Gtk2::ClutterEmbed');
$window->set_resizable(FALSE);

my $vbox = Gtk2::VBox->new(FALSE, 6);
$window->add($vbox);

my $embed = Gtk2::ClutterEmbed->new();
$vbox->pack_start($embed, TRUE, FALSE, 0);

my $stage = $embed->get_stage();
$embed->set_size_request(300, 200);
$stage->set_color(Clutter::Color->parse('DarkBlue'));
$embed->realize();

my $rect = Clutter::Rectangle->new(Clutter::Color->parse('Yellow'));
$rect->set_size(100, 100);
$rect->set_anchor_point(50, 50);
$stage->add($rect);
$rect->set_position(150, 100);
$rect->set_rotation('x-axis', 45.0, 0, 0, 0);
$rect->show();

my $button = Gtk2::Button->new('Click me to quit');
$button->signal_connect(clicked => sub { Gtk2->main_quit(); });
$vbox->pack_end($button, FALSE, FALSE, 0);

$button = Gtk2::Button->new_from_stock('gtk-ok');
$vbox->pack_end($button, FALSE, FALSE, 0);

my $label = Gtk2::Label->new('<b>This is a GTK+ label</b>');
$label->set_use_markup(TRUE);
$vbox->pack_end($label, FALSE, FALSE, 0);

$window->show_all();

Gtk2->main();

0;
