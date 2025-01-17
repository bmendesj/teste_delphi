unit DAO.Pessoas;

interface

uses
  System.SysUtils, System.Classes, REST.Types,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, REST.Response.Adapter, REST.Client, Data.Bind.Components,
  Data.Bind.ObjectScope, System.JSON;

type
  TDAOPessoas = class(TDataModule)
    Adapter: TRESTResponseDataSetAdapter;
    DataSet: TFDMemTable;
    DataSource: TDataSource;
    Client: TRESTClient;
    Request: TRESTRequest;
    Response: TRESTResponse;
    DataSetidpessoa: TLargeintField;
    DataSetflnatureza: TSmallintField;
    DataSetdsdocumento: TStringField;
    DataSetnmprimeiro: TStringField;
    DataSetnmsegundo: TStringField;
    DataSetdtregistro: TDateField;
  strict private
    { Private declarations }
    class var FInstance: TDAOPessoas;
    constructor PrivateCreate;
  public
    { Public declarations }
    class function GetInstance:TDAOPessoas;

    constructor Create;
    destructor  Destroy; override;
  end;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

{ TDAOPessoas }

constructor TDAOPessoas.Create;
begin
  raise Exception.Create('Para obter uma instancia de DAO pessoas invoque o m�todo GetIntance');
end;

destructor TDAOPessoas.Destroy;
begin
  inherited;
end;

class function TDAOPessoas.GetInstance: TDAOPessoas;
begin
  if not Assigned(FInstance) then
    FInstance:= TDAOPessoas.PrivateCreate;

  Result:= FInstance;
end;

constructor TDAOPessoas.PrivateCreate;
begin
  inherited Create(nil);
end;

end.
