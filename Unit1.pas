unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, TeEngine, Series, TeeProcs, Chart;

type
  TForm1 = class(TForm)
    img_move: TImage;
    chrt: TChart;
    Series1: TBarSeries;
    le_T: TLabeledEdit;
    gb_par: TGroupBox;
    rg_m: TRadioGroup;
    btn_start: TButton;
    cb_theor: TCheckBox;
    le_nz: TLabeledEdit;
    Button1: TButton;
    Series2: TLineSeries;
    Edit1: TEdit;
    Edit2: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    procedure dot(x,y:integer;c:TColor);
    procedure dot2(x,y:integer; c:TColor);
    procedure Init;
    procedure btn_startClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
   
  private
    { Private declarations }
  public
    { Public declarations }
  end;

const
  space_size = 300;  {must be 2^i-1  }
  //nat = 60;         {n‡Ú - number of atoms}


type TAtom = record
  x,y: integer;     {coordinates}
  vx,vy: real;  {velocity}   rx,ry: real;   {coordinates}
  num : integer;
end;

var
  Form1: TForm1;
  y: array [0..400] of integer;
  yp,f: array [0..400] of real;
  Atoms: array [0..200] of TAtom;
  i,j,color,a1,b1,temp:integer;
  nt,ny :longint;
  nt1:string;
  deltatau,VT2,T,T1,strikes:  real;
  {time step, rms speed, temperature}
  kv, k, mol_m:real; dv,nat:byte;   {mol_m - molar mass}
  ps: boolean;

implementation

{$R *.dfm}

procedure TForm1.dot(x,y:integer; c:TColor);
begin
  img_move.Canvas.Pixels[x,y];
end;

procedure TForm1.dot2(x,y:integer; c:TColor);
var
  col:TColor;
begin
  col:=img_move.Canvas.Pen.Color;
  img_move.Canvas.Brush.Color := c;
  img_move.Canvas.Pen.Color := clWhite;
  img_move.Canvas.Ellipse(x-3, y-3, x+3,y+3);
  img_move.Canvas.Pen.Color := col;
end;

procedure TForm1.Init;
var
  ready:boolean;
  angle,speed: real;
begin	{speed - rms speed}
   for i := 0 to 400 do y[i]:=0;
   ny:=1;
  speed :=sqrt(3*8.31*T/mol_m)*2e10; {*2e10 - translate in a pixel}

  for i:=0 to nat do
begin   ps := false;
  repeat atoms[i].x:= random(space_size);
  {whole random coordinates}
  atoms[i].y:= random(space_size);
  atoms[i].rx := atoms[i].x; {valid coordinates}
  atoms[i].ry := atoms[i].y;
  angle := random;	{random direction of the velocity vector}
  atoms[i].vx :=   cos(angle*2*pi)* speed;
  atoms[i].vy :=   sin(angle*2*pi)* speed;      ready := true;
  for j:=0 to i-1 do
    if (sqr(atoms[i].x-atoms[j].x)+sqr(atoms[i].y-atoms[j].y))<sqr(8) then
    begin
     ready := false; break;
    end;
  until ready ;
end;
end;

procedure CalcBump(a,b:integer); {impact calculation}
var
  dx,dy,dz,x1,y1,x2,y2,dr,dd,vcx,vcy,vx1,vx2,vy1,vy2,dvx1,
  dvx2,dvy1,dvy2,dxd,dyd,v1n,v2n,dt:  real;
 // strikes: integer;

  bx,by,bb: byte;
Begin
  dx:=atoms[b].rx - atoms[a].rx;
  dy:=atoms[b].ry - atoms[a].ry;
  dd :=dx*dx+dy*dy;	{squared distance bettwen atoms}
   if dd<=36 then
   begin {6 pixel*6 pixel
          =3 angstrem * 3angstrem}
    strikes:=strikes+1;
    Form1.Label2.Caption:='Number of strikes '+inttostr(round(strikes));
    dt:=deltatau*0.5;
    x1:=atoms[a].rx-atoms[a].vx*dt; {return to the past to find the distance before the collision}
    x2:=atoms[b].rx-atoms[b].vx*dt;
    y1:=atoms[a].ry-atoms[a].vy*dt;
    y2:=atoms[b].ry-atoms[b].vy*dt;
    dx:=x2-x1;  dy:=y2-y1;
    dd :=sqrt(dx*dx+dy*dy);
    vcx:=0.5*(atoms[a].vx+atoms[b].vx); {center of mass velocity}
    vcy:=0.5*(atoms[a].vy+atoms[b].vy);
    Vx1:= atoms[a].vx-vcx;  {velocity relative to the center of mass}
    Vy1:= atoms[a].vy-vcy;
    dxd:=dx/dd; dyd:=dy/dd;  {cos of angles to the line of collision}
    dvx1:=vx1*dxd;   dvy1:=vy1*dyd;
    v1n:=dvx1+dvy1; {velocity component towards the center of nass}
  if v1n>0 then
  begin
    dvx2:=v1n*dxd;
    dvy2:=v1n*dyd;

    dvx1:= -dvx2;
    dvy1:= -dvy2;
  end;  {out of the  cen-tre}
    atoms[a].vx := atoms[a].vx + 2*dvx1;{new velocity}
    atoms[a].vy := atoms[a].vy + 2*dvy1;
    atoms[b].vx := atoms[b].vx + 2*dvx2;
    atoms[b].vy := atoms[b].vy + 2*dvy2;
    a1:=a; b1:=b;
    atoms[a].rx:=x1;
    atoms[b].rx:=x2;
    atoms[a].ry:=y1;atoms[b].ry:=y2;
   end;
end;

procedure Movement;
var
  j,i: integer;
  v:real;
