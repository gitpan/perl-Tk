package Tk::Clipboard;
use strict;
use vars qw($VERSION);
$VERSION = '3.016'; # $Id: //depot/Tk8/Tk/Clipboard.pm#16 $
use AutoLoader qw(AUTOLOAD);
use Tk qw(catch);
sub clipEvents{return qw[Copy Cut Paste];}sub ClassInit{my($class,$mw)=@_;
foreach my $op($class->clipEvents){$mw->Tk::bind($class,"<<$op>>","clipboard$op");}return$class;}sub clipboardSet{my$w=shift;
$w->clipboardClear;
$w->clipboardAppend(@_);}sub clipboardCopy{my$w=shift;
my$val=$w->getSelected;
if(defined$val){$w->clipboardSet('--',$val);}return$val;}sub clipboardCut{my$w=shift;
my$val=$w->clipboardCopy;
if(defined$val){$w->deleteSelected;}return$val;}sub clipboardGet{my$w=shift;
$w->SelectionGet('-selection','CLIPBOARD',@_);}sub clipboardPaste{my$w=shift;
local$@;
catch{$w->insert('insert',$w->clipboardGet)};}sub clipboardOperations{my@class=();
my$mw=shift;
if(ref$mw){$mw=$mw->DelegateFor('bind');}else{push(@class,$mw);
$mw=shift;}while(@_){my$op=shift;
$mw->Tk::bind(@class,"<<$op>>","clipboard$op");}}sub deleteSelected{my$w=shift;
catch{$w->delete('sel.first','sel.last')};}1;
__END__
sub getSelected{my$w=shift;
my$val=Tk::catch{$w->get('sel.first','sel.last')};
return$val;}
