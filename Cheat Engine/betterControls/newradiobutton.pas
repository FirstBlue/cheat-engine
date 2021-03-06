unit newRadioButton;

{$mode objfpc}{$H+}

interface

uses
  windows, Classes, SysUtils, StdCtrls, LCLType, Graphics, LMessages, Controls;

type
  TNewRadioButton=class(StdCtrls.TRadioButton)
  private
    painted: boolean;
    fCanvas: TCanvas;
    fCustomDraw: boolean;
    fOnPaint: TNotifyEvent;

  protected
    procedure DefaultCustomPaint;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure WMPaint(var Msg: TLMPaint); message LM_PAINT;
    procedure PaintWindow(DC: HDC); override;
    procedure FontChanged(Sender: TObject); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
  published
    property CustomDraw: boolean read fCustomDraw write fCustomDraw;
    property OnPaint: TNotifyEvent read fOnPaint write fOnPaint;
    property Canvas: TCanvas read fCanvas;
  end;


implementation

uses forms, betterControls;

procedure TNewRadioButton.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
  painted:=false;

  inherited MouseMove(shift, x,y);
  if not painted then
    repaint;
end;

procedure TNewRadioButton.FontChanged(Sender: TObject);
begin
  if self=nil then exit;

  if canvas<>nil then
  begin
    Canvas.Font.BeginUpdate;
    try
      Canvas.Font.PixelsPerInch := Font.PixelsPerInch;
      Canvas.Font := Font;
    finally
      Canvas.Font.EndUpdate;
    end;
  end;
  inherited FontChanged(Sender);
end;

procedure TNewRadioButton.PaintWindow(DC: HDC);
var
  DCChanged: boolean;
begin
  DCChanged := (not FCanvas.HandleAllocated) or (FCanvas.Handle <> DC);

  if DCChanged then
    FCanvas.Handle := DC;
  try
    DefaultCustomPaint;
  finally
    if DCChanged then FCanvas.Handle := 0;
  end;

  painted:=true;
end;

procedure TNewRadioButton.DefaultCustomPaint;
var
  ts: TTextStyle;
  faceColor: TColor;
  r: trect;

  dpiscale: single;
begin
  if fcanvas.Handle<>0 then
  begin
    facecolor:=parent.color;

    fcanvas.brush.style:=bsSolid;
    fcanvas.brush.color:=facecolor;
    fcanvas.Clear;

    fcanvas.pen.Width:=1;
    if enabled then
    begin
      fcanvas.pen.color:=colorset.CheckboxCheckMarkColor;
      fcanvas.Brush.color:=colorset.CheckboxFillColor;
    end
    else
    begin
      fcanvas.pen.color:=colorset.InactiveCheckboxCheckMarkColor;
      fcanvas.brush.color:=colorset.InactiveCheckboxFillColor;
    end;

    dpiscale:=Screen.PixelsPerInch/96;

    fcanvas.pen.width:=trunc(1*dpiscale);
    fcanvas.Pen.JoinStyle:=pjsBevel;

    r:=rect(trunc(dpiscale)-1,trunc(3*dpiscale),(trunc(dpiscale)-1)*2+clientheight-trunc((3*dpiscale)*2),(trunc(dpiscale)-1)+clientheight-trunc((3*dpiscale)));
    fcanvas.Ellipse(r);

    case state of
      cbChecked, cbGrayed:
      begin
        r.top:=r.top+trunc(dpiscale*3);
        r.bottom:=r.bottom-trunc(dpiscale*3);
        r.left:=r.left+trunc(dpiscale*3);
        r.right:=r.right-trunc(dpiscale*3);
        fcanvas.brush.color:=fcanvas.pen.color;
        fcanvas.Ellipse(r);
      end;

    end;


    if enabled then
      fcanvas.font.color:=colorset.FontColor
    else
      fcanvas.font.color:=colorset.InactiveFontColor;

    ts:=fcanvas.TextStyle;
    ts.Alignment:=taRightJustify;
    fcanvas.TextRect(rect(0,0,width-4,height),0,(height div 2)-(fcanvas.TextHeight(caption) div 2),caption, ts);


    if self.Focused then
      fcanvas.DrawFocusRect(rect(width-fcanvas.TextWidth(caption)-4,2,width-2,height-2));
  end;
end;

procedure TNewRadioButton.WMPaint(var Msg: TLMPaint);
begin
  if (csDestroying in ComponentState) or (not HandleAllocated) then exit;

  if fCustomDraw or globalCustomDraw then Include(FControlState, csCustomPaint);
  inherited WMPaint(msg);
  if fCustomDraw or globalCustomDraw then Exclude(FControlState, csCustomPaint);
end;

procedure TNewRadioButton.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  fcanvas:=TControlCanvas.Create;
  TControlCanvas(FCanvas).Control := Self;

  if ShouldAppsUseDarkMode() then
    fCustomDraw:=true;
end;


end.

