drop view if exists v_cupomfiscal_pbm;

create view v_cupomfiscal_pbm 
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

0 AS CD_CONV,    
'' AS NM_CONV,    
(
CASE 
WHEN SIG_POS_dbo.POS_RECEBIMENTOS.ID_AUXILIAR IN (376, 317280) THEN 6
WHEN SIG_POS_dbo.POS_RECEBIMENTOS.ID_AUXILIAR IN (317279, 122473) THEN 2
WHEN SIG_POS_dbo.POS_RECEBIMENTOS.ID_AUXILIAR IN (222370, 222371,317277) THEN 3
WHEN SIG_POS_dbo.POS_RECEBIMENTOS.ID_AUXILIAR IN (296896) THEN 5
WHEN SIG_POS_dbo.POS_RECEBIMENTOS.ID_AUXILIAR IN (317278) THEN 1
END
) AS TIPO_PBM,
    
'' AS CGC_CONV,        
VLR_CONV_PBM AS VLR_CONV,    
'' AS CD_AUTORIZACAO,
1 AS CD_IT,    

(
SELECT 
MAX(P_CODIGO)
FROM 
SIG_POS_dbo.POS_NOTAS_DETALHES 
WHERE 
ID_NOTA = v_cupomfiscal.id_nota LIMIT 1
) AS CD_PROD,

SIG_POS_dbo.POS_RECEBIMENTOS.VALOR AS VLR_PROD_CLI,
0 AS VLR_PROD_REEMBOL,
SIG_POS_dbo.POS_RECEBIMENTOS.VALOR AS VLR_PROD_CONV

FROM 
v_cupomfiscal
INNER JOIN SIG_POS_dbo.POS_RECEBIMENTOS 
ON 
v_cupomfiscal.id_nota =SIG_POS_dbo.POS_RECEBIMENTOS.ID_NOTA 

WHERE 
SIG_POS_dbo.POS_RECEBIMENTOS.ID_MOEDA=4 
AND SIG_POS_dbo.POS_RECEBIMENTOS.ID_AUXILIAR IN (376,122473,222370,222371,296896,317277,317278,317279,317280,317450);