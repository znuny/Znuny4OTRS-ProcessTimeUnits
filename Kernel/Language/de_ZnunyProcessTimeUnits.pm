# --
# Copyright (C) 2012 Znuny GmbH, https://znuny.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::de_ZnunyProcessTimeUnits;

use strict;
use warnings;

use utf8;

sub Data {
    my $Self = shift;

    $Self->{Translation}->{'This configuration registers a Ticket-EventModule that creates an article and sets the time units given in a dynamic field.'}                              = 'Diese Konfiguration definiert ein Ticket-Event-Modul, welches einen Artikel anlegt und basierend auf einem dynamischen Feld die Zeiteinheiten setzt.';
    $Self->{Translation}->{'This configuration defines the subject of the article which needs to be created to set the time units.'}                                                   = 'Diese Konfiguration definiert den Betreff des Artikels, welcher benötigt wird um die Zeiteinheiten zu setzen.';
    $Self->{Translation}->{'This configuration defines the body of the article which needs to be created to set the time units.'}                                                      = 'Diese Konfiguration definiert den Inhalt des Artikels, welcher benötigt wird um die Zeiteinheiten zu setzen.';
    $Self->{Translation}->{'This configuration defines if the article create for the time accouting should be created once and all time accountings should be added on this article.'} = 'Diese Konfiguration definiert, ob die Artikel-Erstellung für die Zeiterfassung nur einmal erstellt werden soll und all weiteren Zeiterfassungen zu dem bestehenden Artikel erstellt werden soll.';
    $Self->{Translation}->{'This configuration defines the sender type for the article which needs to be created to set the time units.'}                                              = 'Diese Konfiguration definiert den Sender-Typ des Artikels, welcher benötigt wird um die Zeiteinheiten zu setzen.';

    return 1;
}

1;
