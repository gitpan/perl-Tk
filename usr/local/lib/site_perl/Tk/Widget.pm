package Tk::Widget;
use vars qw($VERSION @DefaultMenuLabels);
$VERSION = '3.078'; # $Id: //depot/Tk8/Tk/Widget.pm#78 $
require Tk;
use AutoLoader;
use strict;
use Carp;
use base qw(DynaLoader Tk);
sub Button;
sub Canvas;
sub Checkbutton;
sub Entry;
sub Frame;
sub Label;
sub Listbox;
sub Menu;
sub Menubutton;
sub Message;
sub Scale;
sub Scrollbar;
sub Radiobutton;
sub Text;
sub Toplevel;
sub Pixmap;
sub Bitmap;
sub Photo;
sub ScrlListbox;
sub Optionmenu;
sub import{my$package=shift;
carp 'use Tk::Widget () to pre-load widgets is deprecated' if(@_);
my$need;
foreach$need(@_){unless(defined&{$need}){require"Tk/${need}.pm";}croak"Cannot locate $need" unless(defined&{$need});}}@DefaultMenuLabels=qw[~File ~Help];
sub True{1}sub False{0}use Tk::Submethods('grab'=>[qw(current status release -global)],'focus'=>[qw(-force -lastfor)],'pack'=>[qw(configure forget info propagate slaves)],'grid'=>[qw(bbox columnconfigure configure forget info location propagate rowconfigure size slaves)],'form'=>[qw(check configure forget grid info slaves)],'event'=>[qw(add delete generate info)],'place'=>[qw(configure forget info slaves)],'wm'=>[qw(capture release)],'font'=>[qw(actual configure create delete families measure metrics names)]);
BEGIN{*IsMenu=\&False;
*IsMenubutton=\&False;
*configure_self=\&Tk::configure;
*cget_self=\&Tk::cget;}Direct Tk::Submethods('winfo'=>[qw(cells class colormapfull depth exists
geometry height id ismapped manager name parent reqheight
reqwidth rootx rooty screen screencells screendepth screenheight
screenmmheight screenmmwidth  screenvisual screenwidth visual
visualsavailable  vrootheight viewable vrootwidth vrootx vrooty
width x y toplevel children pixels pointerx pointery pointerxy
server fpixels rgb )],'tk'=>[qw(appname scaling)]);
sub DESTROY{my$w=shift;
$w->destroy if($w->IsWidget);}sub Install{my($package,$mw)=@_;}sub ClassInit{my($package,$mw)=@_;
return$package;}sub CreateOptions{return();}sub CreateArgs{my($package,$parent,$args)=@_;
my@result=();
my$class=delete$args->{'-class'};
($class)=$package=~/([A-Z][A-Z0-9_]*)$/i unless(defined$class);
push(@result,'-class'=>"\u$class")if(defined$class);
foreach my $opt($package->CreateOptions){push(@result,$opt=>delete$args->{$opt})if exists$args->{$opt};}return@result;}sub InitObject{my($obj,$args)=@_;}sub SetBindtags{my($obj)=@_;
$obj->bindtags([ref($obj),$obj,$obj->toplevel,'all']);}sub new{local$SIG{'__DIE__'}=\&Carp::croak;
my$package=shift;
my$parent=shift;
$package->InitClass($parent);
$parent->BackTrace("Odd number of args to $package->new(...)")unless((@_%2)==0);
my%args=@_;
my@args=$package->CreateArgs($parent,\%args);
my$cmd=$package->Tk_cmd;
my$pname=$parent->PathName;
$pname='' if($pname eq '.');
my$leaf=delete$args{'Name'};
if(defined$leaf){$leaf=~s/[^a-z0-9_]+/_/ig;
$leaf=lcfirst($leaf);}else{($leaf)="\L$package"=~/([a-z][a-z0-9_]*)$/;}my$lname=$pname.'.'.$leaf;
my$nhash=$parent->TkHash('_names_');
$nhash->{$leaf}=0 unless(exists$nhash->{$leaf});
while(defined($parent->Widget($lname))){$lname=$pname.'.'.$leaf. ++$nhash->{$leaf};}my$obj=eval{&$cmd($parent,$lname,@args)};
confess$@ if $@;
bless$obj,$package;
$obj->SetBindtags;
my$notice=$parent->can('NoticeChild');
$parent->$notice($obj,\%args)if$notice;
$obj->InitObject(\%args);
$obj->configure(%args)if(%args);
return$obj;}sub DelegateFor{my($w,$method)=@_;
while(exists$w->{'Delegates'}){my$delegate=$w->{'Delegates'};
my$widget=$delegate->{$method};
$widget=$delegate->{DEFAULT}unless(defined$widget);
$widget=$w->Subwidget($widget)if(defined$widget&&!ref$widget);
last unless(defined$widget);
last if$widget==$w;
$w=$widget;}return$w;}sub Delegates{my$cw=shift;
my$specs=$cw->TkHash('Delegates');
while(@_){my$key=shift;
my$val=shift;
$specs->{$key}=$val;}return$specs;}sub Construct{my($base,$name)=@_;
my$class=(caller(0))[0];
no strict 'refs';
delete${"$class\::"}{'::ISA::CACHE::'}if$]==5.006;
*{$base.'::Is'.$name}=\&False;
*{$class.'::Is'.$name}=\&True;
*{$base.'::'."$name"}=sub{$class->new(shift->DelegateFor('Construct'),@_)};}sub IS{return(defined$_[1])&&$_[0]==$_[1];}sub _AutoloadTkWidget{my($self,$method)=@_;
my$what="Tk::Widget::$method";
unless(defined&$what){require"Tk/$method.pm";}return$what;}require UNIVERSAL;
sub AUTOLOAD{my$what=$Tk::Widget::AUTOLOAD;
my$save=$@;
my$name;
{my($pkg,$func)=$what=~/(.*)::([^:]+)$/;
confess("Attempt to load '$what'")unless defined($pkg)&&$func=~/^[\w:]+$/;
$pkg=~s#::#/#g;
if(defined($name=$INC{"$pkg.pm"})){$name=~s#^(.*)$pkg\.pm$#$1auto/$pkg/$func.al#;}else{$name="auto/$what.al";
$name=~s#::#/#g;}}eval{local$SIG{'__DIE__'};require$name};
if($@){croak$@ unless ($@=~/Can't locate\s+(?:file\s+)?'?\Q$name\E'?/);
my($package,$method)=($what=~/^(.*)::([^:]*)$/);
if(ref$_[0]&&!$_[0]->can($method)&&$_[0]->can('Delegate')&&$method!~/^(ConfigSpecs|Delegates)/){my$delegate=$_[0]->Delegates;
if(%$delegate||tied%$delegate){my$widget=$delegate->{$method};
$widget=$delegate->{DEFAULT}unless(defined$widget);
if(defined$widget){my$subwidget=(ref$widget)?$widget:$_[0]->Subwidget($widget);
if(defined$subwidget){no strict 'refs';
*{$what}=sub{shift->Delegate($method,@_)};}else{croak"No delegate subwidget '$widget' for $what";}}}}if(!defined(&$what)&&$method=~/^[A-Z]\w+$/){my$sub=UNIVERSAL::can($_[0],'_AutoloadTkWidget');
if($sub){carp"Assuming 'require Tk::$method;'" unless$_[0]->can($method);
$what=$_[0]->$sub($method)}}}$@=$save;
$DB::sub=$what;
unless(defined&$what){no strict 'refs';
*{$what}=sub{croak("Failed to AUTOLOAD '$what'")};}goto&$what;}sub _Destroyed{my$w=shift;
my$a=delete$w->{'_Destroy_'};
if(ref($a)){while(@$a){my$ent=pop(@$a);
if(ref$ent){eval{local$SIG{'__DIE__'};$ent->Call};}else{delete$w->{$ent};}}}}sub _OnDestroy{my$w=shift;
$w->{'_Destroy_'}=[]unless(exists$w->{'_Destroy_'});
push(@{$w->{'_Destroy_'}},@_);}sub OnDestroy{my$w=shift;
$w->_OnDestroy(Tk::Callback->new(@_));}sub TkHash{my($w,$key)=@_;
return$w->{$key}if exists$w->{$key};
my$hash=$w->{$key}={};
$w->_OnDestroy($key);
return$hash;}sub privateData{my$w=shift;
my$p=shift||caller;
$w->{$p}||={};}my@image_types;
my%image_method;
sub ImageMethod{shift if(@_&1);
while(@_){my($name,$method)=splice(@_,0,2);
push(@image_types,$name);
$image_method{$name}=$method;}}sub Getimage{my($w,$name)=@_;
my$mw=$w->MainWindow;
croak"Usage \$widget->Getimage('name')" unless defined($name);
my$images=($mw->{'__Images__'}||={});
return$images->{$name}if$images->{$name};
ImageMethod(xpm=>'Pixmap',gif=>'Photo',ppm=>'Photo',xbm=>'Bitmap')unless@image_types;
foreach my $type(@image_types){my$method=$image_method{$type};
my$file=Tk->findINC("$name.$type");
next unless($file&&$method);
my$sub=$w->can($method);
unless(defined&$sub){require Tk::widgets;
Tk::widgets->import($method);}$images->{$name}=$w->$method(-file=>$file);
return$images->{$name};}$images->{$name}=$w->Pixmap(-id=>$name);
return$images->{$name};}sub SaveGrabInfo{my$w=shift;
$Tk::oldGrab=$w->grabCurrent;
if(defined$Tk::oldGrab){$Tk::grabStatus=$Tk::oldGrab->grabStatus;}}sub grabSave{my($w)=@_;
my$grab=$w->grabCurrent;
return sub{}if(!defined$grab);
my$method=($grab->grabStatus eq 'global')?'grabGlobal':'grab';
return sub{eval{local$SIG{'__DIE__'};$grab->$method()}};}sub focusCurrent{my($w)=@_;
$w->Tk::focus('-displayof');}sub focusSave{my($w)=@_;
my$focus=$w->focusCurrent;
return sub{}if(!defined$focus);
return sub{eval{local$SIG{'__DIE__'};$focus->focus}};}require Tk::After;
sub afterIdle{my$w=shift;
return Tk::After->new($w,'idle','once',@_);}sub afterCancel{my($w,$what)=@_;
if(defined$what){return$what->cancel if ref($what);
carp"dubious cancel of $what" if 0&&$^W;
$w->Tk::after('cancel'=>$what);}}sub after{my$w=shift;
my$t=shift;
if(@_){if($t ne 'cancel'){require Tk::After;
return Tk::After->new($w,$t,'once',@_)}while(@_){my$what=shift;
$w->afterCancel($what);}}else{$w->Tk::after($t);}}sub repeat{require Tk::After;
my$w=shift;
my$t=shift;
return Tk::After->new($w,$t,'repeat',@_);}sub FindMenu{return undef;}sub XEvent{shift->{'_XEvent_'}}sub propertyRoot{my$w=shift;
return$w->property(@_,'root');}sub atom{shift->InternAtom(@_)}sub atomname{shift->GetAtomName(@_)}sub containing{shift->Containing(@_)}sub Walk{my($cw,$proc,@args)=@_;
my$subwidget;
foreach$subwidget($cw->children){$subwidget->Walk($proc,@args);
&$proc($subwidget,@args);}}sub Descendants{my($widget,$class)=@_;
my(@widget_tree)=();
$widget->Walk(sub{my($widget,$list,$class)=@_;
push(@$list,$widget)if(!defined($class)or$class eq$widget->class);},\@widget_tree,$class);
return@widget_tree;}sub Palette{my$w=shift->MainWindow;
unless(exists$w->{_Palette_}){my%Palette=();
my$c=$w->Checkbutton();
my$e=$w->Entry();
my$s=$w->Scrollbar();
$Palette{'activeBackground'}=($c->configure('-activebackground'))[3];
$Palette{'activeForeground'}=($c->configure('-activeforeground'))[3];
$Palette{'background'}=($c->configure('-background'))[3];
$Palette{'disabledForeground'}=($c->configure('-disabledforeground'))[3];
$Palette{'foreground'}=($c->configure('-foreground'))[3];
$Palette{'highlightBackground'}=($c->configure('-highlightbackground'))[3];
$Palette{'highlightColor'}=($c->configure('-highlightcolor'))[3];
$Palette{'insertBackground'}=($e->configure('-insertbackground'))[3];
$Palette{'selectColor'}=($c->configure('-selectcolor'))[3];
$Palette{'selectBackground'}=($e->configure('-selectbackground'))[3];
$Palette{'selectForeground'}=($e->configure('-selectforeground'))[3];
$Palette{'troughColor'}=($s->configure('-troughcolor'))[3];
$c->destroy;
$e->destroy;
$s->destroy;
$w->{_Palette_}=\%Palette;}return$w->{_Palette_};}sub setPalette{my$w=shift->MainWindow;
my%new=(@_==1)?(background=>$_[0]):@_;
my$priority=delete($new{'priority'})||'widgetDefault';
die 'must specify a background color' if(!exists$new{background});
$new{'foreground'}='black' unless(exists$new{foreground});
my@bg=$w->rgb($new{'background'});
my@fg=$w->rgb($new{'foreground'});
my$darkerBg=sprintf('#%02x%02x%02x',9*$bg[0]/2560,9*$bg[1]/2560,9*$bg[2]/2560);
foreach my $i('activeForeground','insertBackground','selectForeground','highlightColor'){$new{$i}=$new{'foreground'}unless(exists$new{$i});}unless(exists$new{'disabledForeground'}){$new{'disabledForeground'}=sprintf('#%02x%02x%02x',(3*$bg[0]+$fg[0])/1024,(3*$bg[1]+$fg[1])/1024,(3*$bg[2]+$fg[2])/1024);}$new{'highlightBackground'}=$new{'background'}unless(exists$new{'highlightBackground'});
unless(exists$new{'activeBackground'}){my@light;
foreach my $i(0,1,2){$light[$i]=$bg[$i]/256;
my$inc1=$light[$i]*15/100;
my$inc2=(255-$light[$i])/3;
if($inc1>$inc2){$light[$i]+=$inc1}else{$light[$i]+=$inc2}$light[$i]=255 if($light[$i]>255);}$new{'activeBackground'}=sprintf('#%02x%02x%02x',@light);}$new{'selectBackground'}=$darkerBg unless(exists$new{'selectBackground'});
$new{'troughColor'}=$darkerBg unless(exists$new{'troughColor'});
$new{'selectColor'}='#b03060' unless(exists$new{'selectColor'});
my$Palette=$w->Palette;
$w->RecolorTree(\%new);
foreach my $option(keys%new){$w->option('add',"*$option",$new{$option},$priority);
$Palette->{$option}=$new{$option};}}sub RecolorTree{my($w,$colors)=@_;
local($@);
my$Palette=$w->Palette;
foreach my $dbOption(keys%$colors){my$option="-\L$dbOption";
my$value;
eval{local$SIG{'__DIE__'};$value=$w->cget($option)};
if(defined$value){if($value eq$Palette->{$dbOption}){$w->configure($option,$colors->{$dbOption});}}}foreach my $child($w->children){$child->RecolorTree($colors);}}sub Darken{my($w,$color,$percent)=@_;
my@l=$w->rgb($color);
my$red=$l[0]/256;
my$green=$l[1]/256;
my$blue=$l[2]/256;
$red=int($red*$percent/100);
$red=255 if($red>255);
$green=int($green*$percent/100);
$green=255 if($green>255);
$blue=int($blue*$percent/100);
$blue=255 if($blue>255);
sprintf('#%02x%02x%02x',$red,$green,$blue)}sub bisque{shift->setPalette('activeBackground'=>'#e6ceb1','activeForeground'=>'black','background'=>'#ffe4c4','disabledForeground'=>'#b0b0b0','foreground'=>'black','highlightBackground'=>'#ffe4c4','highlightColor'=>'black','insertBackground'=>'black','selectColor'=>'#b03060','selectBackground'=>'#e6ceb1','selectForeground'=>'black','troughColor'=>'#cdb79e');}sub PrintConfig{require Tk::Pretty;
my($w)=(@_);
my$c;
foreach$c($w->configure){print Tk::Pretty::Pretty(@$c),"\n";}}sub BusyRecurse{my($restore,$w,$cursor,$recurse,$top)=@_;
my$c=$w->cget('-cursor');
my@tags=$w->bindtags;
if($top||defined($c)){push(@$restore,sub{$w->configure(-cursor=>$c);$w->bindtags(\@tags)});
$w->configure(-cursor=>$cursor);}else{push(@$restore,sub{$w->bindtags(\@tags)});}$w->bindtags(['Busy',@tags]);
if($recurse){foreach my $child($w->children){BusyRecurse($restore,$child,$cursor,1,0);}}return$restore;}sub Busy{my($w,%args)=@_;
return unless$w->viewable;
my$cursor=delete$args{'-cursor'};
my$recurse=delete$args{'-recurse'};
$cursor='watch' unless defined$cursor;
unless(exists$w->{'Busy'}){my@old=($w->grabSave);
my$key;
my@config;
foreach$key(keys%args){push(@config,$key=>$w->Tk::cget($key));}if(@config){push(@old,sub{$w->Tk::configure(@config)});
$w->Tk::configure(%args);}unless($w->Tk::bind('Busy')){$w->Tk::bind('Busy','<Any-KeyPress>',[_busy=>1]);
$w->Tk::bind('Busy','<Any-KeyRelease>',[_busy=>0]);
$w->Tk::bind('Busy','<Any-ButtonPress>',[_busy=>1]);
$w->Tk::bind('Busy','<Any-ButtonRelease>',[_busy=>0]);
$w->Tk::bind('Busy','<Any-Motion>',[_busy=>0]);}$w->{'Busy'}=BusyRecurse(\@old,$w,$cursor,$recurse,1);}my$g=$w->grabCurrent;
if(defined$g){$g->grabRelease;}$w->update;
eval{local$SIG{'__DIE__'};$w->grab};
$w->update;}sub _busy{my($w,$f)=@_;
$w->bell if$f;
$w->break;}sub Unbusy{my($w)=@_;
$w->update;
$w->grabRelease;
my$old=delete$w->{'Busy'};
if(defined$old){local$SIG{'__DIE__'};
eval{&{pop(@$old)}}while(@$old);}$w->update;}sub waitVisibility{my($w)=shift;
$w->tkwait('visibility',$w);}sub waitVariable{my($w)=shift;
$w->tkwait('variable',@_);}sub waitWindow{my($w)=shift;
$w->tkwait('window',$w);}sub EventWidget{my($w)=@_;
return$w->{'_EventWidget_'};}sub Popwidget{my($ew,$method,$w,@args)=@_;
$w->{'_EventWidget_'}=$ew;
$w->$method(@args);}sub ColorOptions{my($w,$args)=@_;
my$opt;
$args={}unless(defined$args);
foreach$opt(qw(-foreground -background -disabledforeground
-activebackground -activeforeground
)){$args->{$opt}=$w->cget($opt)unless(exists$args->{$opt})}return(wantarray)?%$args:$args;}sub XscrollBind{my($mw,$class)=@_;
$mw->bind($class,'<Left>',['xview','scroll',-1,'units']);
$mw->bind($class,'<Control-Left>',['xview','scroll',-1,'pages']);
$mw->bind($class,'<Control-Prior>',['xview','scroll',-1,'pages']);
$mw->bind($class,'<Right>',['xview','scroll',1,'units']);
$mw->bind($class,'<Control-Right>',['xview','scroll',1,'pages']);
$mw->bind($class,'<Control-Next>',['xview','scroll',1,'pages']);
$mw->bind($class,'<Home>',['xview','moveto',0]);
$mw->bind($class,'<End>',['xview','moveto',1]);}sub PriorNextBind{my($mw,$class)=@_;
$mw->bind($class,'<Next>',['yview','scroll',1,'pages']);
$mw->bind($class,'<Prior>',['yview','scroll',-1,'pages']);}sub YscrollBind{my($mw,$class)=@_;
$mw->PriorNextBind($class);
$mw->bind($class,'<Up>',['yview','scroll',-1,'units']);
$mw->bind($class,'<Down>',['yview','scroll',1,'units']);}sub XYscrollBind{my($mw,$class)=@_;
$mw->YscrollBind($class);
$mw->XscrollBind($class);}sub ScrlListbox{my$parent=shift;
return$parent->Scrolled('Listbox',-scrollbars=>'w',@_);}sub AddBindTag{my($w,$tag)=@_;
my$t;
my@tags=$w->bindtags;
foreach$t(@tags){return if$t eq$tag;}$w->bindtags([@tags,$tag]);}sub Callback{my$w=shift;
my$name=shift;
my$cb=$w->cget($name);
if(defined$cb){return$cb->Call(@_)if(ref$cb);
return$w->$cb(@_);}return(wantarray)?():undef;}sub packAdjust{require Tk::Adjuster;
my($w,%args)=@_;
my$delay=delete($args{'-delay'});
$delay=1 unless(defined$delay);
$w->pack(%args);
%args=$w->packInfo;
my$adj=Tk::Adjuster->new($args{'-in'},-widget=>$w,-delay=>$delay,-side=>$args{'-side'});
$adj->packed($w,%args);
return$w;}sub gridAdjust{require Tk::Adjuster;
my($w,%args)=@_;
my$delay=delete($args{'-delay'});
$delay=1 unless(defined$delay);
$w->grid(%args);
%args=$w->gridInfo;
my$adj=Tk::Adjuster->new($args{'-in'},-widget=>$w,-delay=>$delay);
$adj->gridded($w,%args);
return$w;}sub place{local$SIG{'__DIE__'}=\&Carp::croak;
my$w=shift;
if(@_&&$_[0]=~/^(?:configure|forget|info|slaves)$/x){$w->Tk::place(@_);}else{$w->Tk::place('configure',@_);
return$w;}}sub pack{local$SIG{'__DIE__'}=\&Carp::croak;
my$w=shift;
if(@_&&$_[0]=~/^(?:configure|forget|info|propagate|slaves)$/x){$w->Tk::pack(@_);}else{$w->Tk::pack('configure',@_);
return$w;}}sub grid{local$SIG{'__DIE__'}=\&Carp::croak;
my$w=shift;
if(@_&&$_[0]=~/^(?:bbox|columnconfigure|configure|forget|info|location|propagate|rowconfigure|size|slaves)$/x){my$opt=shift;
Tk::grid($opt,$w,@_);}else{Tk::grid('configure',$w,@_);
return$w;}}sub form{local$SIG{'__DIE__'}=\&Carp::croak;
my$w=shift;
if(@_&&$_[0]=~/^(?:configure|check|forget|grid|info|slaves)$/x){$w->Tk::form(@_);}else{$w->Tk::form('configure',@_);
return$w;}}sub Scrolled{my($parent,$kind,%args)=@_;
my@args=Tk::Frame->CreateArgs($parent,\%args);
my$name=delete$args{'Name'};
push(@args,'Name'=>$name)if(defined$name);
my$cw=$parent->Frame(@args);
@args=();
foreach my $k('-scrollbars',map($_->[0],$cw->configure)){push(@args,$k,delete($args{$k}))if(exists$args{$k})}my$w=$cw->$kind(%args);
%args=@args;
$cw->ConfigSpecs('-scrollbars'=>['METHOD','scrollbars','Scrollbars','se'],'-background'=>[$w,'background','Background'],'-foreground'=>[$w,'foreground','Foreground'],);
$cw->AddScrollbars($w);
$cw->Default("\L$kind"=>$w);
$cw->Delegates('bind'=>$w,'bindtags'=>$w,'menu'=>$w);
$cw->ConfigDefault(\%args);
$cw->configure(%args);
return$cw;}sub Populate{my($cw,$args)=@_;}sub ForwardEvent{my$self=shift;
my$to=shift;
$to->PassEvent($self->XEvent);}sub EventType{my$w=shift;
$w->{'_EventType_'}=$_[0]if@_;
return$w->{'_EventType_'};}sub PostPopupMenu{my($w,$X,$Y)=@_;
if(@_<3){my$e=$w->XEvent;
$X=$e->X;
$Y=$e->Y;}my$menu=$w->menu;
$menu->Post($X,$Y)if defined$menu;}sub FillMenu{my($w,$menu,@labels)=@_;
foreach my $lab(@labels){my$method=$lab.'MenuItems';
$method=~s/~//g;
$method=~s/[\s-]+/_/g;
if($w->can($method)){$menu->Menubutton(-label=>$lab,-tearoff=>0,-menuitems=>$w->$method());}}return$menu;}sub menu{my($w,$menu)=@_;
if(@_>1){$w->_OnDestroy('_MENU_')unless exists$w->{'_MENU_'};
$w->{'_MENU_'}=$menu;}return unless defined wantarray;
unless(exists$w->{'_MENU_'}){$w->_OnDestroy('_MENU_');
$w->{'_MENU_'}=$menu=$w->Menu(-tearoff=>0);
$w->FillMenu($menu,$w->MenuLabels);}return$w->{'_MENU_'};}sub MenuLabels{return@DefaultMenuLabels;}sub FileMenuItems{my($w)=@_;
return[["command"=>'E~xit',-command=>[$w,'WmDeleteWindow']]];}sub WmDeleteWindow{shift->toplevel->WmDeleteWindow}sub BalloonInfo{my($widget,$balloon,$X,$Y,@opt)=@_;
foreach my $opt(@opt){my$info=$balloon->GetOption($opt,$widget);
return$info if defined$info;}}1;
__END__
sub ASkludge{my($hash,$sense)=@_;
foreach my $key(%$hash){if($key=~/-.*variable/&&ref($hash->{$key})eq 'SCALAR'){if($sense){my$val=${$hash->{$key}};
require Tie::Scalar;
tie${$hash->{$key}},'Tie::StdScalar';
${$hash->{$key}}=$val;}else{untie${$hash->{$key}};}}}}sub clipboardKeysyms{my@class=();
my$mw=shift;
if(ref$mw){$mw=$mw->DelegateFor('bind');}else{push(@class,$mw);
$mw=shift;}if(@_){my$copy=shift;
$mw->Tk::bind(@class,"<$copy>",'clipboardCopy')if(defined$copy);}if(@_){my$cut=shift;
$mw->Tk::bind(@class,"<$cut>",'clipboardCut')if(defined$cut);}if(@_){my$paste=shift;
$mw->Tk::bind(@class,"<$paste>",'clipboardPaste')if(defined$paste);}}sub pathname{my($w,$id)=@_;
my$x=$w->winfo('pathname',-displayof=>oct($id));
return$x->PathName;}
