DROP VIEW IF EXISTS v_maparesumo;

CREATE OR REPLACE VIEW v_maparesumo AS 
 SELECT resumo.cd_emp,
    resumo.cd_filial,
    NULL::integer AS cd_ctr,
    resumo.dt_ecf,
    resumo.cd_cx,
    0 AS st_vd,
    resumo.dt_cad,
    resumo.dt_cad::date + resumo.hr_cad::time without time zone AS hr_cad,
    resumo.cont_red_z,
    resumo.cont_ord_op_ini,
    resumo.cont_ord_op_fin,
    resumo.cont_reinicio_op,
    resumo.vlr_gt_ini,
    resumo.vlr_gt_fin,
    resumo.vlr_vend_bruta,
    resumo.vlr_desc,
    resumo.vlr_canc,
    resumo.vlr_contab,
    resumo.vlr_icms,
    resumo.vlr_isentas,
    resumo.vlr_n_trib,
    resumo.vlr_base_icms_subs,
    resumo.vlr_issqn,
    resumo.vlr_desc_issqn,
    resumo.vlr_cancel_issqn,
    aliquotas.tx_icms,
    aliquotas.base_calc,
    COALESCE(aliquotas.tipo_imposto, 0::numeric) AS tipo_imposto,
    round(aliquotas.base_calc * aliquotas.tx_icms / 100::numeric, 2) AS vlr_tx_icms,
    COALESCE(resumo.flag_consolidado, 0) AS flag_consolidado
   FROM pdv_mapa_resumo resumo
     LEFT JOIN pdv_mapa_resumo_cpl aliquotas ON resumo.cd_emp = aliquotas.cd_emp AND resumo.cd_filial = aliquotas.cd_filial AND resumo.dt_ecf = aliquotas.dt_ecf AND resumo.cd_cx = aliquotas.cd_cx;

ALTER TABLE v_maparesumo
  OWNER TO postgres;