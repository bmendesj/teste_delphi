unit DAO.Enderecos;

interface

uses
  System.SysUtils, System.Classes, REST.Types,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, REST.Response.Adapter, REST.Client, Data.Bind.Components,
  Data.Bind.ObjectScope, System.JSON;

type
  TDAOEnderecos = class(TDataModule)
    Adapter: TRESTResponseDataSetAdapter;
    DataSet: TFDMemTable;
    DataSource: TDataSource;
    Client: TRESTClient;
    Request: TRESTRequest;
    Response: TRESTResponse;
    DataSetidendereco: TLargeintField;
    DataSetidpessoa: TLargeintField;
    DataSetdscep: TStringField;
    DataSetdsuf: TStringField;
    DataSetnmcidade: TStringField;
    DataSetnmbairro: TStringField;
    DataSetnmlogradouro: TStringField;
    DataSetdscomplemento: TStringField;
  strict private
    { Private declarations }
    class var FInstance: TDAOEnderecos;
    constructor PrivateCreate;
  public
    { Public declarations }
    class function GetInstance:TDAOEnderecos;

    constructor Create;
    destructor  Destroy; override;
  end;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

{ TDAOEnderecos }

constructor TDAOEnderecos.Create;
begin
  raise Exception.Create('Para obter uma instancia de DAO pessoas invoque o m�todo GetIntance');
end;

destructor TDAOEnderecos.Destroy;
begin
  inherited;
end;

class function TDAOEnderecos.GetInstance: TDAOEnderecos;
begin
  if not Assigned(FInstance) then
    FInstance:= TDAOEnderecos.PrivateCreate;

  Result:= FInstance;
end;

constructor TDAOEnderecos.PrivateCreate;
begin
  inherited Create(nil);
end;

end.
