unit Viewer;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  Buttons, Clipbrd, IniFiles, HtmlView, RichMemo;

type

  { TViewerForm }

  TViewerForm = class(TForm)
    CloseBtn: TBitBtn;
    CopyBtn: TBitBtn;
    HtmlViewer: THtmlViewer;
    ImageViewer: TImage;
    PanelButtons: TPanel;
    RtfViewer: TRichMemo;
    ScrollBox: TScrollBox;
    TextViewer: TMemo;
    procedure CloseBtnClick(Sender: TObject);
    procedure CopyBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    Bitmap: TBitmap;
  public

  end;

var
  ViewerForm: TViewerForm;

implementation

uses Main;

{$R *.lfm}
{$I resources.inc}

{ TViewerForm }

procedure TViewerForm.CloseBtnClick(Sender: TObject);
begin
  Close;
end;

procedure TViewerForm.CopyBtnClick(Sender: TObject);
begin
  //if (TextViewer.Lines.Count > 0) and (TextViewer.SelLength > 0) then
  if TextViewer.Visible then
  begin
    TextViewer.SelectAll;
    TextViewer.CopyToClipboard;
    TextViewer.SelLength := 0;
    MessageDlg(strCopyText, mtInformation, [mbOK], 0);
  end
  else if RtfViewer.Visible then
  begin
    RtfViewer.SelectAll;
    RtfViewer.CopyToClipboard;
    RtfViewer.SelLength := 0;
    MessageDlg(strCopyText, mtInformation, [mbOK], 0);
  end
  else if HtmlViewer.Visible then
  begin
    HtmlViewer.SelectAll;
    HtmlViewer.CopyToClipboard;
    HtmlViewer.SelLength := 0;
    MessageDlg(strCopyText, mtInformation, [mbOK], 0);
  end
  else if ImageViewer.Visible then
  begin
    Bitmap := TBitmap.Create;
    Bitmap.Width := ImageViewer.Width;
    Bitmap.Height := ImageViewer.Height;
    Bitmap.Canvas.Draw(0, 0, ImageViewer.Picture.Graphic);
    Clipboard.Assign(Bitmap);
    Bitmap.Free;
    MessageDlg(strCopyImage, mtInformation, [mbOK], 0);
  end;
end;

procedure TViewerForm.FormCreate(Sender: TObject);
var
  sPath: string;
  IniFile: TIniFile;
begin
  sPath := GetAppConfigDir(False);
  IniFile := TIniFile.Create(sPath + 'fde.ini');
  WindowState := TWindowState(IniFile.ReadInteger('ViewerForm', 'State',
    integer(WindowState)));
  IniFile.Free;
end;

procedure TViewerForm.FormDestroy(Sender: TObject);
var
  sPath: string;
  IniFile: TIniFile;
begin
  sPath := GetAppConfigDir(False);
  IniFile := TIniFile.Create(sPath + 'fde.ini');
  IniFile.WriteInteger('ViewerForm', 'State', integer(WindowState));
  IniFile.Free;
end;

procedure TViewerForm.FormResize(Sender: TObject);
begin
  if WindowState = wsMinimized then
  begin
    Height := 532;
    Left := 332;
    Top := 118;
    Width := 702;
  end;
end;

procedure TViewerForm.FormShow(Sender: TObject);
begin
  if Caption = 'Error Log' then
  begin
    TextViewer.Color := clBlack;
    TextViewer.Font.Color := clWhite;
  end
  else
  begin
    TextViewer.Color := clDefault;
    TextViewer.Font.Color := clBlack;
  end;
  SetFocus;
end;

end.
