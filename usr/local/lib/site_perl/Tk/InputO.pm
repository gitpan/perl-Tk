package Tk::InputO;
use vars qw($VERSION);
$VERSION = '3.013'; # $Id: //depot/Tk8/InputO/InputO.pm#13 $
use Tk qw($XS_VERSION);
use vars qw($VERSION);
$VERSION='3.013';
use base  qw(Tk::Widget);
Construct Tk::Widget 'InputO';
bootstrap Tk::InputO;
sub Tk_cmd{\&Tk::inputo}1;