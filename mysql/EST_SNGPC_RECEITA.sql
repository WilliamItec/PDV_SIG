
drop table if exists est_sngpc_receita;

create table est_sngpc_receita
(
  cd_emp int,
  cd_filial int,
  dt_receita date,
  cd_tp_receita int,
  nr_receita bigint,
  cd_ctr int,
  cd_cli int,
  nr_doc_cli varchar(20),
  cd_tp_doc int,
  cd_org_exp int,
  uf_doc varchar(2),
  nm_paciente varchar(255),
  dt_ult_alt date,
  cd_usu int,
  sexo int,
  idade int,
  und_idade int,
  cid varchar(10),
  flag_consolidado int DEFAULT 0,
  cli_sngpc_gestao character(2),
  cd_receita int NOT NULL,
  CONSTRAINT est_sngpc_receita_pk PRIMARY KEY (cd_receita)
);


drop trigger if exists tg_sngpc_receita_insert;

delimiter $$

create trigger tg_sngpc_receita_insert AFTER INSERT on `POS_SNGPC_VENDAS`
for each row
begin

delete from est_sngpc_receita where cd_receita = NEW.id_lancamento;

if NEW.status = 'C' then

insert into est_sngpc_receita
(
cd_emp,cd_filial
,dt_receita,cd_tp_receita
,nr_receita,cd_ctr,cd_cli
,nr_doc_cli,cd_tp_doc,cd_org_exp,uf_doc,nm_paciente,dt_ult_alt
,cd_usu,sexo,idade,und_idade,cid
,flag_consolidado,cli_sngpc_gestao,
cd_receita
)
values
(

1,(select firma from POS_CFG limit 1)
,NEW.DATA_VENDA,NEW.tipo_receituario
,0,0,0
,NEW.n_documento,NEW.tipo_documento,case when NEW.ORGAO_EXPEDIDOR = 'SSP' then 50 else 24 end,NEW.uf_documento,NEW.nome_paciente,NEW.data_venda
,1,NEW.sexo,NEW.idade,NEW.unidade_idade,NEW.cid
,0,null
,NEW.id_lancamento


);

end if;
        
end;

$$

drop trigger if exists tg_sngpc_receita_update;

$$

create trigger tg_sngpc_receita_update AFTER UPDATE on `POS_SNGPC_VENDAS`
for each row
begin

delete from est_sngpc_receita where cd_receita = NEW.id_lancamento;

if NEW.status = 'C' then

insert into est_sngpc_receita
(
cd_emp,cd_filial
,dt_receita,cd_tp_receita
,nr_receita,cd_ctr,cd_cli
,nr_doc_cli,cd_tp_doc,cd_org_exp,uf_doc,nm_paciente,dt_ult_alt
,cd_usu,sexo,idade,und_idade,cid
,flag_consolidado,cli_sngpc_gestao,
cd_receita
)
values
(
1,(select firma from POS_CFG limit 1)
,NEW.DATA_VENDA,NEW.tipo_receituario
,0,0,0
,NEW.n_documento,NEW.tipo_documento,case when NEW.ORGAO_EXPEDIDOR = 'SSP' then 50 else 24 end,NEW.uf_documento,NEW.nome_paciente,NEW.data_venda
,1,NEW.sexo,NEW.idade,NEW.unidade_idade,NEW.cid
,0,null
,NEW.id_lancamento

);

end if;
        
end;

$$

delimiter ;

update POS_SNGPC_VENDAS set tipo_receituario = tipo_receituario where data_venda >= '20170601';