if object_id('prc_filial') is not null
begin
    drop table prc_filial
end

;

create table  prc_filial (
    cd_emp int,
    cd_filial int
)

;

if object_id('prc_emp_config') is not null
begin
    drop table prc_emp_config
end

;

create table  prc_emp_config (
    cd_emp int,
    cd_chave varchar(255),
    valor varchar(255),
    cd_usu int,
    dt_ult_alt timestamp
)

;

if object_id('prc_filial_config') is not null
begin
    drop table prc_filial_config
end
;

create table  prc_filial_config (
    cd_emp int,
    cd_filial int,
    cd_chave varchar(255),
    valor varchar(255),
    cd_usu int,
    dt_ult_alt timestamp
)

;

if object_id('pdv_vd') is not null
begin
    drop table pdv_vd
end

;

create table  pdv_vd (
    cd_emp int default 1,
    cd_filial int,
    cd_cx int,
    dt_vd datetime,
    cd_vd int,
    nr_ecf int,
    st_vd int default 0,
    flag_consolidado int default 0
)


;

if object_id('pdv_cupom_nao_fiscal') is not null
begin
    drop table pdv_cupom_nao_fiscal
end

;

create table  pdv_cupom_nao_fiscal (
    cd_emp int default 1,
    cd_filial int,
    cd_cx int,
    dt_cupom datetime,
    cd_ctr int,
    nr_coo int,  
    flag_consolidado int default 0
)

;

if object_id('pdv_consld_vd') is not null
begin
    drop table pdv_consld_vd
end

;

create table  pdv_consld_vd (
cd_emp              int
,cd_filial          int
,cd_cx              int
,dt_mov             datetime
,nr_cupom_ini       int
,nr_cupom_fim       int
,vlr_vd_liq         decimal(19,4)
,cd_usu             int
,dt_cad             datetime
,flag_consolidado   int default 0
,constraint pk_pdv_consld_vd primary key(cd_emp,cd_filial,cd_cx,dt_mov)
)


;

if object_id('pdv_mapa_resumo') is not null
begin
    drop table pdv_mapa_resumo
end
;


create table  pdv_mapa_resumo (
cd_emp              int
,cd_filial          int
,cd_cx              int
,dt_ecf             datetime
,dt_cad             datetime
,id_ecf             int
,cro                int
,crz                int
,flag_consolidado   int default 0
,constraint pk_pdv_mapa_resumo primary key(cd_emp,cd_filial,cd_cx,dt_ecf)
)

;

if object_id('v_maparesumo') is not null
begin

drop view  v_maparesumo

end

;

create view v_maparesumo
as
select
cd_emp,
cd_filial,
cd_cx,
0 as cont_red_z,
flag_consolidado,
1 as mapa_resumo
from
pdv_mapa_resumo

;

if object_id('v_orcamento') is not null
begin

drop view  v_orcamento

end

;

create view v_orcamento
as
select 
0 as flag_consolidado
from
pdv_vd
where
1 = 2

;

if object_id('v_cupomfiscal_crediario') is not null
begin

drop view  v_cupomfiscal_crediario

end

;

create view v_cupomfiscal_crediario
as
select 
cd_emp,cd_filial,cd_cx,dt_vd,cd_vd
from
pdv_vd
where 
1 = 2

;

if object_id('v_cupomfiscal_cheque') is not null
begin

drop view  v_cupomfiscal_cheque

end

;

create view v_cupomfiscal_cheque 
as
select 
cd_emp,cd_filial,cd_cx,dt_vd,cd_vd
from
pdv_vd
where 
1 = 2

;

if object_id('v_cupomfiscal_vale_compra') is not null
begin

drop view  v_cupomfiscal_vale_compra

end

;

create view v_cupomfiscal_vale_compra 
as
select 
cd_emp,cd_filial,cd_cx,dt_vd,cd_vd
from
pdv_vd
where 
1 = 2

;

if object_id('v_cupomfiscal_item_receita') is not null
begin

drop view  v_cupomfiscal_item_receita

end

;

create view v_cupomfiscal_item_receita
as
select 
cd_emp,cd_filial,cd_cx,dt_vd,cd_vd,0 as cd_it
from
pdv_vd
where 
1 = 2

;

if object_id('v_cupomnaofiscal_cheque') is not null
begin

drop view  v_cupomnaofiscal_cheque

end

;

create view v_cupomnaofiscal_cheque
as
select 
cd_emp,cd_filial,cd_cx,cd_ctr
from pdv_cupom_nao_fiscal
where
1 = 2

;

if object_id('v_cupomnaofiscal_tef') is not null
begin

drop view  v_cupomnaofiscal_tef

end

;

create view v_cupomnaofiscal_tef
as
select 
cd_emp,cd_filial,cd_cx,cd_ctr
from pdv_cupom_nao_fiscal
where
1 = 2

;

if object_id('v_naofiscal') is not null
begin

drop view  v_naofiscal

end

;

create view v_naofiscal
as
select 
id_nota,p_codigo
from 
POS_NOTAS_DETALHES 
where 
p_codigo in (231234,450225)