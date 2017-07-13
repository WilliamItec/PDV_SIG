drop view if exists v_cupomfiscal;

CREATE VIEW v_cupomfiscal AS
 SELECT vd.cd_emp,
    vd.cd_filial,
    vd.cd_cx,
    vd.dt_vd,
    COALESCE(vd.dt_cad, vd.dt_vd) AS dt_cad,
    COALESCE(vd.hr_vd, vd.dt_cad) AS hr_vd,
    vd.nr_orc,
    vd.nr_ped_televd,
    vd.orig_orc AS origem_orc,
    vd.cd_vd,
    vd.nr_ecf,
    vd.st_vd,
    vd.cont_cupom_fisc AS contador_cupom_fiscal,
    vd.cd_mov AS codigo_movimento,
    NULL::character varying AS cgc_filial,
    NULL::character varying AS nm_filial,
    vd.cd_cli,
    vd.cgc_cpf AS cgc_cli,
    NULL::character varying AS nm_cli,
    vd.nr_cartao_marka AS numero_cartao,
    vd.cd_conv,
    NULL::integer AS cd_cli_conv,
    NULL::character varying AS cgc_conv,
    NULL::character varying AS nm_conv,
    COALESCE(vd.qtd_dias_prorrog, 0) AS dias_prorrog_conv,
    vd.vlr_liq_vd,
    vd.vlr_tot_prod,
    vd.vlr_vd,
    vd.vlr_desc,
    vd.vlr_desc_itens,
    vd.vlr_dinh,
    vd.vlr_troco,
        CASE
            WHEN (((vd.tipo_pbm > 0) AND (COALESCE(vd.vlr_conv_pbm, (0)::numeric) = (0)::numeric)) AND (vd.vlr_conv = (0)::numeric)) THEN (0)::numeric
            ELSE vd.vlr_conv
        END AS vlr_conv,
    vd.qt_parc_conv,
    vd.vlr_dup,
    vd.vl_chqs_a_vista AS valor_cheque_a_vista,
    vd.vl_chqs_a_prz AS valor_cheque_a_prazo,
    ncc.cd_ctr_ncc,
    ncc.vlr_ncc,
    vd.nr_cel_recarga,
    vd.vlr_recarga_cel,
    vd.nm_oper_cel,
    vd.nm_comprador,
    vd.dados_adicionais,
    vd.nr_serie_imp AS nr_serie_ecf,
    vd.vs_pdv AS versao_pdv,
    vd.vs_pdv_rc AS versao_pdv_rc,
    NULLIF((COALESCE(vd.vlr_dinh, (0)::numeric) <> (0)::numeric), false) AS contem_dinheiro,
        CASE
            WHEN (((vd.tipo_pbm > 0) AND (COALESCE(vd.vlr_conv_pbm, (0)::numeric) = (0)::numeric)) AND (vd.vlr_conv = (0)::numeric)) THEN NULL::boolean
            ELSE true
        END AS contem_convenio,
    NULLIF((COALESCE(vd.vlr_dup, (0)::numeric) <> (0)::numeric), false) AS contem_duplicata,
    NULLIF((COALESCE(ncc.vlr_ncc, (0)::numeric) <> (0)::numeric), false) AS contem_ncc,
    NULLIF((COALESCE(vd.vlr_recarga_cel, (0)::numeric) <> (0)::numeric), false) AS contem_recarga_cel,
    vd.cd_usu AS cd_operador,
    ''::character varying AS nm_operador,
    vd.cd_usu_cancel,
    ''::character varying AS nm_usu_cancel,
    vd.cd_mt_cancel AS codigo_motivo_cancelamento,
    NULLIF((vd.st_vd <> (0)::numeric), false) AS is_cancelado,
    (vd.st_canc_paf = 1) AS is_cancelado_paf,
    COALESCE(vd.st_canc_paf, 0) AS st_canc_paf,
    COALESCE(audit.cd_outr_procd, (0)::numeric) AS cd_outro_procedimento,
    COALESCE(audit.cd_usu, (0)::numeric) AS cd_usu_procedimento,
    vd.cd_cli_pbm,
    (COALESCE(vd.reg_alterado, 0) = 1) AS registroalterado,
    vd.vd_troca_fidel AS is_debitar_pontos,
    COALESCE(vd.vlr_imposto, (0)::numeric) AS valor_ibpt,
    COALESCE(vd.tx_med_imposto, (0)::numeric) AS percentual_ibpt,
    COALESCE(vd.flag_consolidado, 0) AS flag_consolidado,
    vd.vlr_conv_pbm,
    vd.flag_nfce,
    nf_sai.cd_nf AS cd_nf_sai,
    nfce_cancel.cd_vd as cancel_nfce,
    coalesce(nfce_cancel.xml_canc,'') as xml_cancel
   FROM ((((pdv_vd vd
     LEFT JOIN pdv_vd_est_nf_sai nf_sai ON ((((vd.cd_emp = nf_sai.cd_emp) AND (vd.cd_filial = nf_sai.cd_filial)) AND (vd.cd_vd = nf_sai.cd_vd))))
     LEFT JOIN est_nfce_env e_nfce ON (((((vd.cd_emp = e_nfce.cd_emp) AND (vd.cd_filial = e_nfce.cd_filial)) AND (vd.nr_ecf = (e_nfce.cd_nf)::numeric)) AND ((vd.cd_nf_serie)::text = (e_nfce.cd_nf_serie)::text))))
     LEFT JOIN pdv_vd_ncc ncc ON ((((vd.cd_emp = ncc.cd_emp) AND (vd.cd_filial = ncc.cd_filial)) AND (vd.cd_vd = ncc.cd_vd))))
     LEFT JOIN pdv_vd_glb_procd_outr_lib audit ON (((((vd.cd_emp = audit.cd_emp) AND (vd.cd_filial = audit.cd_filial)) AND (vd.cd_vd = audit.cd_vd)) AND (audit.cd_outr_procd = ANY (ARRAY[(90)::numeric, (91)::numeric, (93)::numeric, (94)::numeric])))))
   
     LEFT JOIN est_nfce_canc nfce_cancel ON ((((vd.cd_emp = nfce_cancel.cd_emp) AND (vd.cd_filial = nfce_cancel.cd_filial)) AND (vd.cd_vd = nfce_cancel.cd_vd)))
  WHERE (vd.st_vd > ((-1))::numeric);


ALTER TABLE v_cupomfiscal OWNER TO postgres;