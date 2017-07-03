drop table if exists prc_filial;

create table if not exists prc_filial (
    cd_emp int,
    cd_filial int
);

drop table if exists prc_emp_config;

create table if not exists prc_emp_config (
    cd_emp int,
    cd_chave varchar(255),
    valor varchar(255),
    cd_usu int,
    dt_ult_alt timestamp
);

drop table if exists prc_filial_config;

create table if not exists prc_filial_config (
    cd_emp int,
    cd_filial int,
    cd_chave varchar(255),
    valor varchar(255),
    cd_usu int,
    dt_ult_alt timestamp
);

drop table if exists pdv_vd;

create table if not exists pdv_vd (
    cd_emp int default 1,
    cd_filial int,
    cd_cx int,
    dt_vd date,
    cd_vd int,
    nr_ecf int,
    st_vd int default 0,
    flag_consolidado int default 0
);

drop table if exists pdv_cupom_nao_fiscal;

create table if not exists pdv_cupom_nao_fiscal (
    cd_emp int default 1,
    cd_filial int,
    cd_cx int,
    dt_cupom date,
    cd_ctr int,
    nr_coo int,  
    flag_consolidado int default 0
);

drop table if exists pdv_consld_vd;

create table if not exists pdv_consld_vd (
cd_emp              int
,cd_filial          int
,cd_cx              int
,dt_mov             date
,nr_cupom_ini       int
,nr_cupom_fim       int
,vlr_vd_liq         decimal(19,4)
,cd_usu             int
,dt_cad             date
,flag_consolidado   int default 0
,constraint pk_pdv_consld_vd primary key(cd_emp,cd_filial,cd_cx,dt_mov)
,index ix_pdv_consld_vd_flag_consolidado(flag_consolidado)
);


drop table if exists pdv_mapa_resumo;

create table if not exists pdv_mapa_resumo (
cd_emp              int
,cd_filial          int
,cd_cx              int
,dt_ecf             date
,dt_cad             datetime
,id_ecf 			int
,cro         		int
,crz 				int
,flag_consolidado   int default 0
,constraint pk_pdv_mapa_resumo primary key(cd_emp,cd_filial,cd_cx,dt_ecf)
,index ix_pdv_mapa_resumo_flag_consolidado(flag_consolidado)
);

drop view if exists v_maparesumo;

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
pdv_mapa_resumo;


drop view if exists v_orcamento;

create view v_orcamento
as
select 
0 as flag_consolidado
from
pdv_vd
where
1 = 2;



drop view if exists v_cupomfiscal_crediario;

create view v_cupomfiscal_crediario
as
select 
cd_emp,cd_filial,cd_cx,dt_vd,cd_vd
from
pdv_vd
where 
1 = 2;

drop view if exists v_cupomfiscal_cheque;

create view v_cupomfiscal_cheque 
as
select 
cd_emp,cd_filial,cd_cx,dt_vd,cd_vd
from
pdv_vd
where 
1 = 2;


drop view if exists v_cupomfiscal_vale_compra;

create view v_cupomfiscal_vale_compra 
as
select 
cd_emp,cd_filial,cd_cx,dt_vd,cd_vd
from
pdv_vd
where 
1 = 2;

drop view if exists v_cupomfiscal_item_receita;

create view v_cupomfiscal_item_receita
as
select 
cd_emp,cd_filial,cd_cx,dt_vd,cd_vd,0 as cd_it
from
pdv_vd
where 
1 = 2;

drop view if exists v_cupomnaofiscal_cheque;

create view v_cupomnaofiscal_cheque
as
select 
cd_emp,cd_filial,cd_cx,cd_ctr
from pdv_cupom_nao_fiscal
where
1 = 2;


drop view if exists v_cupomnaofiscal_tef;

create view v_cupomnaofiscal_tef
as
select 
cd_emp,cd_filial,cd_cx,cd_ctr
from pdv_cupom_nao_fiscal
where
1 = 2;


drop view if exists v_naofiscal;

create view v_naofiscal
as
select 
id_nota,p_codigo
from 
POS_NOTAS_DETALHES 
where 
p_codigo in (231234,450225);