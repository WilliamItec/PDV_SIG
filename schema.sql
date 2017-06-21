delimiter $$

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

create table if not exists pdv_cupom_nao_fiscal (
    cd_emp int default 1,
    cd_filial int,
    cd_cx int,
    dt_cupom date,
    nr_coo int,  
    flag_consolidado int default 0
)

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
    if NEW.ID_MOTIVO = 'POS015' AND NEW.STATUS IN ('C','X') 
    then
        insert into pdv_vd
        (cd_emp,cd_filial,cd_cx,dt_vd,cd_vd,nr_ecf,st_vd,flag_consolidado)
        values
        (1,NEW.origem,NEW.id_estacao,NEW.data_caixa,NEW.id_nota,NEW.id_nota,0,0);
    end if;
end;

$$

drop trigger if exists tg_pdv_vd_flag_consolidado_update;

$$

create trigger tg_pdv_vd_flag_consolidado_update AFTER UPDATE on `POS_NOTAS_TOTAIS`
for each row
begin
if NEW.ID_MOTIVO = 'POS015' AND NEW.STATUS IN ('C','X') 
then
    insert into pdv_vd
    (cd_emp,cd_filial,cd_cx,dt_vd,cd_vd,nr_ecf,st_vd,flag_consolidado)
    values
    (1,NEW.origem,NEW.id_estacao,NEW.data_caixa,NEW.id_nota,NEW.id_nota,0,0);
end if;
end;

$$

delimiter ;