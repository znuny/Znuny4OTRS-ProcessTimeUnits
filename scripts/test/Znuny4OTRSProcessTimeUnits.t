# --
# Copyright (C) 2012-2017 Znuny GmbH, http://znuny.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use utf8;

use vars (qw($Self));

use Kernel::System::VariableCheck qw(:all);

$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreSystemConfiguration => 1,
        RestoreDatabase            => 1,
    },
);

# get needed objects
my $BackendObject      = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');
my $ConfigObject       = $Kernel::OM->Get('Kernel::Config');
my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');
my $HelperObject       = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
my $TicketObject       = $Kernel::OM->Get('Kernel::System::Ticket');
my $ZnunyHelperObject  = $Kernel::OM->Get('Kernel::System::ZnunyHelper');

my $TicketID = $HelperObject->TicketCreate();

my $DynamicFieldConfig = $DynamicFieldObject->DynamicFieldGet(
    Name => 'ProcessTimeUnits',
);

my $Success = $BackendObject->ValueSet(
    DynamicFieldConfig => $DynamicFieldConfig,
    ObjectID           => $TicketID,
    Value              => '500',
    UserID             => 1,
);

$Self->True(
    $Success,
    "ValueSet(500)",
);

$Kernel::OM->ObjectsDiscard(
    Objects => ['Kernel::System::Ticket'],
);
$TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

my $AccountedTime = $TicketObject->TicketAccountedTimeGet( TicketID => $TicketID );

$Self->Is(
    $AccountedTime,
    500,
    "accounted time is 500",
);

my %Ticket = $TicketObject->TicketGet(
    TicketID      => $TicketID,
    DynamicFields => 1,
    UserID        => 1,
);

$Self->Is(
    $Ticket{DynamicField_ProcessTimeUnits},
    undef,
    "value of ProcessTimeUnits got set to undef after event",
);

my %ArticleConfig = %{ $ConfigObject->Get('Znuny4OTRSProcessTimeUnits::Article') || {} };

my @ArticleIndex = $TicketObject->ArticleGet(
    TicketID => $TicketID,
    UserID   => 1,
);

$Self->Is(
    $ArticleIndex[-1]->{Subject},
    $ArticleConfig{Subject},
    "check subject of time accounting article",
);

$Self->Is(
    $ArticleIndex[-1]->{Body},
    $ArticleConfig{Body},
    "check body of time accounting article",
);

1;