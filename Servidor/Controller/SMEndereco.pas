unit SMEndereco;

interface

uses
  System.SysUtils, System.Classes, System.Json,
  DataSnap.DSProviderDataModuleAdapter, Datasnap.DSServer, Datasnap.DSAuth,

  Data.DBXPlatform, Web.HTTPApp, Datasnap.DSHTTPWebBroker,

  FireDAC.Stan.Option, Data.DB, System.Generics.Collections;

type
  TSMEndereco = class(TDSServerModule)
  private
    { Private declarations }
  public
    { Public declarations }

    function Enderecos: TJSONArray;       //GET
    function UpdateEnderecos: TJSONArray; //POST
    function AcceptEnderecos: TJSONArray; //PUT
    function CancelEnderecos: TJSONArray; //DELETE
  end;

implementation


{$R *.dfm}

uses
  uJsonDataSetHelper, WebModuleUnit1, DAO.DMConexao, DAO.Enderecos;

{ TSMEndereco }

function TSMEndereco.Enderecos: TJSONArray;
var
  metaData:  TDSInvocationMetadata;
  enderecos: TDAOEnderecos;

  filtro:      TPair<string, string>;
  idPaginacao: Int64;
begin
{GET NO HTTP}
  Result:=    nil;
  enderecos:= nil;

  filtro.Key:=   '';
  filtro.Value:= '';

  idPaginacao:= -1;

  try
    try
      metaData:= GetInvocationMetadata;

      if metaData.QueryParams.IndexOfName('qCampo') > -1 then
        filtro.Key:= metaData.QueryParams.Values['qCampo'];

      if metaData.QueryParams.IndexOfName('qValor') > -1 then
        filtro.Value:= metaData.QueryParams.Values['qValor'];

      if metaData.QueryParams.IndexOfName('qIdPaginacao') > -1 then
        idPaginacao:= StrToInt64(metaData.QueryParams.Values['qIdPaginacao']);


      if filtro.Key.Length = 0 then
      begin
        GetInvocationMetadata().ResponseCode:= 202;
        GetInvocationMetadata().ResponseMessage:= 'Um campo de filtro deve ser informado.';
        Exit;
      end;

      enderecos:= TDAOEnderecos.Create(DMConexao.FDPostgre);
      Result:= enderecos.Get(filtro, idPaginacao);

      GetInvocationMetadata().ResponseCode:=    200;
      GetInvocationMetadata().ResponseContent:= Result.ToString;
    except on E: Exception do
      begin
        GetInvocationMetadata().ResponseCode:= 500;
        GetInvocationMetadata().ResponseMessage:= 'Um erro inesperado ocorreu.';
      end;
    end;
  finally
    if enderecos <> nil then
      FreeAndNil(enderecos);
  end;
end;

function TSMEndereco.UpdateEnderecos: TJSONArray;
var
  lModulo:       TWebModule;
  lJARequisicao: TJSONArray;

  endereco:      TDAOEnderecos;
  ultimaId:    Integer;
begin
{POST NO HTTP}
  Result:=   nil;
  endereco:= nil;

  try
    try
      lModulo:= GetDataSnapWebModule;

      if lModulo.Request.content.IsEmpty then
      begin
        GetInvocationMetadata().ResponseCode:= 204;
        GetInvocationMetadata().ResponseMessage:= 'N�o existe registros para inserir.';
        Abort;
      end;

      lJARequisicao:= TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(lModulo.Request.Content), 0) as TJSONArray;

      if lJARequisicao.Count < 1 then
      begin
        GetInvocationMetadata().ResponseCode:= 202;
        GetInvocationMetadata().ResponseMessage:= 'N�o existe registros para inserir.';
        Exit;
      end;

      endereco:= TDAOEnderecos.Create(DMConexao.FDPostgre);

      ultimaId:= endereco.Insert(lJARequisicao);

      Result:= TJSONArray.Create(TJSONObject.Create(TJSONPair.Create('ultimaId', ultimaId.ToString)));

      GetInvocationMetadata().ResponseCode:=    200;
      GetInvocationMetadata().ResponseContent:= Result.ToString;
    except
      on E: Exception do
      begin
        GetInvocationMetadata().ResponseCode:= 500;
        GetInvocationMetadata().ResponseMessage:= 'Um erro inesperado ocorreu.';
      end;
    end;
  finally
    if endereco <> nil then
      FreeAndNil(endereco);
  end;
