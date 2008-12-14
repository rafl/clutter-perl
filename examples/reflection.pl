package Clutter::Ex::TextureReflection;

use warnings;
use strict;

use Glib qw( :constants );
use Clutter;

=pod

=head1 NAME

Clutter::Ex::TextureReflection - Reflection of a texture

=head1 SYNOPSIS

  use Clutter qw( :init );
  use Clutter::Ex::TextureReflection;

  my $texture = Clutter::Texture->new($filename);

  my $reflection = Clutter::Ex::TextureReflection->new();
  $reflection->set_parent_texture($texture);

=head1 DESCRIPTION

This page describes the API of C<Clutter::Ex::TextureReflection>, a subclass
of L<Clutter::Texture::Clone> that paints a reflection of the parent texture.

=head1 HIERARCHY

  Glib::Object
  +----Glib::InitiallyUnowned
       +----Clutter::Actor
            +----Clutter::Texture::Clone
                 +----Clutter::Ex::TextureReflection

=cut

use Glib::Object::Subclass
    'Clutter::Texture::Clone',
    signals => { },
    properties => [
        Glib::ParamSpec->int(
            'reflection-height',
            'Reflection Height',
            'The height of the reflection, or -1',
            -1, 65536, -1,
            [ qw( readable writable ) ],
        ),
    ];

sub PAINT {
    my ($self) = @_;

    my $parent = $self->get_parent_texture();
    return unless $parent;

    my $cogl_tex = $parent->get_cogl_texture();
    return unless $cogl_tex;

    my ($width, $height) = $self->get_size();

    my $r_height = $self->{reflection_height};
    $r_height = $height if $r_height < 0 or $r_height > $height;

    my $rty = $r_height / $height;

    my $opacity = $self->get_paint_opacity();

    my $start = Clutter::Color->new(255, 255, 255, $opacity);
    my $stop  = Clutter::Color->new(255, 255, 255,        0);

    my $vertices = [
        [      0,         0, 0, 0.0, $rty,   $start],
        [ $width,         0, 0, 1.0, $rty,   $start],
        [ $width, $r_height, 0, 1.0,    0.0, $stop ],
        [      0, $r_height, 0, 0.0,    0.0, $stop ],
    ];

    Clutter::Cogl->push_matrix();

    $cogl_tex->texture_polygon($vertices, TRUE);

    Clutter::Cogl->pop_matrix();
}

sub SET_PROPERTY {
    my ($self, $pspec, $value) = @_;

    $self->set_reflection_height($value)
        if ($pspec->name() eq 'reflection-height');
}

sub GET_PROPERTY {
    my ($self, $pspec) = @_;

    return $self->get_reflection_height()
        if ($pspec->name() eq 'reflection-height');
}

sub INIT_INSTANCE {
    my ($self) = @_;

    $self->{reflection_height} = -1;
}

=pod

=head1 METHODS

=over

=item B<< actor = Clutter::Ex::TextureReflection->new >>

Creates a new Clutter::Ex::TextureReflection actor.

=cut

=pod

=item B<< $reflection->set_reflection_height ($height) >>

  * $height (integer)

Sets the height of the reflection, in pixels. If I<height> is a negative
value, the height of the parent texture will be used instead.

=cut

sub set_reflection_height {
    my ($self, $height) = @_;

    $self->{reflection_height} = $height;
}

=pod

=item B<< height = $reflection->get_reflection_height >>

Retrieves the height of the reflection.

=cut

sub get_reflection_height {
    my ($self) = @_;

    return $self->{reflection_height};
}

=pod

=back

=head1 PROPERTIES

=over

=item 'reflection-height' (integer : readable / writable)

Height of the reflection, in pixels

=back

=head1 SEE ALSO

L<Clutter>, L<Glib::Object>, L<Glib::InitiallyUnowned>, L<Clutter::Actor>,
L<Clutter::Texture>, L<Clutter::Texture::Clone>

=head1 COPYRIGHT

Copyright (C) 2008  Intel Corporation.

This module is free software; you can redistribute it and/or modify it
under the terms of the GNU Lesser General Public License version 2.1, or
under the terms of the Artistic License. See Clutter for the full copyright
notice.

=cut

package main;

use Glib qw( :constants );
use Clutter qw( :init );

my $filename = defined $ARGV[0] ? $ARGV[0] : 'redhand.png';

my $stage = Clutter::Stage->new();
$stage->set_size(640, 480);
$stage->set_color(Clutter::Color->parse('Black'));
$stage->signal_connect(destroy => sub { Clutter->main_quit() });
$stage->set_title('TextureReflection');

my $group = Clutter::Group->new();
$stage->add($group);

my $tex;
eval { $tex = Clutter::Texture->new($filename) };
if ($@) {
    warn ("Unable to load '$ARGV[0]': $@");
    exit 1;
}

my $reflect = Clutter::Ex::TextureReflection->new();
$reflect->set_parent_texture($tex);
$reflect->set_opacity(100);

my $x_pos = ($stage->get_width() - $tex->get_width()) / 2;
$group->add($tex, $reflect);
$group->set_position($x_pos, 20);

$reflect->set_position(0, $tex->get_height() + 20);

my $timeline = Clutter::Timeline->new_for_duration(3000);
$timeline->set_loop(TRUE);
my $alpha = Clutter::Alpha->new($timeline, \&Clutter::Alpha::ramp_inc);
my $behaviour = Clutter::Behaviour::Rotate->new($alpha, 'y-axis', 'cw', 0, 360);
$behaviour->set_center($group->get_width() / 2, 0, 0);
$behaviour->apply($group);

$stage->show();

$timeline->start();

Clutter->main();

0;
