unit View.LstPessoas;

interface

uses
  Controller.Pessoas, Controller.Enderecos,
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Buttons, Vcl.ExtCtrls, Data.DB,
  Vcl.Grids, Vcl.DBGrids, REST.Types, Vcl.StdCtrls;

type
  TlstPessoas = class(TForm)
    pLateral: TPanel;
    btnAnterior: TSpeedButton;
    btnProximo: TSpeedButton;
    btnAdicionar: TSpeedButton;
    Editar: TSpeedButton;
    apagar: TSpeedButton;
    btmFechar: TSpeedButton;
    DBGrid: TDBGrid;
    btnCarregar: TSpeedButton;
    procedure btnAnteriorClick(Sender: TObject);
    procedure btnProximoClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btmFecharClick(Sender: TObject);
    procedure btnAdicionarClick(Sender: TObject);
    procedure EditarClick(Sender: TObject);
    procedure apagarClick(Sender: TObject);
    procedure btnCarregarClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    fControllerPessoa: TControllerPessoa;
    fControllerEndereco: TControllerEndereco;
  public
    { Public declarations }
  end;

var
  lstPessoas: TlstPessoas;

implementation

{$R *.dfm}

uses View.Principal, View.FmdPessoas, View.FrmCarga;

procedure TlstPessoas.apagarClick(Sender: TObject);
var
  nMsg: Integer;
begin
  nMsg:= Application.MessageBox(PChar('Deseja apagar o registro?'), PChar(Caption), MB_ICONQUESTION+MB_YESNO);

  if nMsg <> 6 then
    Exit;

  fControllerPessoa.Delete;
end;

procedure TlstPessoas.btmFecharClick(Sender: TObject);
begin
  Close;
end;

procedure TlstPessoas.btnAdicionarClick(Sender: TObject);
begin
  fmdPessoas:= TfmdPessoas.Create(Self);
  fmdPessoas.SetRegistro(TDTOPessoa.Create);
  fmdPessoas.DBGrid.DataSource:= fControllerEndereco.GetDataSource;
end;

procedure TlstPessoas.btnAnteriorClick(Sender: TObject);
begin
  fControllerPessoa.PaginaAnterior;
end;

procedure TlstPessoas.btnCarregarClick(Sender: TObject);
begin
  frmCarga:= TfrmCarga.Create(Self);
  frmCarga.ShowModal;

  fControllerPessoa.Select(0);
end;

procedure TlstPessoas.btnProximoClick(Sender: TObject);
begin
  fControllerPessoa.ProximaPagina;
end;

procedure TlstPessoas.EditarClick(Sender: TObject);
begin
  fControllerEndereco.Select(fControllerPessoa.GetRegistro.Idpessoa);

  fmdPessoas:= TfmdPessoas.Create(Self);
  fmdPessoas.SetRegistro(fControllerPessoa.GetRegistro);
  fmdPessoas.DBGrid.DataSource:= fControllerEndereco.GetDataSource;
end;

procedure TlstPessoas.FormActivate(Sender: TObject);
begin
  WindowState:= TWindowState.wsMaximized;
end;

procedure TlstPessoas.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  frmPrincipal.ExibirPanelLateral;

  fControllerPessoa.Close;

  Self.Release;
end;

procedure TlstPessoas.FormCreate(Sender: TObject);
begin
  fControllerPessoa:=   TControllerPessoa.Create;
  fControllerEndereco:= TControllerEndereco.Create;
end;

end.