program PDependencyInjection;

uses
  Vcl.Forms,
  DIMain in 'DIMain.pas' {Main},
  ClassesInterfaces in 'ClassesInterfaces.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMain, Main);
  Application.Run;
end.
