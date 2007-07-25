/* Clutter.
 *
 * Perl bindings for the OpenGL based 'interactive canvas' library.
 *
 * Clutter Authored By Matthew Allum  <mallum@openedhand.com>
 * Perl bindings by Emmanuele Bassi  <ebassi@openedhand.com>
 * 
 * Copyright (C) 2006 OpenedHand
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the
 * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
 * Boston, MA 02111-1307, USA.
 */

#include "clutterperl.h"

static void
clutterperl_call_method (GType       gtype,
                         const char *method,
                         gint        flags)
{
  HV *stash;
  GV *slot;

  stash = gperl_object_stash_from_type (gtype);
  slot = gv_fetchmethod (stash, method);

  if (slot && GvCV (slot))
    call_sv ((SV *) GvCV (slot), flags);
}

static void
clutterperl_container_add (ClutterContainer *container,
                           ClutterActor     *actor)
{
  dSP;

  ENTER;
  SAVETMPS;
  PUSHMARK (SP);

  EXTEND (SP, 2);
  PUSHs (sv_2mortal (newSVClutterActor (CLUTTER_ACTOR (container))));
  PUSHs (sv_2mortal (newSVClutterActor (actor)));

  PUTBACK;

  clutterperl_call_method (G_OBJECT_TYPE (container),
                           "ADD",
                           G_VOID | G_DISCARD);

  FREETMPS;
  LEAVE;
}

static void
clutterperl_container_remove (ClutterContainer *container,
                              ClutterActor     *actor)
{
  dSP;

  ENTER;
  SAVETMPS;
  PUSHMARK (SP);

  EXTEND (SP, 2);
  PUSHs (sv_2mortal (newSVClutterActor (CLUTTER_ACTOR (container))));
  PUSHs (sv_2mortal (newSVClutterActor (actor)));

  PUTBACK;

  clutterperl_call_method (G_OBJECT_TYPE (container),
                           "REMOVE",
                           G_VOID | G_DISCARD);

  FREETMPS;
  LEAVE;
}

static void
clutterperl_container_foreach (ClutterContainer *container,
                               ClutterCallback   callback,
                               gpointer          callback_data)
{

}

static void
clutterperl_container_init (ClutterContainerIface *iface)
{
  iface->add = clutterperl_container_add;
  iface->remove = clutterperl_container_remove;
  iface->foreach = clutterperl_container_foreach;
}

static void
clutterperl_container_foreach_callback (ClutterActor *actor,
                                        gpointer      user_data)
{
  GPerlCallback *callback = user_data;
  
  gperl_callback_invoke (callback, NULL, actor);
}


MODULE = Clutter::Container     PACKAGE = Clutter::Container	PREFIX = clutter_container_

=for position DESCRIPTION

=head1 DESCRIPTION

FIXME

=cut

=for position post_methods

=head1 CREATING A CUSTOM CONTAINER ACTOR

  package MyContainer;
  use Clutter;
  use Glib::Object::Subclass
      'Clutter::Actor',
      interfaces => [ qw( Clutter::Container ) ];

=head2 Virtual Methods

In order to create a Clutter::Container actor, an implementation of the
following methods is required:

=over

=item ADD ($container, $actor)

=item REMOVE ($container, $actor)

=item FOREACH ($container, $callback, $callback_data)

=back

=cut

=for apidoc __hide__
=cut
void
_ADD_INTERFACE (class, const char *target_class)
    CODE:
    {
        static const GInterfaceInfo iface_info = {
          (GInterfaceInitFunc) clutterperl_container_init,
          NULL,
          NULL
        };
        GType gtype = gperl_object_type_from_package (target_class);
        g_type_add_interface_static (gtype, CLUTTER_TYPE_CONTAINER, &iface_info);
    }

void
clutter_container_add (ClutterContainer *container, ClutterActor *actor, ...)
    PREINIT:
        int i;
    CODE:
    	clutter_container_add_actor (container, actor);
	for (i = 2; i < items; i++)
	  clutter_container_add_actor (container, SvClutterActor (ST (i)));

void
clutter_container_remove (ClutterContainer *container, ClutterActor *actor, ...)
    PREINIT:
        int i;
    CODE:
        clutter_container_remove_actor (container, actor);
        for (i = 2; i < items; i++)
          clutter_container_remove_actor (container, SvClutterActor (ST (i)));

=for apidoc
=for signature actors = $container->get_children
=cut
void
clutter_container_get_children (ClutterContainer *container)
    PREINIT:
        GList *children = NULL, *l;
    PPCODE:
        children = clutter_container_get_children (container);
        if (children)
          {
            EXTEND (SP, (int) g_list_length (children));
            for (l = children; l != NULL; l = l->next)
              {
                PUSHs (sv_2mortal (newSVClutterActor_noinc (l->data)));
              }
            g_list_free (children);
          }

void
clutter_container_foreach (container, callback, callback_data=NULL)
        ClutterContainer *container
        SV *callback
        SV *callback_data
    PREINIT:
    	GPerlCallback *real_callback;
	GType param_types [1];
    CODE:
	param_types[0] = CLUTTER_TYPE_ACTOR;
	real_callback = gperl_callback_new (callback, callback_data,
                                            1, param_types,
					    G_TYPE_NONE);
	clutter_container_foreach (container,
                                   clutterperl_container_foreach_callback,
                                   real_callback);
	gperl_callback_destroy (real_callback);

