drop view if exists v_cupomfiscal_cartao;

create view v_cupomfiscal_cartao 
as
select 
cd_emp,cd_filial,cd_cx,dt_vd,cd_vd
from
pdv_vd
where 
1 = 2
;

drop view if exists v_cupomfiscal_crediario;

create view v_cupomfiscal_crediario
as
select 
cd_emp,cd_filial,cd_cx,dt_vd,cd_vd
from
pdv_vd
where 
1 = 2
;

drop view if exists v_cupomfiscal_cheque;

create view v_cupomfiscal_cheque 
as
select 
cd_emp,cd_filial,cd_cx,dt_vd,cd_vd
from
pdv_vd
where 
1 = 2
;

drop view if exists v_cupomfiscal_pbm;

create view v_cupomfiscal_pbm
as
select 
cd_emp,cd_filial,cd_cx,dt_vd,cd_vd
from
pdv_vd
where 
1 = 2

;

drop view if exists v_cupomfiscal_vale_compra;

create view v_cupomfiscal_vale_compra 
as
select 
cd_emp,cd_filial,cd_cx,dt_vd,cd_vd
from
pdv_vd
where 
1 = 2

;

drop view if exists v_cupomfiscal_item_receita;

create view v_cupomfiscal_item_receita
as
select 
cd_emp,cd_filial,cd_cx,dt_vd,cd_vd,0 as cd_it
from
pdv_vd
where 
1 = 2


;