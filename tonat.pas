unit Tonat;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  Buttons, Spin, LCLTranslator, EditBtn;

type

  { TTonatForm }

  TTonatForm = class(TForm)
    CancelButton: TButton;
    CheckBoxOmitCharacterNumbers: TCheckBox;
    CheckBoxOmitFinalComma: TCheckBox;
    CheckBoxOmitComments: TCheckBox;
    CheckBoxOmitInapplicables: TCheckBox;
    CheckBoxOmitInnerComments: TCheckBox;
    CheckBoxOmitTypesettingMarks: TCheckBox;
    CheckBoxReplaceAngleBrackets: TCheckBox;
    CheckBoxTranslateImplicitValues: TCheckBox;
    ComboBoxOutputFormat: TComboBox;
    EditEmphasizeFeatures: TEditButton;
    EditExcludeCharacters: TEditButton;
    EditExcludeItems: TEditButton;
    EditHeading: TEdit;
    EditItemSubheadings: TEditButton;
    EditLinkCharacters: TEditButton;
    EditNewParagraphsAtCharacters: TEditButton;
    EditOmitLowerForCharacters: TEditButton;
    EditOmitOrForCharacters: TEditButton;
    EditOmitPeriodForCharacters: TEditButton;
    EditReplaceSemicolonByComma: TEditButton;
    LabelEmphasizeFeatures: TLabel;
    LabelExcludeCharacters: TLabel;
    LabelExcludeItems: TLabel;
    LabelHeading: TLabel;
    LabelItemSubheadings: TLabel;
    LabelLinkCharacters: TLabel;
    LabelNewParagraphsAtCharacters: TLabel;
    LabelOmitLowerForCharacters: TLabel;
    LabelOmitOrForCharacters: TLabel;
    LabelOmitPeriodForCharacters: TLabel;
    LabelOutputFormat: TLabel;
    LabelPrintWidth: TLabel;
    LabelReplaceSemicolonByComma: TLabel;
    OKButton: TButton;
    PanelButtons: TPanel;
    SpinEditPrintWidth: TSpinEdit;
    procedure ComboBoxOutputFormatChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure SpeedButtonEmphasizeFeaturesClick(Sender: TObject);
    procedure SpeedButtonExcludeCharactersClick(Sender: TObject);
    procedure SpeedButtonExcludeItemsClick(Sender: TObject);
    procedure SpeedButtonItemSubheadingsClick(Sender: TObject);
    procedure SpeedButtonLinkCharactersClick(Sender: TObject);
    procedure SpeedButtonNewParagraphsAtCharactersClick(Sender: TObject);
    procedure SpeedButtonOmitLowerForCharactersClick(Sender: TObject);
    procedure SpeedButtonOmitOrForCharactersClick(Sender: TObject);
    procedure SpeedButtonOmitPeriodForCharactersClick(Sender: TObject);
    procedure SpeedButtonReplaceSemicolonByCommaClick(Sender: TObject);
  private
    ListItems: TStringList;
    ListCharacters: TStringList;
    ListSelectedItems: TStringList;
    ListSelectedChars: TStringList;
    procedure FillListItems(Sender: TObject);
    procedure FillListCharacters(Sender: TObject);
  public

  end;

var
  TonatForm: TTonatForm;

implementation

uses Main, Checklist, Delta;

{$R *.lfm}
{$I resources.inc}

{ TTonatForm }

procedure TTonatForm.FillListCharacters(Sender: TObject);
var
  J: word;
begin
  ListCharacters.Clear;
  for J := 0 to Length(Dataset.CharacterList) - 1 do
    ListCharacters.Add(IntToStr(J + 1) + '. ' +
      Delta.OmitTypeSettingMarks(Dataset.CharacterList[J].charName));
  if Length(Trim(EditExcludeCharacters.Text)) > 0 then
    //ListSelectedChars.DelimitedText := EditExcludeCharacters.Text
    ListSelectedChars := Delta.ExpandRange(EditExcludeCharacters.Text)
  else
    ListSelectedChars := nil;
end;

procedure TTonatForm.FillListItems(Sender: TObject);
var
  I: word;
begin
  ListItems.Clear;
  for I := 0 to Length(Dataset.ItemList) - 1 do
    ListItems.Add(IntToStr(I + 1) + '. ' + Delta.OmitTypeSettingMarks(
      Dataset.ItemList[I].itemName));
  if Length(Trim(EditExcludeItems.Text)) > 0 then
    //ListSelectedItems.DelimitedText := EditExcludeItems.Text
    ListSelectedItems := ExpandRange(EditExcludeItems.Text)
  else
    ListSelectedItems := nil;
end;

