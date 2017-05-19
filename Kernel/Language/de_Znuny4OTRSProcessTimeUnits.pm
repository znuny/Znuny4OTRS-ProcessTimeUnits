# --
# Copyright (C) 2012-2017 Znuny GmbH, http://znuny.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::de_Znuny4OTRSProcessTimeUnits;

use strict;
use warnings;

use utf8;

sub Data {
    my $Self = shift;

    $Self->{Translation}->{'This configuration registers a Ticket-EventModule that creates an article and sets the time units given in a dynamic field.'} = 'Diese Konfiguration definiert ein Ticket-Event-Modul, welches einen Artikel anlegt und basierend auf einem dynamischen Feld die Zeiteinheiten setzt.';
    $Self->{Translation}->{'This configuration defines the subject of the article which needs to be created to set the time units.'}                      = 'Diese Konfiguration definiert den Betreff des Artikels, welcher benötigt wird um die Zeiteinheiten zu setzen.';
    $Self->{Translation}->{'This configuration defines the body of the article which needs to be created to set the time units.'}                         = 'Diese Konfiguration definiert den Inhalt des Artikels, welcher benötigt wird um die Zeiteinheiten zu setzen.';

    return 1;
}

1;
