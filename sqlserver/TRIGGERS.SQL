if object_id('tg_pdv_vd_flag_consolidado') is not null
begin
    drop trigger tg_pdv_vd_flag_consolidado
end

;

create trigger tg_pdv_vd_flag_consolidado ON POS_NOTAS_TOTAIS for INSERT,UPDATE
as
begin

         delete v from pdv_vd v, inserted i where cd_vd = i.id_nota
        insert into pdv_vd
        (cd_emp,cd_filial,cd_cx,dt_vd,cd_vd,nr_ecf,st_vd,flag_consolidado)
        select
        1 as cd_emp,origem,id_estacao,data_caixa,id_nota,id_nota,case when status = 'C' then 0 else 1 end as st_vd,0 as flag_consolidado
        from
        inserted
        where 
        ID_MOTIVO = 'POS015' 
        AND STATUS IN ('C','X')
        AND NOT EXISTS (
             SELECT 1 FROM V_NAOFISCAL WHERE ID_NOTA = INSERTED.ID_NOTA
        )
  
end

;

if object_id('tg_pdv_cupom_nao_fiscal_flag_consollidado') is not null
begin
    drop trigger tg_pdv_cupom_nao_fiscal_flag_consollidado
end

;

create trigger tg_pdv_cupom_nao_fiscal_flag_consollidado ON POS_NOTAS_TOTAIS for INSERT,UPDATE
as
begin
   
         delete v from pdv_cupom_nao_fiscal v, inserted i where nr_coo = i.id_nota
        insert into pdv_cupom_nao_fiscal
        (cd_emp,cd_filial,cd_cx,dt_cupom,cd_ctr,nr_coo,flag_consolidado)
        select
        1,origem,id_estacao,data_caixa,id_nota,id_nota,0
        from 
        inserted
        where 
        ID_MOTIVO = 'POS015' 
          AND STATUS IN ('C','X')
          AND EXISTS (
             SELECT 1 FROM V_NAOFISCAL WHERE ID_NOTA = INSERTED.ID_NOTA
        )
   
end

;


if object_id('tg_pdv_consld_vd_flag_conslidado') is not null
begin
    drop trigger tg_pdv_consld_vd_flag_conslidado
end

;

create trigger tg_pdv_consld_vd_flag_conslidado on POS_CAIXA for UPDATE 
as
begin
    
    delete v from pdv_consld_vd v ,inserted where dt_mov = inserted.data_caixa

    insert into pdv_consld_vd
    (cd_emp,cd_filial,cd_cx,dt_mov,nr_cupom_ini,nr_cupom_fim,vlr_vd_liq,dt_cad,cd_usu,flag_consolidado)
    select
    1 AS cd_emp 
    ,n.origem as cd_filial 
    ,n.id_estacao as cd_cx  
    ,n.data_caixa as dt_mov    
    ,min(id_nota) as nr_cupom_ini   
    ,max(id_nota) as nr_cupom_fim 
    ,sum(valor - troco) as vlr_vd_liq   
    ,getdate() as dt_cad
    ,1 as cd_usu
    ,0 as flag_consolidado
    from
    POS_NOTAS_TOTAIS n, inserted i
    where
    n.id_motivo = 'POS015' 
    and n.status = 'C'
    and n.data_caixa = i.data_caixa
    and i.tipo = 'G'
    and i.status = 'F'
    group by
    n.origem,n.id_estacao,n.data_caixa

end

;

update POS_NOTAS_TOTAIS set id_estacao = id_estacao where data_caixa >=  DATEADD(dd, DATEDIFF(dd,1, getdate()), 0);

update POS_CAIXA set id_estacao = id_estacao where data_caixa >=  DATEADD(dd, DATEDIFF(dd,1, getdate()), 0);