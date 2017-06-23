delimiter $$

drop view if exists v_naofiscal;

$$

create view v_naofiscal
as
select 
id_nota,p_codigo
from 
POS_NOTAS_DETALHES 
where 
p_codigo in (231234,450225);

$$

create table if not exists prc_filial (
    cd_emp int,
    cd_filial int
)

$$

create table if not exists prc_emp_config (
    cd_emp int,
    cd_chave varchar(255),
    valor varchar(255),
    cd_usu int,
    dt_ult_alt timestamp
)

$$

create table if not exists prc_filial_config (
    cd_emp int,
    cd_filial int,
    cd_chave varchar(255),
    valor varchar(255),
    cd_usu int,
    dt_ult_alt timestamp
)

$$

create table if not exists pdv_vd (
    cd_emp int default 1,
    cd_filial int,
    cd_cx int,
    dt_vd date,
    cd_vd int,
    nr_ecf int,
    st_vd int default 0,
    flag_consolidado int default 0
)

$$

drop table if exists pdv_cupom_nao_fiscal;

$$

create table if not exists pdv_cupom_nao_fiscal (
    cd_emp int default 1,
    cd_filial int,
    cd_cx int,
    dt_cupom date,
    cd_ctr int,
    nr_coo int,  
    flag_consolidado int default 0
)

$$

drop table if exists pdv_consld_vd;

$$

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

$$

drop table if exists pdv_mapa_resumo;

$$

create table if not exists pdv_mapa_resumo (
cd_emp              int
,cd_filial          int
,cd_cx              int
,dt_ecf             date
,dt_cad             datetime
,cont_red_z         int
,flag_consolidado   int default 0
,constraint pk_pdv_mapa_resumo primary key(cd_emp,cd_filial,cd_cx,dt_ecf)
,index ix_pdv_mapa_resumo_flag_consolidado(flag_consolidado)
);

$$

drop view if exists v_maparesumo;

$$

create view v_maparesumo
as
select
cd_emp,
cd_filial,
cd_cx,
cont_red_z,
flag_consolidado,
1 as mapa_resumo
from
pdv_mapa_resumo;

$$

drop view if exists v_orcamento;

$$

create view v_orcamento
as
select 
0 as flag_consolidado
from
pdv_vd
where
1 = 2

$$

drop view if exists v_cupomfiscal_crediario;

$$

create view v_cupomfiscal_crediario
as
select 
cd_emp,cd_filial,cd_cx,dt_vd,cd_vd
from
pdv_vd
where 
1 = 2

$$

drop view if exists v_cupomfiscal_cheque;

$$

create view v_cupomfiscal_cheque 
as
select 
cd_emp,cd_filial,cd_cx,dt_vd,cd_vd
from
pdv_vd
where 
1 = 2

$$

drop view if exists v_cupomfiscal_vale_compra;

$$

create view v_cupomfiscal_vale_compra 
as
select 
cd_emp,cd_filial,cd_cx,dt_vd,cd_vd
from
pdv_vd
where 
1 = 2

$$

drop view if exists v_cupomfiscal_item_receita;

$$

create view v_cupomfiscal_item_receita
as
select 
cd_emp,cd_filial,cd_cx,dt_vd,cd_vd,0 as cd_it
from
pdv_vd
where 
1 = 2

$$

drop trigger if exists tg_pdv_vd_flag_consolidado_insert;

$$

create trigger tg_pdv_vd_flag_consolidado_insert AFTER INSERT on `POS_NOTAS_TOTAIS`
for each row
begin
if NEW.ID_MOTIVO = 'POS015' AND NEW.STATUS IN ('C','X') then
	delete from pdv_vd where cd_vd = NEW.ID_NOTA;
	delete from pdv_cupom_nao_fiscal where nr_coo = NEW.ID_NOTA;
    if (select true from v_naofiscal where id_nota = NEW.id_nota) then
        begin
            insert into pdv_cupom_nao_fiscal
            (cd_emp,cd_filial,cd_cx,dt_cupom,cd_ctr,nr_coo,flag_consolidado)
            values
            (1,NEW.origem,NEW.id_estacao,NEW.data_caixa,NEW.id_nota,NEW.id_nota,0);
        end;
        else
        begin
            insert into pdv_vd
            (cd_emp,cd_filial,cd_cx,dt_vd,cd_vd,nr_ecf,st_vd,flag_consolidado)
            values
            (1,NEW.origem,NEW.id_estacao,NEW.data_caixa,NEW.id_nota,NEW.id_nota,0,0);
        end;
    end if;
end if;
end;

$$

drop trigger if exists tg_pdv_vd_flag_consolidado_update;

$$

create trigger tg_pdv_vd_flag_consolidado_update AFTER UPDATE on `POS_NOTAS_TOTAIS`
for each row
begin
if NEW.ID_MOTIVO = 'POS015' AND NEW.STATUS IN ('C','X') then
	delete from pdv_vd where cd_vd = NEW.ID_NOTA;
	delete from pdv_cupom_nao_fiscal where nr_coo = NEW.ID_NOTA;
    if (select true from v_naofiscal where id_nota = NEW.id_nota) then
        begin
            insert into pdv_cupom_nao_fiscal
            (cd_emp,cd_filial,cd_cx,dt_cupom,cd_ctr,nr_coo,flag_consolidado)
            values
            (1,NEW.origem,NEW.id_estacao,NEW.data_caixa,NEW.id_nota,NEW.id_nota,0);
        end;
        else
        begin
            insert into pdv_vd
            (cd_emp,cd_filial,cd_cx,dt_vd,cd_vd,nr_ecf,st_vd,flag_consolidado)
            values
            (1,NEW.origem,NEW.id_estacao,NEW.data_caixa,NEW.id_nota,NEW.id_nota,0,0);
        end;
    end if;
end if;
end;

$$

drop trigger if exists tg_pdv_consld_vd_flag_conslidado;

$$

create trigger tg_pdv_consld_vd_flag_conslidado AFTER UPDATE on `POS_CAIXA`
for each row
begin
if NEW.tipo = 'G' and NEW.status = 'F' then
    begin
        
        delete from pdv_consld_vd where dt_mov = NEW.data_caixa;
        
        insert into pdv_consld_vd
        (cd_emp,cd_filial,cd_cx,dt_mov,nr_cupom_ini,nr_cupom_fim,vlr_vd_liq,dt_cad,cd_usu,flag_consolidado)
        select
        1 AS cd_emp 
        ,origem as cd_filial 
        ,id_estacao as cd_cx  
        ,data_caixa as dt_mov    
        ,min(id_nota) as nr_cupom_ini   
        ,max(id_nota) as nr_cupom_fim 
        ,sum(valor - troco) as vlr_vd_liq   
        ,current_date as dt_cad
        ,NEW.id_user as cd_usu
        ,0 as flag_consolidado
        from
        POS_NOTAS_TOTAIS
        where
        id_motivo = 'POS015' 
        and status = 'C'
        and data_caixa = NEW.data_caixa
        group by
        origem,id_estacao,data_caixa;
        
    end;
end if;
end; 

$$

drop view if exists v_cupomnaofiscal_cheque;

$$

create view v_cupomnaofiscal_cheque
as
select 
cd_emp,cd_filial,cd_cx,cd_ctr
from pdv_cupom_nao_fiscal
where
1 = 2;

$$

drop view if exists v_cupomnaofiscal_tef;

$$

create view v_cupomnaofiscal_tef
as
select 
cd_emp,cd_filial,cd_cx,cd_ctr
from pdv_cupom_nao_fiscal
where
1 = 2;

$$


delimiter ;