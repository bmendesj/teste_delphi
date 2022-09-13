unit SMViaCep;

interface

uses
  System.SysUtils, System.Classes, System.Json,
  DataSnap.DSProviderDataModuleAdapter, Datasnap.DSServer, Datasnap.DSAuth,

  Data.DBXPlatform, Web.HTTPApp, Datasnap.DSHTTPWebBroker,

  FireDAC.Stan.Option, Data.DB, REST.Types, REST.Response.Adapter, REST.Client,
  Data.Bind.Components, Data.Bind.ObjectScope;

type
  TSMViaCep = class(TDSServerModule)
    RESTClient1: TRESTClient;
    RESTRequest1: TRESTRequest;
    RESTResponse1: TRESTResponse;
    RESTResponseDataSetAdapter1: TRESTResponseDataSetAdapter;
  private
    { Private declarations }
  public
    { Public declarations }
    function ConsultaCep: TJSONArray;
  end;

implementation


{$R *.dfm}

uses
  uJsonDataSetHelper, WebModuleUnit1;

{ TSMViaCep }

function TSMViaCep.ConsultaCep: TJSONArray;
var
  metaData: TDSInvocationMetadata;
  qCep:  string;
  sTemp: string;
begin
  try
    metaData:= GetInvocationMetadata;

    if metaData.QueryParams.IndexOfName('qCep') > -1 then
      qCep:= metaData.QueryParams.Values['qCep'];

    RESTClient1.BaseURL:= 'https://viacep.com.br/ws/' + qCep + '/json/';
    RESTRequest1.Execute;

      if not RESTRequest1.Response.Status.Success then
      begin
          GetInvocationMetadata().ResponseCode:= 204;
          GetInvocationMetadata().ResponseMessage:= 'N�o existe registros para inserir.';
          Abort;
      end;

      if RESTRequest1.Response.JSONValue = nil then
      begin
          GetInvocationMetadata().ResponseCode:= 204;
          GetInvocationMetadata().ResponseMessage:= 'N�o existe registros para inserir.';
          Abort;
      end;

    sTemp:= RESTRequest1.Response.JSONValue.ToString;

    sTemp:= '[' + sTemp + ']';

    Result:= TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(sTemp), 0) as TJSONArray;

    //Remove partes indesejadas do datasnap
    GetInvocationMetadata().ResponseCode:=    200;
    GetInvocationMetadata().ResponseContent:= Result.ToString;
  except on E: Exception do
    begin
      GetInvocationMetadata().ResponseCode:= 500;
      GetInvocationMetadata().ResponseMessage:= 'Um erro inesperado ocorreu.';
    end;
  end;
end;

end.
