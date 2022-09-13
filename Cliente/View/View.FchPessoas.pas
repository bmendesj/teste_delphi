unit View.FchPessoas;

interface

uses
  Controller.Enderecos,
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Buttons, Vcl.ExtCtrls, Vcl.StdCtrls,
  Vcl.Mask, REST.Types, Data.DB;

type
  TfchPessoas = class(TForm)
    pLateral: TPanel;
    btmFechar: TSpeedButton;
    btnSalvar: TSpeedButton;
    Label3: TLabel;
    edtEstado: TEdit;
    Label4: TLabel;
    edtCidade: TEdit;
    Label1: TLabel;
    edtBairro: TEdit;
    Bairro: TLabel;
    edtLogradouro: TEdit;
    Label2: TLabel;
    edtComplemento: TEdit;
    Label5: TLabel;
    edtCep: TEdit;
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btmFecharClick(Sender: TObject);
    procedure btnSalvarClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure edtCepKeyPress(Sender: TObject; var Key: Char);
    procedure edtCepExit(Sender: TObject);
  private
    { Private declarations }
    fControllerEndereco: TControllerEndereco;
    fRegistro:           TDTOEndereco;
  public
    { Public declarations }
    procedure SetRegistro(aRegistro: TDTOEndereco);
  end;

var
  fchPessoas: TfchPessoas;

implementation

{$R *.dfm}

uses DAO.ViaCep;

procedure TfchPessoas.btmFecharClick(Sender: TObject);
begin
  Close;
end;

procedure TfchPessoas.btnSalvarClick(Sender: TObject);
begin
  fRegistro.Cep:=         edtCep.Text;
  fRegistro.Uf:=          edtEstado.Text;
  fRegistro.Cidade:=      edtCidade.Text;
  fRegistro.Bairro:=      edtBairro.Text;
  fRegistro.Logradouro:=  edtLogradouro.Text;
  fRegistro.Complemento:= edtComplemento.Text;

  if fRegistro.IdPessoa > 0 then
  begin
    if fRegistro.IdEndereco > 0 then
      fControllerEndereco.Update(fRegistro)
    else
      fControllerEndereco.Insert(fRegistro);
  end else
    fControllerEndereco.InsertSomenteNoDataSet(fRegistro);

  Close;
end;

procedure TfchPessoas.edtCepExit(Sender: TObject);
var
  v: TDAOViaCep;
begin
  if Length(edtEstado.Text) > 0 then
    Exit;

  v:= TDAOViaCep.GetInstance;
  v.Adapter.Active:= True;
  v.Request.Method:= TRESTRequestMethod.rmGET;
  v.Request.Params.Clear;
  v.Request.Params.AddItem('qCep', edtCep.Text, TRESTRequestParameterKind.pkQUERY);
  v.Request.Execute;

  if v.Request.Response.Status.Success then
  begin
    edtEstado.Text:=      v.DataSetuf.AsString;
    edtCidade.Text:=      v.DataSetlocalidade.AsString;
    edtBairro.Text:=      v.DataSetbairro.AsString;
    edtLogradouro.Text:=  v.DataSetlogradouro.AsString;
    edtComplemento.Text:= v.DataSetcomplemento.AsString;
  end else
    ShowMessage(v.Request.Response.StatusText);
end;

procedure TfchPessoas.edtCepKeyPress(Sender: TObject; var Key: Char);
const
  teclasDec = ['0'..'9'];
begin
  if not ((UpCase(Key) in teclasDec) or (Ord(Key) = VK_BACK)) then
    Key:= #0;
end;

procedure TfchPessoas.FormActivate(Sender: TObject);
begin
  WindowState:= TWindowState.wsMaximized;
end;

procedure TfchPessoas.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  fControllerEndereco.GetDataSource.DataSet.Cancel;
  Self.Release;
end;

procedure TfchPessoas.FormCreate(Sender: TObject);
begin
  fControllerEndereco:= TControllerEndereco.Create;
end;

procedure TfchPessoas.SetRegistro(aRegistro: TDTOEndereco);
begin
  fRegistro:= aRegistro;

  edtCep.Text:=         fRegistro.Cep;
  edtEstado.Text:=      fRegistro.Uf;
  edtCidade.Text:=      fRegistro.Cidade;
  edtBairro.Text:=      fRegistro.Bairro;
  edtLogradouro.Text:=  fRegistro.Logradouro;
  edtComplemento.Text:= fRegistro.Complemento;
end;

end.