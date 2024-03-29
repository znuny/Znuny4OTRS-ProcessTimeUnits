# --
# Copyright (C) 2012 Znuny GmbH, https://znuny.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Ticket::Event::ZnunyProcessTimeUnits;

use strict;
use warnings;
use utf8;

use Kernel::System::VariableCheck qw(:all);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::DynamicField',
    'Kernel::System::DynamicField::Backend',
    'Kernel::System::Log',
    'Kernel::System::Ticket',
    'Kernel::System::Ticket::Article',
    'Kernel::System::User',
);

sub new {
    my ( $Type, %Param ) = @_;

    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $BackendObject      = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');
    my $ConfigObject       = $Kernel::OM->Get('Kernel::Config');
    my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');
    my $LogObject          = $Kernel::OM->Get('Kernel::System::Log');
    my $TicketObject       = $Kernel::OM->Get('Kernel::System::Ticket');
    my $UserObject         = $Kernel::OM->Get('Kernel::System::User');
    my $ArticleObject      = $Kernel::OM->Get('Kernel::System::Ticket::Article');

    # check needed stuff
    NEEDED:
    for my $Needed (qw( Data Event Config UserID )) {

        next NEEDED if $Param{$Needed};

        $LogObject->Log(
            Priority => 'error',
            Message  => "Need $Needed!"
        );
        return;
    }
    NEEDED:
    for my $Needed (qw( TicketID )) {

        next NEEDED if $Param{Data}->{$Needed};

        $LogObject->Log(
            Priority => 'error',
            Message  => "Need $Needed in Data!"
        );
        return;
    }

    my $TicketID = $Param{Data}->{TicketID};

    my %Ticket = $TicketObject->TicketGet(
        TicketID      => $TicketID,
        DynamicFields => 1,
        UserID        => $Param{UserID},
    );

    return if !$Ticket{DynamicField_ProcessTimeUnits};

    my %Article           = %{ $ConfigObject->Get('ZnunyProcessTimeUnits::Article') || {} };
    my $ArticleCreateOnce = $ConfigObject->Get('ZnunyProcessTimeUnits::ArticleCreateOnce');

    my %User = $UserObject->GetUserData(
        UserID => $Param{UserID},
    );

    my $ArticleID;
    if ($ArticleCreateOnce) {
        my %Flags = $TicketObject->TicketFlagGet(
            TicketID => $TicketID,
            UserID   => 1,
        );

        if ( $Flags{ZnunyProcessTimeUnits} ) {
            $ArticleID = $Flags{ZnunyProcessTimeUnits};
        }
    }

    if ( !$ArticleID ) {
        $ArticleID = $ArticleObject->ArticleCreate(
            TicketID             => $TicketID,
            ChannelName          => 'Internal',
            IsVisibleForCustomer => 0,
            SenderType           => 'agent',
            Charset              => 'utf-8',
            MimeType             => 'text/plain',
            HistoryType          => 'AddNote',
            HistoryComment       => 'Added article for time accounting.',
            From                 => "\"$User{UserFullname}\" <$User{UserEmail}>",
            UserID               => $Param{UserID},
            %Article,
        );

        $TicketObject->TicketFlagSet(
            TicketID => $TicketID,
            Key      => 'ZnunyProcessTimeUnits',
            Value    => $ArticleID,
            UserID   => 1,
        );
    }

    $TicketObject->TicketAccountTime(
        TicketID  => $TicketID,
        ArticleID => $ArticleID,
        TimeUnit  => $Ticket{DynamicField_ProcessTimeUnits},
        UserID    => $Param{UserID},
    );

    my $DynamicFieldConfig = $DynamicFieldObject->DynamicFieldGet(
        Name => 'ProcessTimeUnits',
    );

    $BackendObject->ValueSet(
        DynamicFieldConfig => $DynamicFieldConfig,
        ObjectID           => $TicketID,
        Value              => undef,
        UserID             => $Param{UserID},
    );

    return 1;
}

1;
