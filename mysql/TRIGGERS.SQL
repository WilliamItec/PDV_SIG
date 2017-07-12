delimiter $$

drop trigger if exists tg_pdv_vd_flag_consolidado_insert;

$$

create trigger tg_pdv_vd_flag_consolidado_insert AFTER INSERT on `POS_NOTAS_TOTAIS`
for each row
begin
if NEW.ID_MOTIVO = 'POS015'  then
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
            (1,NEW.origem,NEW.id_estacao,NEW.data_caixa,NEW.id_nota,NEW.id_nota,case NEW.status when 'X' then 1 else 0 end,0);
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
if NEW.ID_MOTIVO = 'POS015' then
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
            (1,NEW.origem,NEW.id_estacao,NEW.data_caixa,NEW.id_nota,NEW.id_nota,case NEW.status when 'X' then 1 else 0 end,0);
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
        and not exists (
            select 1 from v_naofiscal where id_nota = POS_NOTAS_TOTAIS.id_nota
        )
        group by
        origem,id_estacao,data_caixa;
        
    end;
end if;
end; 

$$

drop trigger if exists tg_pdv_mapa_resumo_flag_consolidado;

$$

/*

$$

create trigger tg_pdv_mapa_resumo_flag_consolidado AFTER INSERT on `PAF_MOVIMENTO_REDUCAO_TOTAIS`
for each row
begin

delete from pdv_mapa_resumo where dt_ecf = str_to_date(NEW.data_movimento,'%d%m%Y') and cd_cx = NEW.numero_usuario;

insert into pdv_mapa_resumo
(cd_emp,cd_filial,cd_cx,dt_ecf,dt_cad,id_ecf,cro,crz,flag_consolidado)
values
(
1
,(select firma from POS_CFG limit 1)
,NEW.numero_usuario
,str_to_date(data_movimento,'%d%m%Y')
,str_to_date(data_movimento,'%d%m%Y')
,id_ecf
,cro
,crz
,0
);
        
end;


update POS_NOTAS_TOTAIS set id_estacao = id_estacao where data_caixa >= DATE_SUB(current_date, interval 1 day);
update POS_CAIXA set id_estacao = id_estacao where data_caixa >= '20170701';

*/



delimiter ;