procedure TTonatForm.SpeedButtonNewParagraphsAtCharactersClick(Sender: TObject);
begin
  FillListCharacters(Self);
  ChecklistForm.L := ListCharacters;
  ChecklistForm.X := ListSelectedChars;
  if ChecklistForm.ShowModal = mrOk then
    EditNewParagraphsAtCharacters.Text := ChecklistForm.S;
end;

procedure TTonatForm.SpeedButtonOmitLowerForCharactersClick(Sender: TObject);
begin
  FillListCharacters(Self);
  ChecklistForm.L := ListCharacters;
  ChecklistForm.X := ListSelectedChars;
  if ChecklistForm.ShowModal = mrOk then
    EditOmitLowerForCharacters.Text := ChecklistForm.S;
end;

procedure TTonatForm.SpeedButtonOmitOrForCharactersClick(Sender: TObject);
begin
  FillListCharacters(Self);
  ChecklistForm.L := ListCharacters;
  ChecklistForm.X := ListSelectedChars;
  if ChecklistForm.ShowModal = mrOk then
    EditOmitOrForCharacters.Text := ChecklistForm.S;
end;

procedure TTonatForm.SpeedButtonOmitPeriodForCharactersClick(Sender: TObject);
begin
  FillListCharacters(Self);
  ChecklistForm.L := ListCharacters;
  ChecklistForm.X := ListSelectedChars;
  if ChecklistForm.ShowModal = mrOk then
    EditOmitPeriodForCharacters.Text := ChecklistForm.S;
end;

procedure TTonatForm.SpeedButtonReplaceSemicolonByCommaClick(Sender: TObject);
begin
  FillListCharacters(Self);
  ChecklistForm.L := ListCharacters;
  ChecklistForm.X := ListSelectedChars;
  if ChecklistForm.ShowModal = mrOk then
    EditReplaceSemicolonByComma.Text := ChecklistForm.S;
end;

procedure TTonatForm.SpeedButtonExcludeItemsClick(Sender: TObject);
begin
  FillListItems(Self);
  ChecklistForm.L := ListItems;
  ChecklistForm.Y := ListSelectedItems;
  if ChecklistForm.ShowModal = mrOk then
    EditExcludeItems.Text := ChecklistForm.S;
end;

procedure TTonatForm.SpeedButtonExcludeCharactersClick(Sender: TObject);
begin
  FillListCharacters(Self);
  ChecklistForm.L := ListCharacters;
  ChecklistForm.X := ListSelectedChars;
  if ChecklistForm.ShowModal = mrOk then
    EditExcludeCharacters.Text := ChecklistForm.S;
end;

procedure TTonatForm.SpeedButtonItemSubheadingsClick(Sender: TObject);
begin
  FillListCharacters(Self);
  ChecklistForm.L := ListCharacters;
  ChecklistForm.X := ListSelectedChars;
  if ChecklistForm.ShowModal = mrOk then
    EditItemSubheadings.Text := ChecklistForm.S;
end;

procedure TTonatForm.SpeedButtonLinkCharactersClick(Sender: TObject);
begin
  FillListCharacters(Self);
  ChecklistForm.L := ListCharacters;
  ChecklistForm.X := ListSelectedChars;
  if ChecklistForm.ShowModal = mrOk then
    EditLinkCharacters.Text := ChecklistForm.S;
end;

procedure TTonatForm.FormCreate(Sender: TObject);
begin
  ListItems := TStringList.Create;
  ListCharacters := TStringList.Create;
  ListSelectedItems := TStringList.Create;
  ListSelectedChars := TStringList.Create;
  with ComboBoxOutputFormat.Items do
  begin
    Add(strText);
    Add('HTML');
    Add('RTF');
  end;
  ComboBoxOutputFormat.ItemIndex := 0;
end;

procedure TTonatForm.ComboBoxOutputFormatChange(Sender: TObject);
begin
  CheckBoxOmitTypesettingMarks.Checked := ComboBoxOutputFormat.ItemIndex <> 2;
  if ComboBoxOutputFormat.ItemIndex = 2 then
    SpinEditPrintWidth.Value := 0;
end;

procedure TTonatForm.FormDestroy(Sender: TObject);
begin
  ListItems.Free;
  ListCharacters.Free;
  ListSelectedItems.Free;
  ListSelectedChars.Free;
end;

procedure TTonatForm.SpeedButtonEmphasizeFeaturesClick(Sender: TObject);
begin
  FillListCharacters(Self);
  ChecklistForm.L := ListCharacters;
  ChecklistForm.X := ListSelectedChars;
  if ChecklistForm.ShowModal = mrOk then
    EditEmphasizeFeatures.Text := ChecklistForm.S;
end;

end.
