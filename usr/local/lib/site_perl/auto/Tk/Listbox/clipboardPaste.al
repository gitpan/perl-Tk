package Tk::Listbox;
sub clipboardPaste{my$w=shift;
my$index=$w->index('active')||$w->index($w->XEvent->xy);
my$str;
eval{local$SIG{__DIE__};$str=$w->clipboardGet};
return if$@;
foreach(split("\n",$str)){$w->insert($index++,$_);}}1;
