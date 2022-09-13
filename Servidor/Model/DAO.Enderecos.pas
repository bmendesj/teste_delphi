unit DAO.Enderecos;

interface

uses
  System.SysUtils, System.Generics.Collections, System.JSON,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.Phys.PG, FireDAC.Phys.PGDef, FireDAC.VCLUI.Wait,
  Data.DB, FireDAC.Comp.Client, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet;

type
  TDAOEnderecos = class
  private
    fConector: TFDConnection;
  public
    function Get(const aFiltro: TPair<string, string>; aIdPaginacao: Int64 = -1): TJSONArray;
    function Insert(aJsonArray: TJSONArray): integer;
    function Update(const aId: Int64; aJsonArray: TJSONArray): Integer;
    function Delete(const aId: Int64): Integer;

    constructor Create(aConector: TFDConnection);
    destructor Destroy; override;
  published
  end;

implementation

{ TDAOEnderecos }

uses DAO.DMConexao, uJsonDataSetHelper;

constructor TDAOEnderecos.Create(aConector: TFDConnection);
begin
  fConector:= aConector;
end;

destructor TDAOEnderecos.Destroy;
begin

  inherited;
end;

function TDAOEnderecos.Get(const aFiltro: TPair<string, string>; aIdPaginacao: Int64 = -1): TJSONArray;
const
  _sql = 'SELECT ' +
         '  e.idendereco, ' +
         '  e.idpessoa, ' +
         '  e.dscep, ' +
         '  i.dsuf, ' +
         '  i.nmcidade, ' +
         '  i.nmbairro, ' +
         '  i.nmlogradouro, ' +
         '  i.dscomplemento ' +
         'FROM teste_delphi.endereco AS e ' +
         '  JOIN teste_delphi.endereco_integracao AS i ON (i.idendereco = e.idendereco)';
begin
  Result:= nil;

  try
    DMConexao.fdqEndereco.SQL.Clear;
    DMConexao.fdqEndereco.SQL.Add(_sql);
    DMConexao.fdqEndereco.SQL.Add('WHERE');
    DMConexao.fdqEndereco.SQL.Add('  e.' + aFiltro.Key + ' = ' + aFiltro.Value);

    if aIdPaginacao > -1 then
      DMConexao.fdqEndereco.SQL.Add('  AND e.idendereco >= ' + aIdPaginacao.ToString);

    DMConexao.fdqEndereco.SQL.Add('ORDER BY e.idendereco');

    if (aIdPaginacao > -1) then
      DMConexao.fdqEndereco.SQL.Add('LIMIT ' + _LIMIT.ToString);

    DMConexao.fdqEndereco.Open;

    Result:= DMConexao.fdqEndereco.ToJsonArray;
  except on E: Exception do
    raise;
  end;
end;

function TDAOEnderecos.Insert(aJsonArray: TJSONArray): integer;
const
  _sql = 'CALL teste_delphi.endereco_enderecoIntegracao(' +
         '  :idpessoa, ' +
         '  :dscep, ' +
         '  :dsuf, ' +
         '  :nmcidade, ' +
         '  :nmbairro, ' +
         '  :nmlogradouro, ' +
         '  :dscomplemento' +
         ')';
var
  jValores: TJSONValue;
  idx:      Integer;
begin
  idx:= 0;

  try
    fConector.StartTransaction;

    DMConexao.fdqEndereco.SQL.Clear;
    DMConexao.fdqEndereco.SQL.Add(_sql);
    DMConexao.fdqEndereco.Params.ArraySize:= aJsonArray.Count;

    for jValores in aJsonArray do
    begin
      DMConexao.fdqEndereco.ParamByName('idpessoa').AsLargeInts[idx]:=  jValores.GetValue<Largeint>('idpessoa');
      DMConexao.fdqEndereco.ParamByName('dscep').AsStrings[idx]:=         jValores.GetValue<string>('dscep');
      DMConexao.fdqEndereco.ParamByName('dsuf').AsStrings[idx]:=          jValores.GetValue<string>('dsuf');
      DMConexao.fdqEndereco.ParamByName('nmcidade').AsStrings[idx]:=      jValores.GetValue<string>('nmcidade');
      DMConexao.fdqEndereco.ParamByName('nmbairro').AsStrings[idx]:=      jValores.GetValue<string>('nmbairro');
      DMConexao.fdqEndereco.ParamByName('nmlogradouro').AsStrings[idx]:=  jValores.GetValue<string>('nmlogradouro');
      DMConexao.fdqEndereco.ParamByName('dscomplemento').AsStrings[idx]:= jValores.GetValue<string>('dscomplemento');

      Inc(idx);
    end;

    if idx > 0 then
      DMConexao.fdqEndereco.Execute(idx);

    DMConexao.fdqEndereco.SQL.Clear;
    DMConexao.fdqEndereco.SQL.Add('SELECT currval(pg_get_serial_sequence('+ QuotedStr('teste_delphi.endereco') + ',' + QuotedStr('idendereco') + ')) AS idendereco');
    DMConexao.fdqEndereco.Open;

    Result:= DMConexao.fdqEndereco.FieldByName('idendereco').AsLargeInt;

    fConector.Commit;
  except
    on E: Exception do
    begin
      fConector.Rollback;
      raise;
    end;
  end;
