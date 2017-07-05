if object_id('v_cupomfiscal_cartao') is not null
begin
	drop view v_cupomfiscal_cartao
end

;

CREATE VIEW v_cupomfiscal_cartao AS 
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
'' AS NM_CONV,
VLR_CARTAO,
0 AS VLR_SAQUE,

0 CD_CONV,
1 AS QT_PARC,    
0 AS COD_REDE,
0 AS COD_BANDEIRA,
0 AS COD_MODALIDADE,
0 AS TP_ADMINISTRADORA,
0 AS NR_TRANSACAO,
0 AS NR_AUTORIZACAO,
'' AS BANDEIRA,
0 AS NR_ESTABELECIMENTO,
'' AS NR_COMPROVANTE,
'SITEF' AS TEF_GATEWAY
FROM 
v_cupomfiscal
WHERE 
vlr_cartao > 0
