program prgLZSS;

uses
  Forms,
  frmuMainForm in 'frmuMainForm.pas' {frmMainForm},
  LZSS in 'LZSS.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMainForm, frmMainForm);
  Application.Run;
end.