end;

function TDAOEnderecos.Update(const aId: Int64; aJsonArray: TJSONArray): Integer;
const
  _sqlEndereco =
    'UPDATE teste_delphi.endereco ' +
    'SET ' +
    '  idpessoa = :idpessoa, ' +
    '  dscep    = :dscep ' +
    'WHERE idendereco = :idendereco';

  _sqlEnderecoIntegracao =
    'UPDATE teste_delphi.endereco_integracao ' +
    'SET ' +
    '  dsuf          = :dsuf, ' +
    '  nmcidade      = :nmcidade, ' +
    '  nmbairro      = :nmbairro, ' +
    '  nmlogradouro  = :nmlogradouro, ' +
    '  dscomplemento = :dscomplemento ' +
    'WHERE idendereco = :idendereco';
var
  lValores: TJSONValue;
begin
{
  Foi mantido o usso do jsonArray para futuramente suportar a atualiza��o de multiplos resgistros
  essa altera��os ser� feita com a criar de uma fun��o concorrente (overload)
}
  Result:= 0;

  try
    lValores:= aJsonArray.Items[0];

    fConector.StartTransaction;

    DMConexao.fdqEndereco.SQL.Clear;
    DMConexao.fdqEndereco.SQL.Add(_sqlEndereco);
    DMConexao.fdqEndereco.ParamByName('idendereco').AsLargeInt:=   aId;
    DMConexao.fdqEndereco.ParamByName('idpessoa').AsLargeInt:= lValores.GetValue<Largeint>('idpessoa');
    DMConexao.fdqEndereco.ParamByName('dscep').AsString:=      lValores.GetValue<string>('dscep');
    DMConexao.fdqEndereco.ExecSQL;

    DMConexao.fdqEndereco.SQL.Clear;
    DMConexao.fdqEndereco.SQL.Add(_sqlEnderecoIntegracao);
    DMConexao.fdqEndereco.ParamByName('idendereco').AsLargeInt:=  aId;
    DMConexao.fdqEndereco.ParamByName('dsuf').AsString:=          lValores.GetValue<string>('dsuf');
    DMConexao.fdqEndereco.ParamByName('nmcidade').AsString:=      lValores.GetValue<string>('nmcidade');
    DMConexao.fdqEndereco.ParamByName('nmbairro').AsString:=      lValores.GetValue<string>('nmbairro');
    DMConexao.fdqEndereco.ParamByName('nmlogradouro').AsString:=   lValores.GetValue<string>('nmlogradouro');
    DMConexao.fdqEndereco.ParamByName('dscomplemento').AsString:= lValores.GetValue<string>('dscomplemento');
    DMConexao.fdqEndereco.ExecSQL;

    fConector.Commit;

    Result:= aJsonArray.Count;
  except
    on E: Exception do
    begin
      fConector.Rollback;
      raise;
    end;
  end;
end;

function TDAOEnderecos.Delete(const aId: Int64): Integer;
const
  _sql = 'DELETE FROM teste_delphi.endereco	WHERE idendereco = :idendereco';
begin
{
  O retorno foi mantido como inteiro para que futuramente a fun��o possa ser
  alterada para suportar a dele��o de multiplos registros
}
  Result:= 0;

  try
    fConector.StartTransaction;

    DMConexao.fdqEndereco.SQL.Clear;
    DMConexao.fdqEndereco.SQL.Add(_sql);

    DMConexao.fdqEndereco.ParamByName('idendereco').AsLargeInt:=   aId;

    DMConexao.fdqEndereco.ExecSQL;

    fConector.Commit;

    Result:= 1;
  except
    on E: Exception do
    begin
      fConector.Rollback;
      raise;
    end;
  end;
end;

end.