end;

function TSMEndereco.AcceptEnderecos: TJSONArray;
var
  metaData:      TDSInvocationMetadata;
  lModulo:       TWebModule;
  lJARequisicao: TJSONArray;

  endereco:      TDAOEnderecos;
  qId:           Int64;
begin
{PUT NO HTTP}
  Result:=   nil;
  endereco:= nil;

  qId:=      -1;

  try
    try
      metaData:= GetInvocationMetadata;

      if metaData.QueryParams.IndexOfName('qId') > -1 then
        qId:= StrToInt64(metaData.QueryParams.Values['qId']);

      if qId < 1 then
      begin
        GetInvocationMetadata().ResponseCode:= 202;
        GetInvocationMetadata().ResponseMessage:= 'Id n�o informada.';
        Exit;
      end;

      lModulo:= GetDataSnapWebModule;

      if lModulo.Request.content.IsEmpty then
      begin
        GetInvocationMetadata().ResponseCode:= 204;
        GetInvocationMetadata().ResponseMessage:= 'Sem registro para alterar.';
        Exit;
      end;

      lJARequisicao:= TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(lModulo.Request.Content), 0) as TJSONArray;

      if lJARequisicao.Count <> 1 then
      begin
        GetInvocationMetadata().ResponseCode:= 202;
        GetInvocationMetadata().ResponseMessage:= 'Dese ser informado exatamente um registro para altera��o.';
        Exit;
      end;

      endereco:= TDAOEnderecos.Create(DMConexao.FDPostgre);

      endereco.Update(qId, lJARequisicao);

      Result:= TJSONArray.Create('message', 'Registro alterado.');

      GetInvocationMetadata().ResponseCode:=    200;
      GetInvocationMetadata().ResponseContent:= Result.ToString;
    except
      on E: Exception do
      begin
        GetInvocationMetadata().ResponseCode:= 500;
        GetInvocationMetadata().ResponseMessage:= 'Um erro inesperado ocorreu.';
      end;
    end;
  finally
    if endereco <> nil then
      FreeAndNil(endereco);
  end;
end;

function TSMEndereco.CancelEnderecos: TJSONArray;
var
  metaData: TDSInvocationMetadata;
  endereco: TDAOEnderecos;

  qId:      Int64;
begin
{DELETE NO HTTP}
  Result:=   nil;
  endereco:= nil;

  qId:=     -1;

  try
    try
      metaData:= GetInvocationMetadata;

      if metaData.QueryParams.IndexOfName('qId') > -1 then
        qId:= StrToInt64(metaData.QueryParams.Values['qId']);

      if qId < 1 then
      begin
        GetInvocationMetadata().ResponseCode:= 202;
        GetInvocationMetadata().ResponseMessage:= 'A id do registro n�o foi informada.';
        Exit;
      end;

      endereco:= TDAOEnderecos.Create(DMConexao.FDPostgre);

      endereco.Delete(qId);

      Result:= TJSONArray.Create('message', 'Registro apagado.');

      GetInvocationMetadata().ResponseCode:=    200;
      GetInvocationMetadata().ResponseContent:= Result.ToString;
    except
      on E: Exception do
      begin
        GetInvocationMetadata().ResponseCode:= 500;
        GetInvocationMetadata().ResponseMessage:= 'Um erro inesperado ocorreu.';
      end;
    end;
  finally
    if endereco <> nil then
      FreeAndNil(endereco);
  end;
end;

end.
