package Tk::Scale;
sub ButtonDown{my$w=shift;
my$x=shift;
my$y=shift;
$Tk::dragging=0;
$el=$w->identify($x,$y);
return unless($el);
if($el eq 'trough1'){$w->Increment('up','little','initial')}elsif($el eq 'trough2'){$w->Increment('down','little','initial')}elsif($el eq 'slider'){$Tk::dragging=1;
my@coords=$w->coords();
$Tk::deltaX=$x-$coords[0];
$Tk::deltaY=$y-$coords[1];}}1;