label 1;
Begin
//strikes:=0;
for i:=0 to nat do
begin
  if {(i=a1) or} (i=b1) then Goto 1;
    for j:=0 to nat do
    if (j<>i) then begin calcbump(i,j);

    end;

1:Form1.Dot2(atoms[i].x ,atoms[i].y,clWhite);
  atoms[i].rx:=atoms[i].rx+atoms[i].vx*deltatau;
  atoms[i].ry:=atoms[i].ry + atoms[i].vy*deltatau;

if (atoms[i].rx<2) then
  begin  {wall bumps}
  atoms[i].rx:=atoms[i].rx+0.2;
  atoms[i].vx:= -atoms[i].vx;
  end;
if (atoms[i].ry<2) then
  begin
  atoms[i].ry:= atoms[i].ry+0.2;
  atoms[i].vy:= -atoms[i].vy;
  end;
if (atoms[i].rx>(space_size-1)) then
  begin
  atoms[i].rx:= atoms[i].rx-0.2;
  atoms[i].vx:= -atoms[i].vx;
  end;
if (atoms[i].ry>=(space_size-1)) then
  begin
  atoms[i].ry:= atoms[i].ry-0.2;
  atoms[i].vy:= -atoms[i].vy;
  end;
atoms[i].x := trunc(atoms[i].rx);
atoms[i].y := trunc(atoms[i].ry);

Form1.Dot2(atoms[i].x, atoms[i].y, clRed);
v:=sqrt(sqr(atoms[i].vx)+sqr(atoms[i].vy));
form1.Canvas.Pen.Color ;
if nt mod 10 = 0 then   form1.img_move.Canvas.Pixels[
       round(atoms[i].x-5*atoms[i].vx/v),
       round(atoms[i].y-5*atoms[i].vy/v)] := clGreen;
 if (nt mod 10 = 0) and (i=50) then  
    with  form1.img_move.Canvas  do begin
      moveto(atoms[i].x,atoms[i].y);
       pen.color:=clblue;
       lineto(
        round(atoms[i].x +atoms[i].vx*deltatau*100),
       round(atoms[i].y+atoms[i].vy*deltatau*100));
   end;
end;
end;

{function f(x:integer):real;
begin
  f:= mol_m/(2*pi*8.31*T1)*exp(-mol_m*x*x*dV*dV/(2*8.31*T1))
  *2*pi*x*dV;
end; }

procedure Gistograma;
{show particle velocity distribution}
var
  ik,j,i: integer;  max: real;
begin
        for i:=0 to 200 do
        yp[i]:=y[i]/ny;

form1.chrt.Series[0].Clear;
form1.chrt.Series[1].Clear;
if form1.cb_theor.Checked then  begin
for i := 0 to 200 do
f[i]:= mol_m/(2*pi*8.31*T1)*exp(-mol_m*i*i*dV*dV/(2*8.31*T1))
  *2*pi*i*dV;  //(m/2pi kT)exp(-mV**2/2kT)2pi v dv
for i := 0 to 200 do//round(form1.chrt.BottomAxis.maximum) do
form1.chrt.series[1].AddXY(i*dV,f[i]*dV,'',clRed);
end;
for i:=0 to 200 do {Histogram display}
  if yp[i]>0 then
  form1.chrt.Series[0].AddXY(i*dV,yp[i],'',0);
end;


procedure TForm1.btn_startClick(Sender: TObject);
var
p:int64;
begin

strikes:=0;
nt:=0;


 if form1.btn_start.Caption= 'Start' then
 form1.btn_start.caption := 'Stop';
if form1.btn_start.Caption= 'Stop' then  form1.btn_start.caption := 'Start';
case rg_m.ItemIndex of
    0:mol_m := 0.028;
    1:mol_m := 0.032;
    2:mol_m := 0.040;
end;
T:=strtofloat(le_T.Text);
p:= strtoint(le_nz.text);
nat:= strtoint(Edit1.Text);   Init;
if p <> dV then
dV:=p;
btn_start.Tag := 1 - btn_start.Tag;
 if btn_start.Tag = 0 then exit;
while (btn_start.Tag = 1) do

begin
  Movement;
  nt:=nt+1;

  Application.ProcessMessages;
  form1.Caption := inttostr(nt);
  form1.label1.Caption:= 'Time ' + floattostr(nt*deltatau);
  if nt >0 then nt1:=form1.label1.Caption;
  if nt=0 then   form1.label1.Caption:=nt1;
if nt mod 250=0 then
begin vt2:=0;
  for i:=1 to nat do
  VT2:=vt2+0.25*(atoms[i].vx*1E-20*atoms[i].vx+atoms[i].vy*1E-20*atoms[i].vy);
  vt2:=sqrt(vt2/nat);  kv:=100/4/vt2;
  T1:=sqr(vt2)*mol_m/3/8.31;
  for i:=1 to nat do
  begin
    temp:=round({kv*}sqrt(0.25*(atoms[i].vx*1E-20*atoms[i].vx+
    atoms[i].vy*1E-20*atoms[i].vy))/dV);

    inc(y[temp]); inc(ny);
  end;
end;
 //if form1.cb_theor.Checked then
if nt mod 1000 = 0 then gistograma;
end;
end;

procedure TForm1.FormActivate(Sender: TObject);
begin
  for i:=0 to 400 do y[i]:=0;
  deltatau:=2E-14;
  T:=300;
  dV:=3;
  mol_m:= 0.032;
  a1:= -1;
  b1:= -1;  nat:= strtoint(Edit1.Text);
  //Init;
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  i:integer;
begin
  for i:=0 to nat do
  begin
    atoms[i].vx := -atoms[i].vx;
    atoms[i].vy := -atoms[i].vy;
  end;
end;

end.
