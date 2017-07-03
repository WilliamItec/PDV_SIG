drop view if exists v_maparesumo;

create view v_maparesumo
as
select 
p.cd_emp,
p.cd_filial,
p.cont_red_z as cd_ctr,
p.dt_ecf,
p.cd_cx,
0 as st_vd,
p.dt_ecf as dt_cad,
null hr_cad,

t.crz as cont_red_z,
(select coo from PAF_MOVIMENTO_REDUCAO_TOTAIS where id_ecf = t.id_ecf and cro = t.cro and crz = (t.crz - 1)) as cont_ord_op_ini,
t.coo as cont_ord_op_fin,
t.cro as cont_reinicio_op,
t.gt_final - venda_bruta_diaria as vlr_gt_ini,
t.gt_final as vlr_gt_fin,
t.venda_bruta_diaria as vlr_vend_bruta,
sum(case when d.totalizador_parcial = 'DT' then d.valor_acumulado else 0 end) as vlr_desc,
sum(case when d.totalizador_parcial = 'Can-T' then d.valor_acumulado else 0 end) as vlr_canc,
venda_bruta_diaria - sum(case when d.totalizador_parcial in ('Can-T','DT') then d.valor_acumulado else 0 end) as vlr_contab,
sum(case when d.totalizador_parcial in ('01T0700','02T1200','03T1700','04T1800','05T2500','06T2700') then d.valor_acumulado else 0 end) as vlr_icms,
sum(case when d.totalizador_parcial in ('I1','I2') then d.valor_acumulado else 0 end) AS vlr_isentas,
sum(case when d.totalizador_parcial in ('N1','N2') then d.valor_acumulado else 0 end) AS vlr_n_trib,
sum(case when d.totalizador_parcial in ('F1','F2') then d.valor_acumulado else 0 end) AS vlr_base_icms_subs,
sum(case when d.totalizador_parcial like ('%S%') then d.valor_acumulado else 0 end) AS vlr_issqn,
sum(case when d.totalizador_parcial = 'DS' then d.valor_acumulado else 0 end) AS vlr_desc_issqn,
sum(case when d.totalizador_parcial = 'Can-S' then d.valor_acumulado else 0 end) AS vlr_cancel_issqn,
case dx.totalizador_parcial 
when '01T0700' then 7 
when '02T1200' then 12
when '03T1700' then 17 
when '04T1800' then 18
when '05T2500' then 25 
when '06T2700' then 27
end as tx_icms,
dx.valor_acumulado as base_calc,

case 
when dx.totalizador_parcial like ('0%T%') then 0 
when dx.totalizador_parcial like ('0%S%') then 1 
else null 
end as tipo_imposto,

case dx.totalizador_parcial 
when '01T0700' then dx.valor_acumulado * 0.07 
when '02T1200' then dx.valor_acumulado * 0.12
when '03T1700' then dx.valor_acumulado * 0.17 
when '04T1800' then dx.valor_acumulado * 0.18
when '05T2500' then dx.valor_acumulado * 0.25 
when '06T2700' then dx.valor_acumulado * 0.27
end as vlr_tx_icms,

0 as flag_consolidado

FROM 
pdv_mapa_resumo p
inner join PAF_MOVIMENTO_REDUCAO_TOTAIS t
on
p.cd_cx = t.id_ecf
and p.dt_ecf = str_to_date(t.data_movimento,'%d%m%Y')
LEFT JOIN  PAF_MOVIMENTO_REDUCAO_DETALHES d 
ON  
t.id_ecf = d.id_ecf
and t.crz = d.crz

LEFT JOIN  PAF_MOVIMENTO_REDUCAO_DETALHES dx 
ON  
t.id_ecf = dx.id_ecf
and t.crz = dx.crz
and dx.totalizador_parcial like '0%T%' and dx.valor_acumulado > 0

group by
cd_emp,cd_filial,cd_cx,dx.totalizador_parcial

;
