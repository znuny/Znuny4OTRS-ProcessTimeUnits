# --
# Copyright (C) 2012-2022 Znuny GmbH, https://znuny.com/
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
        RestoreDatabase => 1,
    },
);

# get needed objects
my $BackendObject      = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');
my $ConfigObject       = $Kernel::OM->Get('Kernel::Config');
my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');
my $HelperObject       = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
my $TicketObject       = $Kernel::OM->Get('Kernel::System::Ticket');
my $ZnunyHelperObject  = $Kernel::OM->Get('Kernel::System::ZnunyHelper');
my $ArticleObject      = $Kernel::OM->Get('Kernel::System::Ticket::Article');

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

my %ArticleConfig = %{ $ConfigObject->Get('ZnunyProcessTimeUnits::Article') || {} };

my @ArticleIndex = $ArticleObject->ArticleList(
    TicketID => $TicketID,
    OnlyLast => 1,
    UserID   => 1,
);

my %LastArticle = $ArticleObject->ArticleGet(
    %{ $ArticleIndex[-1] },
    UserID => 1,
);

$Self->Is(
    $LastArticle{Subject},
    $ArticleConfig{Subject},
    "check subject of time accounting article",
);

$Self->Is(
    $LastArticle{Body},
    $ArticleConfig{Body},
    "check body of time accounting article",
);

my $ExpectedFlagArticleID = $LastArticle{ArticleID};

#
# create second article
#

$Success = $BackendObject->ValueSet(
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

$AccountedTime = $TicketObject->TicketAccountedTimeGet( TicketID => $TicketID );

$Self->Is(
    $AccountedTime,
    1000,
    "accounted time is 1000",
);

%Ticket = $TicketObject->TicketGet(
    TicketID      => $TicketID,
    DynamicFields => 1,
    UserID        => 1,
);

$Self->Is(
    $Ticket{DynamicField_ProcessTimeUnits},
    undef,
    "value of ProcessTimeUnits got set to undef after event",
);

%ArticleConfig = %{ $ConfigObject->Get('ZnunyProcessTimeUnits::Article') || {} };

@ArticleIndex = $ArticleObject->ArticleList(
    TicketID => $TicketID,
    OnlyLast => 1,
    UserID   => 1,
);

%LastArticle = $ArticleObject->ArticleGet(
    %{ $ArticleIndex[-1] },
    UserID => 1,
);

$Self->True(
    @ArticleIndex == 1 ? 1 : 0,
    'No second article got created',
);

$Self->Is(
    $LastArticle{Subject},
    $ArticleConfig{Subject},
    "check subject of time accounting article",
);

$Self->Is(
    $LastArticle{Body},
    $ArticleConfig{Body},
    "check body of time accounting article",
);

my %Flags = $TicketObject->TicketFlagGet(
    TicketID => $TicketID,
    UserID   => 1,
);

$Self->Is(
    $Flags{ZnunyProcessTimeUnits},
    $ExpectedFlagArticleID,
    'Ticket got flag with correct article id'
);

1;
