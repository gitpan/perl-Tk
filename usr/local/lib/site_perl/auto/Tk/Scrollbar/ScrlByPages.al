package Tk::Scrollbar;
sub ScrlByPages{my$w=shift;
my$orient=shift;
my$amount=shift;
my$cmd=$w->cget('-command');
return unless(defined$cmd);
return if(index($orient,substr($w->cget('-orient'),0,1))<0);
my@info=$w->get;
if(@info==2){$cmd->Call('scroll',$amount,'pages');}else{$cmd->Call($info[2]+$amount*($info[1]-1));}}1;
