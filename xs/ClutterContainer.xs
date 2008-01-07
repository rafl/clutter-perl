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

/*
 * GInterface support
 */

#define GET_METHOD(obj, name) \
       HV * stash = gperl_object_stash_from_type (G_OBJECT_TYPE (obj)); \
       GV * slot = gv_fetchmethod (stash, name);

#define METHOD_EXISTS (slot && GvCV (slot))

#define PREP(obj) \
       dSP; \
       ENTER; \
       SAVETMPS; \
       PUSHMARK (SP) ; \
       PUSHs (sv_2mortal (newSVGObject (G_OBJECT (obj))));

#define CALL \
       PUTBACK; \
       call_sv ((SV *) GvCV (slot), G_VOID | G_DISCARD);

#define FINISH \
       FREETMPS; \
       LEAVE;

static void
clutterperl_container_add (ClutterContainer *container,
                           ClutterActor     *actor)
{
  GET_METHOD (container, "ADD");

  if (METHOD_EXISTS)
    {
      PREP (container);

      XPUSHs (sv_2mortal (newSVClutterActor (actor)));

      CALL;

      FINISH;
    }
}

typedef struct {
  ClutterCallback func;
  gpointer data;
} ClutterPerlContainerForeachFunc;

static void
create_callback (ClutterCallback   func,
                 gpointer          data,
                 SV              **code_return,
                 SV              **data_return)
{
  HV *stash;
  gchar *sub;
  CV *dummy = NULL;
  SV *code, *my_data;
  ClutterPerlContainerForeachFunc *stuff;

  stash = gv_stashpv ("Clutter::Container::ForeachFunc", TRUE);

  sub = g_strdup_printf ("__clutterperl_container_foreach_func_%p", data);
  dummy = newCONSTSUB (stash, sub, NULL);
  g_free (sub);

  code = sv_bless (newRV_noinc ((SV *) dummy), stash);

  stuff = g_new0 (ClutterPerlContainerForeachFunc, 1);
  stuff->func = func;
  stuff->data = data;

  my_data = newSViv (PTR2IV (stuff));
  sv_magic ((SV *) dummy, 0, PERL_MAGIC_ext, (const char *) my_data, 0);

  *code_return = code;
  *data_return = my_data;
}

static void
clutterperl_container_remove (ClutterContainer *container,
                              ClutterActor     *actor)
{
  GET_METHOD (container, "REMOVE");

  if (METHOD_EXISTS)
    {
      PREP (container);

      XPUSHs (sv_2mortal (newSVClutterActor (actor)));

      CALL;

      FINISH;
    }
}

static void
clutterperl_container_foreach (ClutterContainer *container,
                               ClutterCallback   callback,
                               gpointer          callback_data)
{
  GET_METHOD (container, "FOREACH");

  if (METHOD_EXISTS)
    {
      SV *code, *data;

      PREP (container);

      create_callback (callback, data, &code, &data);

      XPUSHs (sv_2mortal (newSVsv (code)));
      XPUSHs (sv_2mortal (newSVsv (data)));

      CALL;

      FINISH;
    }
}

static void
clutterperl_container_raise (ClutterContainer *container,
                             ClutterActor     *child,
                             ClutterActor     *sibling)
{
  GET_METHOD (container, "RAISE");

  if (METHOD_EXISTS)
    {
      PREP (container);

      XPUSHs (sv_2mortal (newSVClutterActor (child)));
      if (sibling)
        XPUSHs (sv_2mortal (newSVClutterActor (sibling)));

      CALL;

      FINISH;
    }
}

static void
clutterperl_container_lower (ClutterContainer *container,
                             ClutterActor     *child,
                             ClutterActor     *sibling)
{
  GET_METHOD (container, "LOWER");

  if (METHOD_EXISTS)
    {
      PREP (container);

      XPUSHs (sv_2mortal (newSVClutterActor (child)));
      if (sibling)
        XPUSHs (sv_2mortal (newSVClutterActor (sibling)));

      CALL;

      FINISH;
    }
}

static void
clutterperl_container_init (ClutterContainerIface *iface)
{
  iface->add = clutterperl_container_add;
  iface->remove = clutterperl_container_remove;
  iface->foreach = clutterperl_container_foreach;
  iface->raise = clutterperl_container_raise;
  iface->lower = clutterperl_container_lower;
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

Called to add I<actor> to I<container>. The implementation should emit
the B<::actor-added> signal once the actor has been added.

=over

=item o $container (Clutter::Container)

=item o $actor (Clutter::Actor)

=back

=item REMOVE ($container, $actor)

Called to remove I<actor> from I<container>. The implementation should emit
the B<::actor-removed> signal once the actor has been removed.

=over

=item o $container (Clutter::Container)

=item o $actor (Clutter::Actor)

=back

=item RAISE ($container, $child, $sibling)

Called when raising I<child> above I<sibling>. If I<sibling> is undefined,
then I<child> should be raised above every other child of I<container>.

=over

=item o $container (Clutter::Container)

=item o $child (Clutter::Actor)

=item o $sibling (Clutter::Actor)

=back

=item LOWER ($container, $child, $sibling)

Called when lowering I<child> below I<sibling>. If I<sibling> is undefined,
then I<child> should be lowered below every other child of I<container>.

=over

=item o $container (Clutter::Container)

=item o $child (Clutter::Actor)

=item o $sibling (Clutter::Actor)

=back

=item FOREACH ($container, $function, $data)

Called when iterating over every child of I<container>. For each child
the I<function> must be called with the actor and the passed I<data>, for
instance:

  foreach my $child ($container->{children}) {
    $function ($child, $data);
  }

This function will also be called by the B<get_children> method.

=over

=item o $container (Clutter::Container)

=item o $function (code reference)

=item o $data (scalar) data to pass to the function

=back

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

ClutterActor_ornull *
clutter_container_find_child_by_name (container, name)
        ClutterContainer *container
        const gchar *name

void
clutter_container_raise_child (container, actor, sibling)
        ClutterContainer *container
        ClutterActor *actor
        ClutterActor *sibling

void
clutter_container_lower_child (container, actor, sibling)
        ClutterContainer *container
        ClutterActor *actor
        ClutterActor *sibling

MODULE = Clutter::Container     PACKAGE = Clutter::Container::ForeachFunc

void
invoke (ClutterActor *actor, SV *data)
    PREINIT:
        ClutterPerlContainerForeachFunc *stuff;
    CODE:
        stuff = INT2PTR (ClutterPerlContainerForeachFunc*, SvIV (data));
        if (!stuff | !stuff->func)
                croak("Invalid data passed to the foreach function");
        stuff->func (actor, stuff->data);

void
DESTROY (SV *code)
    PREINIT:
        MAGIC *mg;
        ClutterPerlContainerForeachFunc *stuff;
    CODE:
        if (!gperl_sv_defined (code) || !SvROK (code) || !(mg = mg_find (SvRV (code), PERL_MAGIC_ext)))
                return;
        stuff = INT2PTR (ClutterPerlContainerForeachFunc*, SvIV ((SV *) mg->mg_ptr));
        sv_unmagic (SvRV (code), PERL_MAGIC_ext);
        g_free (stuff);
