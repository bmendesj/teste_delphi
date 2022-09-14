program Cliente;

uses
  Vcl.Forms,
  View.Principal in 'View\View.Principal.pas' {frmPrincipal},
  DAO.Pessoas in 'Model\DAO.Pessoas.pas' {DAOPessoas: TDataModule},
  View.FmdPessoas in 'View\View.FmdPessoas.pas' {fmdPessoas},
  View.LstPessoas in 'View\View.LstPessoas.pas' {lstPessoas},
  View.FchPessoas in 'View\View.FchPessoas.pas' {fchPessoas},
  DAO.Enderecos in 'Model\DAO.Enderecos.pas' {DAOEnderecos: TDataModule},
  DAO.ViaCep in 'Model\DAO.ViaCep.pas' {DAOViaCep: TDataModule},
  Controller.Pessoas in 'Controller\Controller.Pessoas.pas',
  Controller.Enderecos in 'Controller\Controller.Enderecos.pas',
  Controller.ViaCep in 'Controller\Controller.ViaCep.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmPrincipal, frmPrincipal);
  Application.Run;
end.
