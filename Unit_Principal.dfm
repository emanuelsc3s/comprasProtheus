object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 307
  ClientWidth = 562
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object btn_IntegrarPedidos: TButton
    Left = 479
    Top = 274
    Width = 75
    Height = 25
    Caption = 'Importar'
    TabOrder = 0
    OnClick = btn_IntegrarPedidosClick
  end
  object DBGrid1: TDBGrid
    Left = 8
    Top = 8
    Width = 546
    Height = 260
    DataSource = DataSource1
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
  end
  object DataSource1: TDataSource
    AutoEdit = False
    DataSet = PedidoSIC
    Left = 272
    Top = 160
  end
  object PedidoSIC: TFDQuery
    Connection = dm1.FDConnection
    SQL.Strings = (
      'select'
      
        '  i.status, p.pedido_id, p.emissao, i.qtde, i.produto_id, pr.ref' +
        'erencia as ERP_PRODUTO, i.produto,'
      
        '   pr.unidade, i.preco, i.total, f.erp_codigo, c.erp_codigo as E' +
        'RP_COND'
      'from tbpedido p'
      
        '  inner join tbpedido_item i on p.pedido_id = i.pedido_id and i.' +
        'deletado = '#39'N'#39
      
        '  inner join tbprodutos pr on pr.produto_id = i.produto_id and p' +
        'r.deletado = '#39'N'#39
      
        '  inner join tbpessoas f on f.pessoa_id = p.pessoa_id and f.dele' +
        'tado = '#39'N'#39
      
        '  left join tbcondpagto c on c.condpagto_id = p.condpagto_id and' +
        ' c.deletado = '#39'N'#39
      'where p.deletado = '#39'N'#39
      '  and (p.SYNC IS NULL OR p.SYNC = '''' OR p.SYNC = ''S'')'
      '  and (i.SYNC IS NULL OR i.SYNC = '''' OR i.SYNC = ''S'')'
      ' -- and p.entrada_saida = '#39'E'#39
      '  --and p.emissao >= '#39'01.01.2024'#39
      '  --and i.status = '#39'Aprovado'#39
      'and p.pedido_id = 41524')
    Left = 272
    Top = 112
  end
  object QueryTOTVS: TADOQuery
    Connection = dm1.ADOConnection
    Parameters = <>
    Left = 392
    Top = 112
  end
end
