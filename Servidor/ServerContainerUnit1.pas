unit ServerContainerUnit1;

interface

uses System.SysUtils, System.Classes,
  Datasnap.DSServer, Datasnap.DSCommonServer,
  IPPeerServer, IPPeerAPI, Datasnap.DSAuth;

type
  TServerContainer1 = class(TDataModule)
    DSServer1: TDSServer;
    DSSCPessoa: TDSServerClass;
    DSSVEndereco: TDSServerClass;
    DSSCViaCep: TDSServerClass;
    procedure DSServerClass1GetClass(DSServerClass: TDSServerClass;
      var PersistentClass: TPersistentClass);
    procedure DSSCPessoaGetClass(DSServerClass: TDSServerClass;
      var PersistentClass: TPersistentClass);
    procedure DSSVEnderecoGetClass(DSServerClass: TDSServerClass;
      var PersistentClass: TPersistentClass);
    procedure DSSCViaCepGetClass(DSServerClass: TDSServerClass;
      var PersistentClass: TPersistentClass);
  private
    { Private declarations }
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

function DSServer: TDSServer;

implementation


{$R *.dfm}

uses
  SMEndereco, SMPessoa, SMViaCep;

var
  FModule: TComponent;
  FDSServer: TDSServer;

function DSServer: TDSServer;
begin
  Result := FDSServer;
end;

constructor TServerContainer1.Create(AOwner: TComponent);
begin
  inherited;
  FDSServer := DSServer1;
end;

destructor TServerContainer1.Destroy;
begin
  inherited;
  FDSServer := nil;
end;

procedure TServerContainer1.DSSCPessoaGetClass(DSServerClass: TDSServerClass;
  var PersistentClass: TPersistentClass);
begin
  PersistentClass:= SMPessoa.TSMPessoa;
end;

procedure TServerContainer1.DSSCViaCepGetClass(DSServerClass: TDSServerClass;
  var PersistentClass: TPersistentClass);
begin
  PersistentClass:= SMViaCep.TSMViaCep;
end;

procedure TServerContainer1.DSServerClass1GetClass(
  DSServerClass: TDSServerClass; var PersistentClass: TPersistentClass);
begin
//  PersistentClass := ServerMethodsUnit1.testedelphi;
end;

procedure TServerContainer1.DSSVEnderecoGetClass(DSServerClass: TDSServerClass;
  var PersistentClass: TPersistentClass);
begin
  PersistentClass:= SMEndereco.TSMEndereco;
end;

initialization
  FModule := TServerContainer1.Create(nil);
finalization
  FModule.Free;
end.

