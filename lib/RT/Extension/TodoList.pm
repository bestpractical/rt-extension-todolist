use strict;
use warnings;
package RT::Extension::TodoList;

our $VERSION = '0.03';

RT->AddStyleSheets('rt-extension-todolist.css');
RT->AddJavaScript('rt-extension-todolist.js');

sub UpdateTodoList {
    my $self = shift;
    my %args = (
        ObjectId     => undef,
        CustomField  => undef,
        CurrentUser  => undef,
        @_
    );
    my ($ObjectId, $CustomField) = ($args{'ObjectId'}, $args{'CustomField'});

    my ($ret, $msg) = $self->UpdateTodoListAttribute (
        ObjectId => $ObjectId, CustomField => $CustomField, CurrentUser => $args{'CurrentUser'}
    );
    RT::Logger->error("Could not set TodoList ticket attribute: $msg") unless $ret;
    return '' unless $CustomField;

    my $Object = RT::Ticket->new($args{'CurrentUser'});
    ($ret, $msg) = $Object->Load($ObjectId);
    RT::Logger->error($msg) unless $ret;

    my $default_cf = RT::CustomField->new($args{'CurrentUser'});
    ($ret, $msg) = $default_cf->Load($CustomField);
    RT::Logger->error($msg) unless $ret;

    return $HTML::Mason::Commands::m->scomp('/Elements/EditCustomField',
        CustomField => $default_cf,
        Object      => $Object
    );
}

sub UpdateTodoListAttribute {
    my $self = shift;
    my %args = (
        ObjectId     => undef,
        CustomField  => undef,
        @_
    );
    return unless $args{'ObjectId'};

    my $ticket = RT::Ticket->new($args{'CurrentUser'});
    $ticket->Load($args{'ObjectId'});

    my ($ret, $msg);
    if ( $ticket->FirstAttribute('TodoList') ) {
        ($ret, $msg) = $ticket->SetAttribute( Name => 'TodoList', Content => $args{'CustomField'} );
    }
    else {
        ($ret, $msg) = $ticket->AddAttribute( Name => 'TodoList', Content => $args{'CustomField'} );
    }
    return ($ret, $msg);
}

sub UpdateTodoListCustomField {
    my $self = shift;
    my %args = (
        CurrentUser => undef,
        @_
    );

    # We have the object and custom field ID in the form of:
    # Object-RT::Ticket-6-CustomField-49-Values-66
    my ($object_type, $object_id, $cf_id, $cf_value_id);
    foreach my $key (keys %args) {
        if ( $key =~ /Object-RT::(.+)-(\d+)-CustomField-(\d+)-Values-(\d+)/ ) {
            ($object_type, $object_id, $cf_id, $cf_value_id) = ($1, $2, $3);

            my $Object = "RT::$object_type";
            my $object = $Object->new($args{'CurrentUser'});
            my ($ret, $msg) = $object->Load($object_id);
            RT::Logger->error("could not load object: $msg") unless $ret;

            if ( $args{$key} =~ /RT-TodoList-Remove-(.+)/) {
                ($ret, $msg) = $object->DeleteCustomFieldValue(Field => $cf_id, Value => $1);
                RT::Logger->error("could not remove value for custom field:  $cf_id :  $msg") unless $ret;
            } else {
                ($ret, $msg) = $object->AddCustomFieldValue(Field => $cf_id, Value => $args{$key});
                RT::Logger->error("could not add value for custom field:  $cf_id :  $msg") unless $ret;
            }
        }
    }
}

=head1 NAME

RT-Extension-TodoList

=head1 DESCRIPTION

Add todo lists to tickets. Often a ticket will define a task that requires several repeatable steps.
For example:

    'Deploy new server' = (
        Order server,
        Find rack space,
        Confirm power,
        Run networking,
        Assign IPs,
        Autoload base OS
    );

Where the steps listed above will generally always be the same for the task of deploying a new server
rack. This extension make tracking these tasks from one ticket simple by adding a todo list that can be
used repeatedly on any ticket created for the queue.

=head1 RT VERSION
    Works with RT 5.0

=head1 INSTALLATION

=over

=item C<perl Makefile.PL>

=item C<make>

=item C<make install>

May need root permissions

=item Edit your F</opt/rt4/etc/RT_SiteConfig.pm>

Add this line:

    Plugin('RT::Extension::TodoList');

=item Clear your mason cache

    rm -rf /opt/rt4/var/mason_data/obj

=item Restart your webserver

=back

=head1 CONFIGURATION

To make a custom field a todo list custom field, create a new custom field of type "select multiple values".
Once created there will be a checkbox option to make the custom field a todo list custom field, then you
can apply the custom field by queue per usual.

Each item in the list will be a todo list checkbox item and each custom field applied to the queue as a todo
list custom field will be available to load as the tickets todo's.

=cut

=head1 AUTHOR

Best Practical Solutions, LLC E<lt>modules@bestpractical.comE<gt>

=for html <p>All bugs should be reported via email to <a
href="mailto:bug-RT-Extension-TodoList@rt.cpan.org">bug-RT-Extension-TodoList@rt.cpan.org</a>
or via the web at <a
href="http://rt.cpan.org/Public/Dist/Display.html?Name=RT-Extension-TodoList">rt.cpan.org</a>.</p>

=for text
    All bugs should be reported via email to
        bug-RT-Extension-TodoList@rt.cpan.org
    or via the web at
        http://rt.cpan.org/Public/Dist/Display.html?Name=RT-Extension-TodoList

=head1 LICENSE AND COPYRIGHT

This software is Copyright (c) 2019 by Best Practical LLC

This is free software, licensed under:

  The GNU General Public License, Version 2, June 1991

=cut

1;
