unit ClassesInterfaces;

interface
uses Vcl.Dialogs,System.SysUtils,classes,Vcl.StdCtrls,Vcl.Grids, Vcl.Controls;


type TProduto = class
  public
  Id:integer;
  Uni:string;
  Descricao:string;
  preco:currency;
  Qtd:currency;
end;


type IItensPedido = Interface
['{C3920281-6A82-4D71-8B6D-72BD5AB646D6}']

function  GetId():integer;
function  GetUni():string;
function  GetDescricao():string;
function  GetPreco():currency;
function  GetQtd():currency;
function  ListarItens():TStringGrid;  
function  Validar():Boolean;

Procedure CarregarLista; 
procedure SetId(pId:integer);
procedure SetUni(pUni:string);
procedure SetDescricao(pDescricao:string);
procedure SetPreco(pPreco:currency);
procedure SetQtd(pPreco:currency);

procedure Incluir();


property  Id:integer        read GetId        write SetId;
property  Uni:string        read GetUni       write SetUni;
property  Descricao:string  read GetDescricao write SetDescricao;
property  Preco:currency    read GetPreco     write  SetPreco;
property  Qtd:currency      read GetQtd       write  SetQtd;



End;

type TItensPedido=class(TInterfacedObject,IItensPedido)
private
  FId       :integer;
  FUni      :string;
  FDescricao:string;
  FPreco    :currency;
  FQtd      :Currency;
  FDb       :TList;
  FGrid     :TStringGrid;
public
 
  function  GetId():integer;
  function  GetUni():string;
  function  GetDescricao():string;
  function  GetPreco():currency;
  function  GetQtd():currency; 
  function  Validar():Boolean;
  function  ListarItens():TStringGrid; 

  procedure SetId(pId:integer);
  procedure SetUni(pUni:string);
  procedure SetDescricao(pDescricao:string);
  procedure SetPreco(pPreco:currency);
  procedure SetQtd(pQtd:currency);
  Procedure CarregarLista;     
  procedure Incluir();
  

  property  Id:integer        read GetId        write  SetId;
  property  Uni:string        read GetUni       write  SetUni;
  property  Descricao:string  read GetDescricao write  SetDescricao;
  property  Preco:currency    read GetPreco     write  SetPreco;
  property  Qtd:currency      read GetQtd       write  SetQtd;

  
end;

type TPedido = class
private
  FItens    :IItensPedido;   
 public
 PPGrid :TStringGrid;
 
  constructor Create(pItens:IItensPedido);
  function    IncluirProduto():boolean;
  function    listarProduto():TStringGrid;

end;


implementation


{ TPedido }

constructor TPedido.Create(pItens:IItensPedido);
begin
 //inje??o de depend?ncia via construtor
 FItens  := pItens;

end;
function TPedido.IncluirProduto():boolean;
var
res:boolean;
begin

  res:=false;

     if(FItens.Validar=true)then
     begin
       FItens.Incluir;
       res:=true;
     end;

   Result:=res;  
     
end;
Function TPedido.listarProduto():TStringGrid;
begin 

   PPGrid:=FItens.ListarItens;  
   PPGrid.Align:=alClient;
   Result:= PPGrid;
       
end;              


{ TItensPedido }

function TItensPedido.GetDescricao: string;
begin
    Result:= FDescricao;
end;

function TItensPedido.GetId: integer;
begin
    Result:= FId;
end;

function TItensPedido.GetPreco: currency;
begin
    Result:= FPreco;
end;
function TItensPedido.GetQtd: currency;
begin
    Result:= FQtd;
end;

function TItensPedido.GetUni: string;
begin
    Result:=FUni;
end;

procedure TItensPedido.SetDescricao(pDescricao:string);
begin
    FDescricao:=pDescricao;
end;

procedure TItensPedido.SetId(pId:integer);
begin
     FId:=pId;
end;

procedure TItensPedido.SetPreco(pPreco:currency);
begin
      FPreco :=pPreco;
end;
procedure TItensPedido.SetQtd(pQtd:currency);
begin
      FQtd :=pQtd;
end;

procedure TItensPedido.SetUni(pUni:string);
begin
     FUni :=pUni;
end;

function TItensPedido.Validar: Boolean;
var
retorno:Boolean;
begin

  retorno:=true;

        if FPreco = 0 then
        begin
          ShowMessage('Pre?o deve ser maior que zero!');
          retorno:=false;
        end;

        if FDescricao = string.Empty then
        begin
          ShowMessage('Produto sem descri??o!');
          retorno:=false;
        end; 

          if FQtd = 0 then
        begin
          ShowMessage('Qtd deve ser maior que zero!');
          retorno:=false;
        end;

          if FUni = string.Empty then
        begin
          ShowMessage('Produto sem unidade!');
          retorno:=false;
        end;

  Result:= retorno;

end;
procedure TItensPedido.Incluir();
var
p:TProduto;
begin

    p:=TProduto.Create;
    p.Id:=FId;
    p.Uni:=FUni;
    p.Descricao:= FDescricao;
    p.preco:= Fpreco;
    p.Qtd:= FQtd;

    FDb.Add(p);
    ShowMessage('Inclu?do no DB !');

end;

procedure TItensPedido.CarregarLista();
begin
 FDb:=TList.Create;
end;
function TItensPedido.ListarItens():TStringGrid;
var
i   :integer;
begin
  
     
     FGrid         :=TStringGrid.Create(nil);
     FGrid.ColCount:=5;
     FGrid.Cells[0,0]:='Id';
     FGrid.ColWidths[1]:=250;
     FGrid.Cells[1,0]:='DESCRI??O';
     FGrid.Cells[2,0]:='UNI';
     FGrid.Cells[3,0]:='PRE?O';
     FGrid.Cells[4,0]:='QTD';
     FGrid.RowCount:=1;
         
     for I := 0 to FDb.Count-1 do
     begin

          FGrid.RowCount    :=  FGrid.RowCount+1;
          FGrid.Cells[0,i+1]:=  TProduto(FDb.Items[i]).Id.ToString();
          FGrid.Cells[1,i+1]:=  TProduto(FDb.Items[i]).Descricao;
          FGrid.Cells[2,i+1]:=  TProduto(FDb.Items[i]).Uni;
          FGrid.Cells[3,i+1]:=  FormatCurr('####0.00',TProduto(FDb.Items[i]).Qtd);
          FGrid.Cells[4,i+1]:=  FormatCurr('####0.00',TProduto(FDb.Items[i]).preco);
      
      end;
             
     result:=  FGrid;
     
end;


end.
