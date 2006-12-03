use Glib;
use Clutter '-init';

use strict;
use warnings;

sub button_press_event_cb
{
    my ($stage, $event) = @_;

    printf "Button press ",
        "coordinates: (", $event->x, ", ", $event->y, ") ",
        "button: ", $event->button,
        "\n";
    
    Clutter->main_quit() if $event->button eq 1;
}

my $stage = Clutter::Stage->get_default();

$stage->set_size(800, 600);
$stage->set_color(Clutter::Color->new(0x6d, 0x6d, 0x70, 0xff));
$stage->signal_connect(button_press_event => \&button_press_event_cb);
$stage->signal_connect(add => sub {
	my ($group, $actor) = @_;
	
	print "Adding actor: $actor\n";
    });

my $rect;
for my $i (1 .. 10) {
    $rect = Clutter::Rectangle->new();
    $rect->set_color(Clutter::Color->new(0x35, 0x99, 0x2a, 0x66));
    $rect->set_border_width(6);
    $rect->set_border_color(Clutter::Color->new(0x00, 0x00, 0x00, 0x33));
    $rect->set_position((800 - (80 * $i)) / 2, (600 - (60 * $i)) / 2);
    $rect->set_size(80 * $i, 60 * $i);
    
    $stage->add($rect);

    $rect->show();
}

$stage->show();

Clutter->main();

0;
