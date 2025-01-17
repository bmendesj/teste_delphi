unit View.FmdPessoas;

interface

uses
  Controller.Pessoas, Controller.Enderecos, DTO.Pessoa, DTO.Endereco,
  uReturnCustom,
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.Buttons, Vcl.ExtCtrls, Data.DB, Vcl.Grids, Vcl.DBGrids, REST.Types,
  Vcl.StdCtrls;

type
  TfmdPessoas = class(TForm)
    pLateral: TPanel;
    btnAnterior: TSpeedButton;
    btnProximo: TSpeedButton;
    btnAdicionar: TSpeedButton;
    Editar: TSpeedButton;
    apagar: TSpeedButton;
    btmFechar: TSpeedButton;
    btnSalvar: TSpeedButton;
    DBGrid: TDBGrid;
    pTop: TPanel;
    edtId: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    edtDocumento: TEdit;
    Label3: TLabel;
    edtNome: TEdit;
    Label4: TLabel;
    edtSobrenome: TEdit;
    Label5: TLabel;
    cbNatureza: TComboBox;
    Label6: TLabel;
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btmFecharClick(Sender: TObject);
    procedure btnAdicionarClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnSalvarClick(Sender: TObject);
    procedure EditarClick(Sender: TObject);
    procedure apagarClick(Sender: TObject);
    procedure btnProximoClick(Sender: TObject);
    procedure btnAnteriorClick(Sender: TObject);
  private
    { Private declarations }
    fControllerPessoa:   TControllerPessoa;
    fControllerEndereco: TControllerEndereco;
    fRegistro:           TDTOPessoa;
    function Salvar: Boolean;
  public
    { Public declarations }
    procedure SetRegistro(aRegistro:TDTOPessoa);
  end;

var
  fmdPessoas: TfmdPessoas;

implementation

{$R *.dfm}

uses View.FchPessoas;

procedure TfmdPessoas.apagarClick(Sender: TObject);
var
  nMsg: Integer;
begin
  if fControllerEndereco.GetDataSource.DataSet.RecordCount < 2 then
  begin
    ShowMessage('N�o � poss�vel apagar o �ltimo endere�o');
    Exit;
  end;

  nMsg:= Application.MessageBox(PChar('Deseja apagar o registro?'), PChar(Caption), MB_ICONQUESTION+MB_YESNO);

  if nMsg <> 6 then
    Exit;

  fControllerEndereco.Delete;
  fControllerEndereco.Select(fRegistro.IdPessoa);
end;

procedure TfmdPessoas.btmFecharClick(Sender: TObject);
begin
  Close;
end;

procedure TfmdPessoas.btnAdicionarClick(Sender: TObject);
var
  e: TDTOEndereco;

  sMsg: string;
  nMsg: Integer;
begin
  if (fRegistro.Idpessoa < 1) and (fControllerEndereco.GetDataSource.DataSet.RecordCount = 1) then
  begin
    sMsg:= 'Para adicionar outro endere�o e necess�rio salvar o registro.' +
      #13 + 'Deseja continuar?';

    nMsg:= Application.MessageBox(PChar(sMsg), PChar(Caption), MB_ICONQUESTION+MB_YESNO);

    if nMsg <> 6 then
      Exit;

    if not Salvar then
      Exit;
  end;

  fchPessoas:= TfchPessoas.Create(Self);

  e:= TDTOEndereco.Create;
  e.IdPessoa:= fRegistro.Idpessoa;

  fchPessoas.SetRegistro(e);
end;

procedure TfmdPessoas.btnAnteriorClick(Sender: TObject);
begin
  if fRegistro.Idpessoa > 0 then
    fControllerEndereco.PaginaAnterior(fRegistro.Idpessoa);
end;

procedure TfmdPessoas.btnProximoClick(Sender: TObject);
begin
  if fRegistro.Idpessoa > 0 then
    fControllerEndereco.ProximaPagina(fRegistro.Idpessoa);
end;

procedure TfmdPessoas.btnSalvarClick(Sender: TObject);
begin
  if not Salvar then
    Exit;

  Close;
end;

procedure TfmdPessoas.EditarClick(Sender: TObject);
begin
  fchPessoas:= TfchPessoas.Create(Self);
  fchPessoas.SetRegistro(fControllerEndereco.GetRegistro);
end;

procedure TfmdPessoas.FormActivate(Sender: TObject);
begin
  WindowState:= TWindowState.wsMaximized;
end;

procedure TfmdPessoas.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  fControllerEndereco.Close;

  Self.Release;
end;

procedure TfmdPessoas.FormCreate(Sender: TObject);
begin
  cbNatureza.Items.Create;
  cbNatureza.Items.Add('Escolha uma');
  cbNatureza.Items.Add('F�sica');
  cbNatureza.Items.Add('Jur�dica');

  fControllerPessoa:=   TControllerPessoa.Create;
  fControllerEndereco:= TControllerEndereco.Create;
end;

function TfmdPessoas.Salvar: Boolean;
var
  bRet: TReturnBoolean;
begin
  Result:= False;

  if fControllerEndereco.GetDataSource.DataSet.RecordCount = 0 then
  begin
    ShowMessage('N�o � poss�vel inserir uma pessoa sem endere�o');
    Exit;
  end;

  fRegistro.Natureza:=  cbNatureza.ItemIndex;
  fRegistro.Documento:= edtDocumento.Text;
  fRegistro.Primeiro:=  edtNome.Text;
  fRegistro.Segundo:=   edtSobrenome.Text;
  fRegistro.Registro:=  Date;

  bRet:= fControllerPessoa.Validar(fRegistro);

  if bRet.HasError then
  begin
    ShowMessage(bRet.Mensage);
    Exit;
  end;

  if fRegistro.Idpessoa < 1 then
  begin
    fRegistro.Registro:= Date;
    fControllerPessoa.Insert(fRegistro, fControllerEndereco.GetRegistro)
  end else
    fControllerPessoa.Update(fRegistro);

  Result:= True;
end;

procedure TfmdPessoas.SetRegistro(aRegistro: TDTOPessoa);
begin
  fRegistro:= aRegistro;

  edtId.Text:=           fRegistro.idpessoa.ToString;
  cbNatureza.ItemIndex:= fRegistro.Natureza;
  edtDocumento.Text:=    fRegistro.Documento;
  edtNome.Text:=         fRegistro.Primeiro;
  edtSobrenome.Text:=    fRegistro.Segundo;
end;

end.
