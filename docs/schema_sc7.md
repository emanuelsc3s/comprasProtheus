## Documentação do Schema SC7 (Protheus)

### Visão Geral
A tabela SC7 (Ped.Compra / Aut.Entrega) armazena os itens de pedidos de compra e autorizações de entrega no ERP TOTVS Protheus. Cada registro representa um item vinculado a um pedido (PC) ou a uma autorização de entrega (AE), contendo informações de produto, quantidades, preços, impostos, condições comerciais, logística e controle.

### Índice
- [Campos principais e chaves](#campos-principais-e-chaves)
- [Todos os campos](#todos-os-campos)
- [Notas e convenções](#notas-e-convenções)

### Campos principais e chaves
Campos que compõem a chave primária (Índice 1) da SC7. Estes campos estão em negrito e identificados como PK.

| Campo | Título | Descrição | Tipo | Contexto | Tamanho | Obrigatório | Notas |
|:--|:--|:--|:--:|:--:|--:|:--:|:--|
| **C7_FILIAL** | Filial | Filial do Sistema | C | Real | 2 | N/D | PK |
| **C7_NUM** | Numero PC | Numero do pedido de compr | C | Real | 6 | N/D | PK |
| **C7_ITEM** | Item | Item do pedido de compra | C | Real | 4 | N/D | PK |
| **C7_SEQUEN** | Sequencia | Sequencia | C | Real | 4 | N/D | PK |

### Todos os campos
Tabela completa com as propriedades dos campos conforme fonte analisada. Coluna “Obrigatório” não informada na origem.

| Campo | Título | Descrição | Tipo | Contexto | Tamanho | Obrigatório | Notas |
|:--|:--|:--|:--:|:--:|--:|:--:|:--|
| **C7_FILIAL** | Filial | Filial do Sistema | C | Real | 2 | N/D | PK |
| C7_TIPCLEG | Legenda | Legenda | C | Virtual | 13 | N/D | Virtual |
| C7_TIPO | Tipo | Controle de PC ou AE | N | Real | 1 | N/D |  |
| **C7_ITEM** | Item | Item do pedido de compra | C | Real | 4 | N/D | PK |
| C7_PRODUTO | Produto | Codigo do produto | C | Real | 15 | N/D |  |
| C7_UM | Unidade | Unidade de medida | C | Real | 2 | N/D |  |
| C7_SEGUM | Segunda UM | Segunda Unidade de Medida | C | Real | 2 | N/D |  |
| C7_QUANT | Quantidade | Quantidade pedida | N | Real | 12, 2 | N/D |  |
| C7_CODTAB | Tab.Preco | Tabela de Preco | C | Real | 3 | N/D |  |
| C7_PRECO | Prc Unitario | Preco unitario do item | N | Real | 14, 2 | N/D |  |
| C7_TOTAL | Vlr.Total | Valor total do item | N | Real | 14, 2 | N/D |  |
| C7_QTSEGUM | Qtd. 2a UM | Qtde na Segunda Unidade | N | Real | 12, 2 | N/D |  |
| C7_IPI | Aliq. IPI | Aliquota de IPI | N | Real | 5, 2 | N/D |  |
| C7_NUMSC | Numero da SC | Numero da solicita.compra | C | Real | 6 | N/D |  |
| C7_ITEMSC | Item da SC | Item da solicita.compra | C | Real | 4 | N/D |  |
| C7_DINITRA | Dt. Ini. Tra | Data inicio de transito | D | Real | 8 | N/D |  |
| C7_DINICOM | Dt. Ini. Com | Data p/ inicio da compra | D | Real | 8 | N/D |  |
| C7_DINICQ | Dt. Ini. CQ | Data inicio de CQ | D | Real | 8 | N/D |  |
| C7_DATPRF | Dt. Entrega | Data Entrega | D | Real | 8 | N/D |  |
| C7_LOCAL | Armazem | Armazem | C | Real | 2 | N/D |  |
| C7_OBSM | Observacoes | Observacoes do item | M | Real | 50 | N/D |  |
| C7_OBS | Observacoes | Observacoes | C | Real | 30 | N/D |  |
| C7_FORNECE | Fornecedor | Codigo do fornecedor | C | Real | 6 | N/D |  |
| C7_LOJA | Loja | Loja do fornecedor | C | Real | 2 | N/D |  |
| C7_CONTA | Cta Contabil | Conta Contabil do Produto | C | Real | 20 | N/D |  |
| C7_ITEMCTA | Item Conta | Item da Conta Contabil | C | Real | 9 | N/D |  |
| C7_CC | Centro Custo | Centro de Custo | C | Real | 9 | N/D |  |
| C7_COND | Cond. Pagto | Codigo da condicao de Pgt | C | Real | 3 | N/D |  |
| C7_CONTATO | Contato | Contato | C | Real | 15 | N/D |  |
| C7_FILENT | Filial Entr. | Filial para Entrega | C | Real | 2 | N/D |  |
| C7_DESC1 | Desconto 1 | Desconto 1 em cascata | N | Real | 5, 2 | N/D |  |
| C7_DESC2 | Desconto 2 | Desconto 2 em cascata | N | Real | 5, 2 | N/D |  |
| C7_DESC3 | Desconto 3 | Desconto 3 em cascata | N | Real | 5, 2 | N/D |  |
| C7_EMISSAO | DT Emissao | Data de Emissao | D | Real | 8 | N/D |  |
| **C7_NUM** | Numero PC | Numero do pedido de compr | C | Real | 6 | N/D | PK |
| C7_QUJE | Qtd.Entregue | Quantidade ja' entregue | N | Real | 12, 2 | N/D |  |
| C7_REAJUST | Reajuste | Codigo da formula do reaj | C | Real | 3 | N/D |  |
| C7_FRETE | Vlr.Frete | Valor do frete combinado | N | Real | 14, 2 | N/D |  |
| C7_EMITIDO | Ja' emitiu | 'S' se ja'emitiu | C | Real | 1 | N/D |  |
| C7_DESCRI | Descricao | Descricao do Produto | C | Real | 50 | N/D |  |
| C7_TPFRETE | Tipo Frete | Tipo do Frete Utilizado | C | Real | 1 | N/D |  |
| C7_QTDREEM | Reemissao | Quantidade de Reemissoes | N | Real | 2 | N/D |  |
| C7_CODLIB | Liberacao | Codigo de Liberacao | C | Real | 10 | N/D |  |
| C7_RESIDUO | Resid. Elim. | PC com Residuo Eliminado. | C | Real | 1 | N/D |  |
| C7_NUMCOT | Num.Cotacao | Numero da Cotacao | C | Real | 6 | N/D |  |
| C7_MSG | Mensagem | Mensagem para Pedido | C | Real | 3 | N/D |  |
| C7_TX | Transmissao | Flag para Transmissao | C | Real | 2 | N/D |  |
| C7_CONTROL | Controle | Campo de Controle | C | Real | 1 | N/D |  |
| C7_IPIBRUT | Cons. Desc. | Considera Desconto p/IPI | C | Real | 1 | N/D |  |
| C7_ENCER | Ped. Encerr. | Pedido Encerrado | C | Real | 1 | N/D |  |
| C7_OP | OP. | Ordem de Producao | C | Real | 14 | N/D |  |
| C7_VLDESC | Vl. Desconto | Valor do Desconto do item | N | Real | 14, 2 | N/D |  |
| **C7_SEQUEN** | Sequencia | Sequencia | C | Real | 4 | N/D | PK |
| C7_NUMIMP | Num.Purch.Or | Numero do Purch. Order | C | Real | 20 | N/D |  |
| C7_ORIGEM | Rotina Gerad | Rotina Geradora | C | Real | 8 | N/D |  |
| C7_QTDACLA | Qtd.a Classi | Qtde a Classificar | N | Real | 12, 2 | N/D |  |
| C7_VALEMB | Vlr Embalag. | Valor da Embalagem | N | Real | 16, 2 | N/D |  |
| C7_FLUXO | Fluxo Caixa | Fluxo de Caixa (S/N) | C | Real | 1 | N/D |  |
| C7_TPOP | Tipo Op | Tipo da Ordem de Producao | C | Real | 1 | N/D |  |
| C7_APROV | Grupo Aprov. | Grupo de Aprovacao | C | Real | 6 | N/D |  |
| C7_CONAPRO | Controle Ap. | Controle de Aprovacao | C | Real | 1 | N/D |  |
| C7_GRUPCOM | Gr. Compras | Grupo de Compradores | C | Real | 6 | N/D |  |
| C7_USER | Cod. Usuario | Codigo do Usuario | C | Real | 6 | N/D |  |
| C7_STATME | Status do ME | Status do Mercado Eletr. | C | Real | 1 | N/D |  |
| C7_RESREM | Elim. Reman. | Eliminado por Remanescent | C | Real | 1 | N/D |  |
| C7_OK | Ok | Ok para geracao do ME | C | Real | 2 | N/D |  |
| C7_QTDSOL | Qtde da SC | Quantidade pedida da SC | N | Real | 12, 2 | N/D |  |
| C7_VALIPI | Vlr.IPI | Valor do IPI do Item | N | Real | 14, 2 | N/D |  |
| C7_VALICM | Vlr.ICMS | Valor do ICMS do item | N | Real | 14, 2 | N/D |  |
| C7_OPER | Tip.Operacao | Tipo de Operacao | C | Virtual | 2 | N/D | Virtual |
| C7_TES | Tipo Entrada | Tipo de entrada da nota | C | Real | 3 | N/D |  |
| C7_DESC | % Desc.Item | Desconto no item | N | Real | 6, 2 | N/D |  |
| C7_PICM | Aliq.ICMS | Aliquota de ICMS | N | Real | 5, 2 | N/D |  |
| C7_BASEICM | Base Icms | Valor Base do ICMS | N | Real | 14, 2 | N/D |  |
| C7_BASEIPI | Vlr.Base IPI | Valor Base de Calc. IPI | N | Real | 14, 2 | N/D |  |
| C7_SEGURO | Vlr.Seguro | Valor do Seguro | N | Real | 14, 2 | N/D |  |
| C7_DESPESA | Vlr.Despesas | Valor das Despesas | N | Real | 14, 2 | N/D |  |
| C7_VALFRE | Vlr.Frete | Valor do frete do item | N | Real | 14, 2 | N/D |  |
| C7_MOEDA | Moeda | Moeda | N | Real | 2 | N/D |  |
| C7_TXMOEDA | Taxa Moeda | Taxa Moeda | N | Real | 11, 4 | N/D |  |
| C7_PENDEN | Pendente | Pendente | C | Real | 1 | N/D |  |
| C7_CLVL | Classe Valor | Classe Valor Contabil | C | Real | 9 | N/D |  |
| C7_BASEIR | Base IRRF | Valor Base de Calc. IRRF | N | Real | 14, 2 | N/D |  |
| C7_ALIQIR | Aliq. IRRF | Aliquota IRRF | N | Real | 5, 2 | N/D |  |
| C7_VALIR | Valor IRRF | Valor de IRRF do Item | N | Real | 14, 2 | N/D |  |
| C7_ICMCOMP | ICMS Compl. | Valor Icms Complementar | N | Real | 14, 2 | N/D |  |
| C7_CODGRP | Grupo | Grupo Veiculos/Oficina | C | Virtual | 4 | N/D | Virtual |
| C7_ICMSRET | ICMS Retido | Valor do ICMS Solidario | N | Real | 14, 2 | N/D |  |
| C7_CODITE | Cod. Produto | Produto Veiculos/Oficina | C | Virtual | 27 | N/D | Virtual |
| C7_BASIMP5 | Base Imp. 5 | Base de Calculo Imposto 5 | N | Real | 14, 2 | N/D |  |
| C7_BASIMP6 | Base Imp. 6 | Base de Calculo Imposto 6 | N | Real | 14, 2 | N/D |  |
| C7_VALSOL | Val. ICMS So | Valor do ICMS Solidario | N | Real | 14, 2 | N/D |  |
| C7_ESTOQUE | Atual.Estoq | Atualiza Estoque | C | Real | 1 | N/D |  |
| C7_SOLICIT | Solicitante | Nome Solicitante | C | Real | 30 | N/D |  |
| C7_VALIMP5 | Valor Imp. 5 | Valor do Imposto 5 | N | Real | 14, 2 | N/D |  |
| C7_VALIMP6 | Valor Imp. 6 | Valor do Imposto 6 | N | Real | 14, 2 | N/D |  |
| C7_SEQMRP | Seq MRP | Seq MRP que originou PC | C | Real | 6 | N/D |  |
| C7_CODORCA | Cod. Orcam. | Codigo do Orcamento | C | Real | 8 | N/D |  |
| C7_DTLANC | Dt. Contab. | Data de Contabilizacao | D | Real | 8 | N/D |  |
| C7_CODCRED | Cod.Credor | Codigo do Credor | C | Real | 6 | N/D |  |
| C7_TIPOEMP | Tipo empenho | Tipo de empenho | C | Real | 1 | N/D |  |
| C7_ESPEMP | Esp.Empenho | Especie de Empenho | C | Real | 1 | N/D |  |
| C7_TRANSP | Cod. Transp. | Codigo da Transportadora | C | Real | 6 | N/D |  |
| C7_TRANSLJ | Loja Transp. | Loja da Transportadora | C | Real | 2 | N/D |  |
| C7_FILCEN | Fil.Central. | Fil.Centraliz.Ped.Compra | C | Real | 2 | N/D |  |
| C7_CONTRA | Num.Contrato | Numero do Contrato | C | Real | 15 | N/D |  |
| C7_CONTREV | Rev.Contrato | Revisao do Contrato | C | Real | 3 | N/D |  |
| C7_PLANILH | Num.Planilha | Numero da Planilha | C | Real | 6 | N/D |  |
| C7_MEDICAO | Num.Medicao | Numero da Medicao | C | Real | 6 | N/D |  |
| C7_ITEMED | Item Medicao | Item da Medicao | C | Real | 10 | N/D |  |
| C7_FREPPCC | Tipo Frete | Tipo Frete | C | Real | 2 | N/D |  |
| C7_POLREPR | Politica Rep | Politica de Reprogramacao | C | Real | 1 | N/D |  |
| C7_PERREPR | Periodo Repr | Periodo de Reprogramacao | N | Real | 3 | N/D |  |
| C7_DT_IMP | Dt Import. | Dt Import. | D | Real | 8 | N/D |  |
| C7_GRADE | Grade | Grade | C | Real | 1 | N/D |  |
| C7_AGENTE | Ag.Embarc. | Agente Embarcador | C | Real | 3 | N/D |  |
| C7_ITEMGRD | Item grade | Item da grade | C | Real | 3 | N/D |  |
| C7_FORWARD | Cod Forward. | Forwarder | C | Real | 3 | N/D |  |
| C7_TIPO_EM | Via Transp. | Via Transp. | C | Real | 3 | N/D |  |
| C7_ORIGIMP | Origem | Origem | C | Real | 3 | N/D |  |
| C7_DEST | Destino | Destino | C | Real | 3 | N/D |  |
| C7_COMPRA | Cod.Comprad. | Comprador | C | Real | 3 | N/D |  |
| C7_PESO_B | Peso Bruto | Peso Bruto | N | Real | 12, 4 | N/D |  |
| C7_INCOTER | Incoterm | Incoterm | C | Real | 3 | N/D |  |
| C7_IMPORT | Importador | Codigo do Importador | C | Real | 3 | N/D |  |
| C7_CONSIG | Cod.Consig. | Codigo do Consignatario | C | Real | 3 | N/D |  |
| C7_CONF_PE | Dt Conf Ped | Data Conf. do Pedido | D | Real | 8 | N/D |  |
| C7_DESP | Despachante | Despachante | C | Real | 3 | N/D |  |
| C7_EXPORTA | Exportador | Exportador | C | Real | 6 | N/D |  |
| C7_LOJAEXP | Exp. Loja | Loja do Exportador | C | Real | 2 | N/D |  |
| C7_CONTAIN | Modal. CNTR | Modalidade de Container | C | Real | 1 | N/D |  |
| C7_MT3 | Vol. Cubado | Volume Cubado | N | Real | 8, 2 | N/D |  |
| C7_CONTA20 | Contain. 20' | Containers de 20' | N | Real | 4 | N/D |  |
| C7_CONTA40 | Contain. 40' | Containers de 40' | N | Real | 4 | N/D |  |
| C7_CON40HC | Cont. 40' hc | Containers de 40 hc | N | Real | 4 | N/D |  |
| C7_ARMAZEM | Armazem | Armazem | C | Real | 7 | N/D |  |
| C7_FABRICA | Fabricante | Fabricante | C | Real | 6 | N/D |  |
| C7_LOJFABR | Fabric. Loja | Loja do Fabricante | C | Real | 2 | N/D |  |
| C7_DT_EMB | Dt Embarque | Dt Embarque | D | Real | 8 | N/D |  |
| C7_TEC | Pos.IPI/NCM | Nomenclatura Ext.Mercosul | C | Real | 10 | N/D |  |
| C7_EX_NCM | Ex-NCM | Ex-NCM - determina % I.I. | C | Real | 3 | N/D |  |
| C7_EX_NBM | Ex-NBM | Ex-NBM - determina % IPI | C | Real | 3 | N/D |  |
| C7_BASESOL | Bs. ICMS Sol | Base do ICMS Solidario | N | Real | 14, 2 | N/D |  |
| C7_DIACTB | Cod Diario | Cod Diario Contabilidade | C | Real | 2 | N/D |  |
| C7_NODIA | Seq. Diario | Seq. Diario | C | Real | 10 | N/D |  |
| C7_PO_EIC | Num. PO | Num. PO EIC | C | Real | 20 | N/D |  |
| C7_CODED | Cod. Edital | Codigo do Edital | C | Real | 15 | N/D |  |
| C7_NUMPR | Nr. Processo | Numero Processo | C | Real | 15 | N/D |  |
| C7_FILEDT | Fil Edital | Filial do Edital | C | Real | 2 | N/D |  |
| C7_DRPIMP | DRP Neogrid? | Ped. import. pelo DRP? | C | Virtual | 3 | N/D | Virtual |
| C7_ALQCF2 | Aliq COF | Aliquota COF | N | Real | 6, 2 | N/D |  |
| C7_ALQCOF | Aliq Cofins | Aliquota Cofins | N | Real | 6, 2 | N/D |  |
| C7_ALQPIS | Aliquota PIS | Aliquota PIS | N | Real | 6, 2 | N/D |  |
| C7_ALQPS2 | Aliq PIS | Aliquota PIS | N | Real | 6, 2 | N/D |  |
| C7_BASCOF | Base Cofins | Base Cofins | N | Real | 14, 2 | N/D |  |
| C7_BASPIS | Base PIS | Base PIS | N | Real | 14, 2 | N/D |  |
| C7_VALCOF | Valor Cofins | Valor Cofins | N | Real | 14, 2 | N/D |  |
| C7_VALPIS | Valor PIS | Valor PIS | N | Real | 14, 2 | N/D |  |
| C7_TIPCOM | Tipo Compra | Tipo de Compra | C | Real | 3 | N/D |  |
| C7_FRETCON | Vl.Fret.Con. | Valor Frete Contratado | N | Real | 14, 2 | N/D |  |
| C7_DEDUCAO | Deducao | Deducao | N | Real | 14, 2 | N/D |  |
| C7_FATDIRE | Fat Direto | Faturamento Direto | N | Real | 14, 2 | N/D |  |
| C7_QUJEDED | Vlr Aten Ded | Vlr atendida deducao | N | Real | 14, 2 | N/D |  |
| C7_QUJEFAT | Vlr Aten Fat | Vlr atendido fat direto | N | Real | 14, 2 | N/D |  |
| C7_QUJERET | Vlr Aten Ret | Vlr atendida retencao | N | Real | 14, 2 | N/D |  |
| C7_RETENCA | Retencao | Retencao | N | Real | 14, 2 | N/D |  |
| C7_CODNE | Cod Nota Emp | Cod. da Nota de Empenho | C | Real | 12 | N/D |  |
| C7_ITEMNE | Item Nt Emp | Item da Nota de Empenho | C | Real | 3 | N/D |  |
| C7_GCPIT | Item Ed | Item do Edital | C | Real | 6 | N/D |  |
| C7_GCPLT | Lote Ed | Lote do Edital | C | Real | 8 | N/D |  |
| C7_BASECSL | Base CSLL | Base CSLL | N | Real | 14, 2 | N/D |  |
| C7_ALIQISS | Aliq. ISS | Aliquota de ISS | N | Real | 5, 2 | N/D |  |
| C7_VALISS | Valor do ISS | Valor do ISS | N | Real | 14, 2 | N/D |  |
| C7_ALIQINS | Aliq. INSS | Aliquota de INSS | N | Real | 5, 2 | N/D |  |
| C7_VALINS | Vlr. do INSS | Valor do Seguro Social | N | Real | 14, 2 | N/D |  |
| C7_ALQCSL | Aliq. CSLL | Aliquota CSLL | N | Real | 6, 2 | N/D |  |
| C7_NUMSA | Nr. S.A. | Numero da Solic.ao Armaz. | C | Real | 6 | N/D |  |
| C7_ACCNUM | Ped. ACC | Pedido ACC | C | Real | 50 | N/D |  |
| C7_ACCITEM | Item ACC | Item Ped. ACC | C | Real | 50 | N/D |  |
| C7_ACCPROC | ACC? | Inidica se esta no ACC. | C | Real | 1 | N/D |  |
| C7_REVISAO | Rev.Estrutur | Revisao do Produto | C | Real | 3 | N/D |  |
| C7_TPCOLAB | TP Colab. | Tp. Mensagem Colaboracao | C | Real | 3 | N/D |  |
| C7_IDTSS | ID TSS | ID TSS Totvs Colaboracao | C | Real | 15 | N/D |  |
| C7_RATEIO | Rateio | Rateio | C | Real | 1 | N/D |  |
| C7_VALCSL | Valor CSLL | Valor CSLL | N | Real | 14, 2 | N/D |  |
| C7_LOTPLS | Lote Pls | Lote Pls | C | Real | 10 | N/D |  |
| C7_CODRDA | Cod.RDA.Pag. | Cod.RDA.Pag. | C | Real | 6 | N/D |  |
| C7_FISCORI | Fil. Origem | Filial de Origem | C | Real | 2 | N/D |  |
| C7_DIREITO | Direito | Direitos minimos das part | M | Real | 10 | N/D |  |
| C7_OBRIGA | Obrigacao | Obrigacoes das partes | M | Real | 10 | N/D |  |
| C7_BASEINS | Base de INSS | Base de INSS | N | Real | 14, 2 | N/D |  |
| C7_BASEISS | Base de ISS | Base de calculo do ISS | N | Real | 14, 2 | N/D |  |
| C7_PLOPELT | Operadora Lt | Operadora Lote Pagto | C | Real | 4 | N/D |  |
| C7_IDTRIB | Id. Tributos | ID dos tributos | C | Real | 36 | N/D |  |
| C7_JUSTIFI | Justif. Cot. | Justificativa Cotacao | C | Real | 100 | N/D |  |

### Notas e convenções
- Tipos de dados: C = Caractere; N = Numérico; D = Data; M = Memo.
- Contexto: Real = campo físico armazenado em banco; Virtual = campo calculado/derivado (não armazenado diretamente).
- Obrigatoriedade: a fonte analisada não informa quais campos são obrigatórios — mantido como “N/D”.
- Chave primária (PK): composta por C7_FILIAL + C7_NUM + C7_ITEM + C7_SEQUEN (Índice 1 na definição de índices da SC7).
- Valores numéricos apresentam o formato “Tamanho, Decimais” conforme extraído do arquivo de origem.

