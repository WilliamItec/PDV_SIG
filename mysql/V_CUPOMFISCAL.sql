drop view if exists v_cupomfiscal;

CREATE VIEW v_cupomfiscal
AS 
SELECT 
pdv_vd.cd_emp,
pdv_vd.cd_filial,
pdv_vd.cd_vd,
pdv_vd.cd_cx,
pdv_vd.dt_vd,
pdv_vd.nr_ecf,
pdv_vd.st_vd,
POS_NOTAS_TOTAIS.ID_NOTA,
POS_NOTAS_TOTAIS.ID_TIPO_VENDA,
POS_NOTAS_TOTAIS.DATA_CAIXA as dt_cad,
POS_NOTAS_TOTAIS.HORA_OPERACAO AS HR_VD,
0 as CD_CLI,
MTZ_CLIENTES.CPF AS CGC_CLI,
MTZ_CLIENTES.NOME AS NM_CLI,
(SELECT ID_AUXILIAR FROM POS_RECEBIMENTOS WHERE ID_NOTA = POS_NOTAS_TOTAIS.ID_NOTA AND ID_MOEDA IN (4,10)) AS CD_CONV,
POS_NOTAS_TOTAIS.ID_CLIENTE as matricula,
(POS_NOTAS_TOTAIS.VALOR - POS_NOTAS_TOTAIS.TROCO) AS VLR_LIQ_VD,
(POS_NOTAS_TOTAIS.VALOR - POS_NOTAS_TOTAIS.TROCO) AS VLR_TOT_PROD,
(POS_NOTAS_TOTAIS.VALOR -POS_NOTAS_TOTAIS.TROCO)AS VLR_VD,
0 AS VLR_DESC,
0 AS VLR_DESC_ITENS,
POS_NOTAS_TOTAIS.TROCO,
1 AS QT_PARC_CONV,
null AS CD_CTR_NCC,
(SELECT SUM(VALOR) FROM POS_RECEBIMENTOS WHERE POS_NOTAS_TOTAIS.ID_NOTA =  ID_NOTA AND ID_MOEDA = 1) AS VLR_DINH,
(SELECT SUM(VALOR) FROM POS_RECEBIMENTOS WHERE POS_NOTAS_TOTAIS.ID_NOTA =  ID_NOTA AND ID_MOEDA = 3) AS VLR_CARTAO,
(SELECT SUM(VALOR) FROM POS_RECEBIMENTOS WHERE POS_NOTAS_TOTAIS.ID_NOTA =  ID_NOTA AND ID_MOEDA IN (4,10) AND ID_AUXILIAR IN (0,133521,133522,133523,315252,147662,205437,198)) AS VLR_CONV,
(SELECT SUM(VALOR) FROM POS_RECEBIMENTOS WHERE POS_NOTAS_TOTAIS.ID_NOTA =  ID_NOTA AND ID_MOEDA = 4 AND ID_AUXILIAR IN (376,122473,222370,222371,296896,317277,317278,317279,317280,317450)) AS VLR_CONV_PBM,
(SELECT SUM(VALOR) FROM POS_RECEBIMENTOS WHERE POS_NOTAS_TOTAIS.ID_NOTA =  ID_NOTA AND ID_MOEDA = 5) AS VLR_NCC,    
(SELECT SUM(VALOR) FROM POS_RECEBIMENTOS WHERE POS_NOTAS_TOTAIS.ID_NOTA =  ID_NOTA AND ID_MOEDA IN (524,615) ) AS VLR_VALE_CP,
null AS CD_CTR_VALE_CP,

0 AS VLR_DUP,
0 AS VLR_CHQS_A_VISTA,
0 AS VLR_CHQS_A_PRZ,
0 AS NR_CEL_RECARGA,

1 as contem_dinheiro,

1 as contem_convenio,
null as contem_recarga_cel,
null as contem_duplicata,

(SELECT 1 FROM POS_RECEBIMENTOS WHERE POS_NOTAS_TOTAIS.ID_NOTA =  ID_NOTA AND ID_MOEDA = 5) as contem_ncc,

MTZ_CLIENTES.NOME AS NM_COMPRADOR,    
'' AS DADOS_ADICIONAIS,
'1.0' AS VERSAO_PDV,
'1.0' AS VERSAO_PDV_RC,

POS_NOTAS_TOTAIS.ID_USER AS CD_OPERADOR,
0 AS CD_OUTRO_PROCEDIMENTO,
POS_NOTAS_TOTAIS.ID_USER AS CD_USU_PROCEDIMENTO,
0 AS REGISTROALTERADO,

/* PONTOS FIDELIDADE */
POS_NOTAS_TOTAIS.ID_CLIENTE AS NUMERO_CARTAO,
(SELECT 1 FROM POS_RECEBIMENTOS WHERE POS_NOTAS_TOTAIS.ID_NOTA =  ID_NOTA AND ID_MOEDA IN (524,615) LIMIT 1)  AS IS_DEBITAR_PONTOS,

0  AS CD_USU_CANCEL,
'' AS NM_USU_CANCEL,
0  AS CODIGO_MOTIVO_CANCELAMENTO,
0  AS IS_CANCELADO,
0  AS IS_CANCELADO_PAF,
0  AS ST_CANC_PAF,
0  AS VALOR_IBPT,
0  AS PERCENTUAL_IBPT,

case when length(POS_NOTAS_TOTAIS.documento) = 44 then 1 else 0 end AS FLAG_NFCE,
case when length(POS_NOTAS_TOTAIS.documento) = 44 then POS_NOTAS_TOTAIS.documento else null end AS CHV_NFCE,
0  AS CANCEL_NFCE,
'' AS XML_CANCEL,
0  AS TP_CANC,
'' AS CHV_NFCE_CANCEL,
'' AS DT_EMIS_CANCEL,
'' AS AUT_CANC,
'' AS DS_MOTIVO_CANCEL

FROM

pdv_vd 

inner join POS_NOTAS_TOTAIS
on
pdv_vd.cd_emp = 1
and pdv_vd.cd_filial = POS_NOTAS_TOTAIS.origem
and pdv_vd.cd_vd = POS_NOTAS_TOTAIS.ID_NOTA

left join MTZ_CLIENTES 
on
POS_NOTAS_TOTAIS.id_cliente=MTZ_CLIENTES.id_cliente 


