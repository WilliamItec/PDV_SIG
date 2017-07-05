if object_id('v_cupomfiscal_item') is not null
begin
	drop view v_cupomfiscal_item
end

;

CREATE VIEW v_cupomfiscal_item
AS 
SELECT 
CD_EMP,
CD_FILIAL,
DT_VD,
DT_CAD,
HR_VD,
CD_CX,
CD_VD, 
NR_ECF,
ST_VD,
(select count(*) from POS_NOTAS_DETALHES t where t.id_nota = item.id_nota and t.id_lancamento <= item.id_lancamento) CD_IT,
item.P_CODIGO AS CD_PROD,
0 AS CD_MEDICO_REC,
'' AS DS_PROD,
NULL AS CD_BARRA,
item.QTD AS QT_IT,
item.VALOR AS VLR_IT,
(item.QTD * item.VALOR) AS TOT_IT,
(CASE WHEN item.STATUS='C' THEN 1 ELSE 0 END) AS ST_IT,
0 AS TIPO_DESCONTO,
0 AS TX_DESC,
0 AS VLR_DESC_VERBA,
0 AS VLR_DESC_RATEIO,
0 AS CD_TRIB_FC,
((item.VALOR_ICMS * 100)/item.VALOR) AS TX_ICMS_IT,
0 AS TX_RED_IT,
0 AS CD_VEND,
NULL AS NM_VEND,
0 AS CD_VEND_VERBA,
'' AS NM_VEND_VERBA,
0 AS CD_USU_CANCEL,
NULL AS NM_USU_CANCEL,
0 AS CD_GRUPO_COMISSAO,
(CASE WHEN item.STATUS='C' THEN 2 ELSE 1 END) AS IS_CANCELADO,        
0 AS CD_LOTE,
0 AS NUMERO_LOTE,
0 AS QTDE_PROD_LOTE,
0 AS REGISTROALTERADOITEM,
0 AS TIPO_IMPOSTO,
0 AS VALOR_IBPT_ITEM,
item.IBPT_NACIONAL AS PERCENTUAL_IBPT_ITEM,
CASE WHEN ID_TIPO_VENDA = 16 THEN ROUND((item.QTD * item.VALOR) * 0.0033,2) ELSE 0 END  AS QT_PONTOS_FIDEL

FROM 
v_cupomfiscal 
INNER JOIN POS_NOTAS_DETALHES item 
ON 
v_cupomfiscal.id_nota = item.ID_NOTA        

