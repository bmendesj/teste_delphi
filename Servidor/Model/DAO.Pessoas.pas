unit DAO.Pessoas;

interface

uses
  System.SysUtils, System.JSON, System.Generics.Collections,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.Phys.PG, FireDAC.Phys.PGDef, FireDAC.VCLUI.Wait,
  Data.DB, FireDAC.Comp.Client, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet;

type
  TDAOPessoas = class
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

{ TDAOPessoas }

uses DAO.DMConexao, uJsonDataSetHelper;

constructor TDAOPessoas.Create(aConector: TFDConnection);
begin
  fConector:= aConector;
end;

destructor TDAOPessoas.Destroy;
begin

  inherited;
end;

function TDAOPessoas.Get(const aFiltro: TPair<string, string>; aIdPaginacao: Int64 = -1): TJSONArray;
const
  _sql = 'SELECT * FROM teste_delphi.pessoa';
begin
  Result:= nil;

  try
    DMConexao.fdqPessoa.SQL.Clear;
    DMConexao.fdqPessoa.SQL.Add(_sql);

    if (aFiltro.Key.Length > 0) or (aIdPaginacao > -1) then
      DMConexao.fdqPessoa.SQL.Add('WHERE');

    if aFiltro.Key.Length  > 0 then
      DMConexao.fdqPessoa.SQL.Add('  ' + aFiltro.Key + ' = ' + aFiltro.Value)
    else
      if aIdPaginacao > -1 then
        DMConexao.fdqPessoa.SQL.Add('  idpessoa >= ' + aIdPaginacao.ToString);


    DMConexao.fdqPessoa.SQL.Add('ORDER BY idpessoa');

    if (aFiltro.Key.Length = 0) and (aIdPaginacao > -1) then
      DMConexao.fdqPessoa.SQL.Add('LIMIT ' + _LIMIT.ToString);

    DMConexao.fdqPessoa.Open;

    Result:= DMConexao.fdqPessoa.ToJsonArray;
  except on E: Exception do
    raise;
  end;
end;

function TDAOPessoas.Insert(aJsonArray: TJSONArray): integer;
const
  _sql = 'CALL teste_delphi.pessoa_endereco(' +
         '  :flnatureza, ' +
         '  :dsdocumento, ' +
         '  :nmprimeiro, ' +
         '  :nmsegundo, ' +
         '  :dtregistro, ' +
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

    DMConexao.fdqPessoa.SQL.Clear;
    DMConexao.fdqPessoa.SQL.Add(_sql);
    DMConexao.fdqPessoa.Params.ArraySize:= aJsonArray.Count;

    for jValores in aJsonArray do
    begin
      DMConexao.fdqPessoa.ParamByName('flnatureza').AsSmallInts[idx]:=  jValores.GetValue<SmallInt>('flnatureza');
      DMConexao.fdqPessoa.ParamByName('dsdocumento').AsStrings[idx]:=   jValores.GetValue<string>('dsdocumento');
      DMConexao.fdqPessoa.ParamByName('nmprimeiro').AsStrings[idx]:=    jValores.GetValue<string>('nmprimeiro');
      DMConexao.fdqPessoa.ParamByName('nmsegundo').AsStrings[idx]:=     jValores.GetValue<string>('nmsegundo');
      DMConexao.fdqPessoa.ParamByName('dtregistro').AsDates[idx]:=      StrToDate(jValores.GetValue<string>('dtregistro'));
      DMConexao.fdqPessoa.ParamByName('dscep').AsStrings[idx]:=         jValores.GetValue<string>('dscep');
      DMConexao.fdqPessoa.ParamByName('dsuf').AsStrings[idx]:=          jValores.GetValue<string>('dsuf');
      DMConexao.fdqPessoa.ParamByName('nmcidade').AsStrings[idx]:=      jValores.GetValue<string>('nmcidade');
      DMConexao.fdqPessoa.ParamByName('nmbairro').AsStrings[idx]:=      jValores.GetValue<string>('nmbairro');
      DMConexao.fdqPessoa.ParamByName('nmlogradouro').AsStrings[idx]:=  jValores.GetValue<string>('nmlogradouro');
      DMConexao.fdqPessoa.ParamByName('dscomplemento').AsStrings[idx]:= jValores.GetValue<string>('dscomplemento');

      Inc(idx);
    end;

    if idx > 0 then
      DMConexao.fdqPessoa.Execute(idx);

    DMConexao.fdqPessoa.SQL.Clear;
    DMConexao.fdqPessoa.SQL.Add('SELECT currval(pg_get_serial_sequence('+ QuotedStr('teste_delphi.pessoa') + ',' + QuotedStr('idpessoa') + ')) AS idpessoa');
    DMConexao.fdqPessoa.Open;

    Result:= DMConexao.fdqPessoa.FieldByName('idpessoa').AsLargeInt;

    fConector.Commit;
  except
    on E: Exception do
    begin
      fConector.Rollback;
      raise;
    end;
  end;
end;

function TDAOPessoas.Update(const aId: Int64; aJsonArray: TJSONArray): Integer;
const
  _sql = 'UPDATE teste_delphi.pessoa ' +
         'SET ' +
         '  flnatureza  = :flnatureza, ' +
         '  dsdocumento = :dsdocumento, ' +
         '  nmprimeiro  = :nmprimeiro, ' +
         '  nmsegundo   = :nmsegundo, ' +
         '  dtregistro  = :dtregistro ' +
         'WHERE idpessoa = :idPessoa';
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

    DMConexao.fdqPessoa.SQL.Clear;
    DMConexao.fdqPessoa.SQL.Add(_sql);

    DMConexao.fdqPessoa.ParamByName('idpessoa').AsLargeInt:=   aId;
    DMConexao.fdqPessoa.ParamByName('flnatureza').AsSmallInt:= lValores.GetValue<SmallInt>('flnatureza');
    DMConexao.fdqPessoa.ParamByName('dsdocumento').AsString:=  lValores.GetValue<string>('dsdocumento');
    DMConexao.fdqPessoa.ParamByName('nmprimeiro').AsString:=   lValores.GetValue<string>('nmprimeiro');
    DMConexao.fdqPessoa.ParamByName('nmsegundo').AsString:=    lValores.GetValue<string>('nmsegundo');
    DMConexao.fdqPessoa.ParamByName('dtregistro').AsDate:=     StrToDate(lValores.GetValue<string>('dtregistro'));

    DMConexao.fdqPessoa.ExecSQL;

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

function TDAOPessoas.Delete(const aId: Int64): Integer;
const
  _sql = 'DELETE FROM teste_delphi.pessoa	WHERE idpessoa = :idpessoa';
begin
{
  O retorno foi mantido como inteiro para que futuramente a fun��o possa ser 
  alterada para suportar a dele��o de multiplos registros
}
  Result:= 0;

  try
    fConector.StartTransaction;
    
    DMConexao.fdqPessoa.SQL.Clear;
    DMConexao.fdqPessoa.SQL.Add(_sql);

    DMConexao.fdqPessoa.ParamByName('idpessoa').AsLargeInt:=   aId;

    DMConexao.fdqPessoa.ExecSQL;

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
