unit newMainMenu;

{$mode objfpc}{$H+}

interface

uses
  jwawindows, windows, Classes, SysUtils, Controls, StdCtrls, Menus, Graphics;

type
  TNewMenuItem=class(TMenuItem)
  private
  protected
    function DoDrawItem(ACanvas: TCanvas; ARect: TRect; AState: TOwnerDrawState): Boolean; override;
  public
  published
  end;


  TNewMainMenu=class(TMainMenu)
  private
    procedure firstshow(sender: TObject);
  protected
    procedure SetParentComponent(Value: TComponent); override;
  public
  end;


implementation

uses betterControls, forms, LCLType;

procedure TNewMainMenu.firstshow(sender: TObject);
var m: Hmenu;
  mi: windows.MENUINFO;
  c: tcanvas;
  mia: windows.LPCMENUINFO;


 // mbi: ENUBARINFO ;

  b: TBrush;
begin
  m:=GetMenu(TCustomForm(sender).handle);
 // m:=handle;


  mi.cbSize:=sizeof(mi);
  mi.fMask := MIM_BACKGROUND or MIM_APPLYTOSUBMENUS;

  b:=TBrush.Create;
  b.color:=$2b2b2b;


  b.Style:=bsSolid;

  mi.hbrBack:=b.handle; //GetSysColorBrush(DKGRAY_BRUSH); //b.Handle;
  mia:=@mi;
  if windows.SetMenuInfo(m,mia) then
  begin
    AllowDarkModeForWindow(m,1);

    SetWindowTheme(m,'',nil);
  end
end;

procedure TNewMainMenu.SetParentComponent(Value: TComponent);
begin
  inherited SetParentComponent(value);

  if value is tcustomform then
    tcustomform(value).AddHandlerFirstShow(@firstshow);
end;

function TNewMenuItem.DoDrawItem(ACanvas: TCanvas; ARect: TRect; AState: TOwnerDrawState): Boolean;
var oldc: tcolor;

  bmp: Tbitmap;
  ts: TTextStyle;
begin
 // acanvas.Brush.color:=clBlue;
  result:=inherited DoDrawItem(ACanvas, ARect, AState);

  if ShouldAppsUseDarkMode() and (result=false) then
  begin
    result:=Parent.Menu is TMainMenu;       //(name='MenuItem1') or (name='MenuItem3');
    if result then
    begin
      oldc:=acanvas.Brush.color;
      acanvas.Brush.color:=$313131;

      if MenuIndex=parent.count-1 then //name='MenuItem3' then
        ARect.Width:=tcustomform(owner).width;
      acanvas.FillRect(arect);

      acanvas.font.color:=clWhite;
      ts:=acanvas.TextStyle;
      ts.ShowPrefix:=true;
      acanvas.Brush.Style:=bsSolid;
      acanvas.TextRect(arect,arect.left,arect.top,caption, ts);
      acanvas.Brush.color:=oldc;
    end;

  end;
end;

end.

