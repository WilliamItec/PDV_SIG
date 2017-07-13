drop view if exists v_naofiscal;

create view v_naofiscal
as
select
id_nota,p_codigo
from
POS_NOTAS_DETALHES
where
p_codigo in (231234,450225);

