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
of L<Clutter::Texture::Clone> that efficiently paints a reflection of the
parent texture.

=head1 HIERARCHY

  Glib::Object
  +----Glib::InitiallyUnowned
       +----Clutter::Actor
            +----Clutter::Texture
                 +----Clutter::Ex::TextureReflection

=cut

use Data::Dumper;

use Glib::Object::Subclass
    'Clutter::Texture',
    signals => { },
    properties => [
        Glib::ParamSpec->int(
            'reflection-height',
            'Reflection Height',
            'The height of the reflection, or -1',
            -1, 65536, -1,
            [ qw( readable writable ) ],
        ),
        Glib::ParamSpec->object(
            'parent-texture',
            'Parent Texture',
            'The texture to do the reflection for',
            'Clutter::Texture',
            [ qw( readable writable ) ],
        ),
    ];

sub GET_PREFERRED_WIDTH {
    my ($self, $for_height) = @_;

    return (0, 0) unless defined $self->{parent_texture};

    return $self->{parent_texture}->get_preferred_width($for_height);
}

sub GET_PREFERRED_HEIGHT {
    my ($self, $for_width) = @_;

    return (0, 0) unless defined $self->{parent_texture};

    return $self->{parent_texture}->get_preferred_height($for_width);
}

sub PAINT {
    my ($self) = @_;

    my $parent = $self->get_parent_texture();
    return unless $parent;

    # get the handle from the parent texture
    my $cogl_tex = $parent->get_cogl_texture();
    return unless $cogl_tex;

    my $box = $self->get_allocation_box();

    my ($width, $height) = $box->get_size();
    return unless $width > 0 and $height > 0;

    my $r_height = $self->{reflection_height};

    # clamp the reflection height if needed
    $r_height = $height if $r_height < 0 or $r_height > $height;

    my $rty = $r_height / $height;

    my $opacity = $self->get_paint_opacity() / 255;

    my $start = [ 1.0, 1.0, 1.0, $opacity ];
    my $stop  = [ 1.0, 1.0, 1.0,      0.0 ];
    $start = Clutter::Cogl::Color->premultiply($start);
    $stop  = Clutter::Cogl::Color->premultiply($stop);

    # these are the reflection vertices. each vertex
    # is an arrayref in the form:
    #
    #   [
    #     x, y, z: coordinates in the modelview
    #     tx, ty: texture coordinates
    #     color: color of the vertex
    #   ]
    #
    # to paint the reflection of the parent texture we paint
    # the texture using four vertices in clockwise order, with
    # the upper left and the upper right at full opacity and
    # the lower right and lower left and 0 opacity; OpenGL will
    # do the gradient for us
    my $vertices = [
        [      0,         0, 0, 0.0, $rty,   $start ],
        [ $width,         0, 0, 1.0, $rty,   $start ],
        [ $width, $r_height, 0, 1.0,    0.0, $stop  ],
        [      0, $r_height, 0, 0.0,    0.0, $stop  ],
    ];

    Clutter::Cogl->push_matrix();

    # paint the original texture again, at the new vertices
    Clutter::Cogl->polygon($vertices, TRUE);

    Clutter::Cogl->pop_matrix();
}

sub SET_PROPERTY {
    my ($self, $pspec, $value) = @_;

    $self->set_reflection_height($value)
        if ($pspec->get_name() eq 'reflection_height');

    $self->set_parent_texture($value)
        if ($pspec->get_name() eq 'parent_texture');
}

sub GET_PROPERTY {
    my ($self, $pspec) = @_;

    return $self->get_reflection_height()
        if ($pspec->get_name() eq 'reflection_height');

    return $self->get_parent_texture()
        if ($pspec->get_name() eq 'parent_texture');
}

sub INIT_INSTANCE {
    my ($self) = @_;

    $self->{reflection_height} = -1;
    $self->{parent_texture}    = undef;
}

=pod

=head1 METHODS

=over

=item B<< actor = Clutter::Ex::TextureReflection->new ($parent_texture) >>

  * $parent_texture (Clutter::Texture) the parent texture

Creates a new Clutter::Ex::TextureReflection actor for the given
I<parent_texture>

=cut

sub new {
    my ($class, $parent_texture) = @_;

    return Glib::Object::new(
        'Clutter::Ex::TextureReflection',
        parent_texture => $parent_texture,
    );
}

=pod

=item B<< $reflection->set_reflection_height ($height) >>

  * $height (integer)

Sets the height of the reflection, in pixels. If I<height> is a negative
value, the height of the parent texture will be used instead.

=cut

sub set_reflection_height {
    my ($self, $height) = @_;

    $self->{reflection_height} = $height;

    $self->queue_relayout();

    $self->notify('reflection-height');
}

=pod

=item B<< height = $reflection->get_reflection_height >>

Retrieves the height of the reflection.

=cut

sub get_reflection_height {
    my ($self) = @_;

    return $self->{reflection_height};
}

sub set_parent_texture {
    my ($self, $texture) = @_;

    $self->{parent_texture} = $texture;

    $self->queue_relayout();

    $self->notify('parent-texture');
}

sub get_parent_texture {
    my ($self) = @_;

    return $self->{parent_texture};
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
$stage->set_color(Clutter::Color->from_string('Black'));
$stage->signal_connect(destroy => sub { Clutter->main_quit() });
$stage->set_title('TextureReflection');

my $group = Clutter::Group->new();
$stage->add($group);

my $tex;
eval { $tex = Clutter::Texture->new($filename) };
if ($@) {
    warn ("Unable to load '$filename': $@");
    exit 1;
}

my $reflect = Clutter::Ex::TextureReflection->new($tex);
$reflect->set_opacity(100);

$group->add($tex, $reflect);

$tex->set_position(0, 0);
$reflect->set_position(0, $tex->get_height() + 10);

my $x_pos = ($stage->get_width() - $tex->get_width()) / 2;
$group->set_position($x_pos, 20);

my $timeline = Clutter::Timeline->new(3000);
$timeline->set_loop(TRUE);
my $alpha = Clutter::Alpha->new($timeline, 'linear');
my $behaviour = Clutter::Behaviour::Rotate->new($alpha, 'y-axis', 'cw', 0, 360);
$behaviour->set_center($group->get_width() / 2, 0, 0);
$behaviour->apply($group);

$stage->show();

$timeline->start();

Clutter->main();

0;
