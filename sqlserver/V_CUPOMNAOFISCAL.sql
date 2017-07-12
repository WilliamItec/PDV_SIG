if object_id('v_cupomnaofiscal') is not null
begin
	drop view v_cupomnaofiscal
end

;

create view v_cupomnaofiscal
as
select 
1 as cd_emp,
nota.origem as cd_filial,
nota.id_estacao as cd_cx,
nota.data_caixa as dt_cupom,
nota.data_caixa as dt_cad,
null as hr_cupom,
case p_codigo when 231234 then 3 when 450225 then 1 else 2 end as tp_cupom,
nota.id_nota as cd_ctr,
nota.id_nota as nr_coo,
0 as st_cupom,
nota.valor - nota.troco as vlr_tot_cupom,
(SELECT SUM(VALOR) FROM POS_RECEBIMENTOS WHERE nota.ID_NOTA =  ID_NOTA AND ID_MOEDA = 1) AS VLR_DINH,
(SELECT SUM(VALOR) FROM POS_RECEBIMENTOS WHERE nota.ID_NOTA =  ID_NOTA AND ID_MOEDA = 3) AS VLR_CARTAO,
0 as vlr_chqs,
nota.valor - nota.troco as vlr_recarga_cel,
(
CASE 
WHEN documento LIKE '%VIVO%'   THEN 'VIVO' 
WHEN documento like '%CLARO%'  THEN 'CLARO'
WHEN documento like '%TIM%'    THEN 'TIM'
WHEN documento like '%OI%'     THEN 'OI'
ELSE '' END
) as nm_oper_cel,
'1.0' AS versao_pdv,
'1.0' AS versao_pdv_rc,
id_user as cd_operador,
null as nm_operador,
1 as contem_dinheiro,
case when p_codigo = 231234 then 1 else 0 end as contem_recarga_cel,
0 as is_cancelado,
0 as is_fatura,
case when p_codigo = 231234 then  1 else 0 end is_recarga,
case when p_codigo = 450225 then  1 else 0 end as is_doacao,
case when p_codigo not in (231234,450225) then 1 else 0 end is_diversos,

nota.id_nota as doacao_id,
1 as doacao_favor_id

from
pdv_cupom_nao_fiscal cupom
inner join  POS_NOTAS_TOTAIS nota
on 
cupom.nr_coo = nota.id_nota
inner join POS_NOTAS_DETALHES det
on
det.id_nota = nota.id_notago
