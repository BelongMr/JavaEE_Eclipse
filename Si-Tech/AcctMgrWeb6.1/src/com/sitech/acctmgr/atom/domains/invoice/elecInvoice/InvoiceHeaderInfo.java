package com.sitech.acctmgr.atom.domains.invoice.elecInvoice;

import com.thoughtworks.xstream.annotations.XStreamAlias;
import com.thoughtworks.xstream.annotations.XStreamAsAttribute;

/**
 * 发票头信息
 * 
 * @author liuhl_bj
 *
 */
@XStreamAlias("FPKJXX_FPTXX")
public class InvoiceHeaderInfo {

	@XStreamAlias("class")
	@XStreamAsAttribute
	private String classalias = "FPKJXX_FPTXX";

	// 发票请求流水
	@XStreamAlias("FPQQLSH")
	private String fpqqlsh;

	// 平台编码
	@XStreamAlias("DSPTBM")
	private String ptbm;

	// 开票方识别号
	@XStreamAlias("NSRSBH")
	private String nsrsbh;

	// 开票方名称
	@XStreamAlias("NSRMC")
	private String nsrmc;

	// 开票方电子档案号
	@XStreamAlias("NSRDZDAH")
	private String dzda;

	// 税务机构代码
	@XStreamAlias("SWJG_DM")
	private String swjgdm;

	// 代开标志0：自开 1:代开 默认为自开0
	@XStreamAlias("DKBZ")
	private String dkbz;

	// 票样代码全部固定为”000001”，不超过10位
	@XStreamAlias("PYDM")
	private String pydm;

	// 主要开票项目 主要开票商品，或者第一条商品，取项目信息中第一条数据的项目名称（或传递大类例如：办公用品）
	@XStreamAlias("KPXM")
	private String kpxm;

	// 编码表版本号 编码表版本号，默认为空。
	@XStreamAlias("BMB_BBH")
	private String bmbbbh;

	// 销货方识别号
	@XStreamAlias("XHF_NSRSBH")
	private String xhfnsrsbh;

	// 销货方名称
	@XStreamAlias("XHFMC")
	private String xhfmc;

	// 销货方地址
	@XStreamAlias("XHF_DZ")
	private String xhfdz;

	// 销货方电话
	@XStreamAlias("XHF_DH")
	private String xhfdh;

	// 销货方银行账号
	@XStreamAlias("XHF_YHZH")
	private String xhfyhzh;

	// 购货方名称
	@XStreamAlias("GHFMC")
	private String ghfmc;

	// 购货方识别号
	@XStreamAlias("GHF_NSRSBH")
	private String ghfnsrsbh;

	// 购货方地址
	@XStreamAlias("GHF_DZ")
	private String ghfdz;

	// 购货方省份
	@XStreamAlias("GHF_SF")
	private String ghfsf;

	// 购货方固定电话
	@XStreamAlias("GHF_GDDH")
	private String ghfgddh;

	// 购货方手机
	@XStreamAlias("GHF_SJ")
	private String ghfsj;

	// 购货方邮箱
	@XStreamAlias("GHF_EMAIL")
	private String ghfemail;

	// 购货方企业类型 购货方企业类型 01：企业 02：机关事业单位 03：个人 04：其它
	@XStreamAlias("GHFQYLX")
	private String ghfqylx;

	// 购货方银行账号
	@XStreamAlias("GHF_YHZH")
	private String ghfyhzh;

	// 行业代码
	@XStreamAlias("HY_DM")
	private String hydm;

	// 行业名称
	@XStreamAlias("HY_MC")
	private String hymc;

	// 开票员
	@XStreamAlias("KPY")
	private String kpy;

	// 收款员
	@XStreamAlias("SKY")
	private String sky;

	// 复核人
	@XStreamAlias("FHR")
	private String fhr;

	// 开票日期
	@XStreamAlias("KPRQ")
	private String kprq;

	// 开票类型
	@XStreamAlias("KPLX")
	private String kplx;

	// 原发票代码
	@XStreamAlias("YFP_DM")
	private String yfpdm;

	// 原发票号码
	@XStreamAlias("YFP_HM")
	private String yfphm;

	// 特殊冲红标志
	@XStreamAlias("TSCHBZ")
	private String tschbz;

	// 操作代码 10正票正常开具 20退货折让红票
	@XStreamAlias("CZDM")
	private String czdm;

	// 清单标志
	@XStreamAlias("QD_BZ")
	private String qdbz;

	// 清单发票项目名称
	@XStreamAlias("QDXMMC")
	private String qdxmmc;

	// 冲红原因
	@XStreamAlias("CHYY")
	private String chyy;

	// 价税合计金额
	@XStreamAlias("KPHJJE")
	private String kphjje;

	// 合计不含税金额。所有商品行不含税金额之和。
	@XStreamAlias("HJBHSJE")
	private String hjbhsje;

	// 合计税额。所有商品行税额之和。
	@XStreamAlias("HJSE")
	private String hjse;

	// 备注
	@XStreamAlias("BZ")
	private String bz;

	// 备用字段
	@XStreamAlias("BYZD1")
	private String byzd1;

	// 备用字段
	@XStreamAlias("BYZD2")
	private String byzd2;

	// 备用字段
	@XStreamAlias("BYZD3")
	private String byzd3;

	// 备用字段
	@XStreamAlias("BYZD4")
	private String byzd4;

	// 备用字段
	@XStreamAlias("BYZD5")
	private String byzd5;

	public String getFpqqlsh() {
		return fpqqlsh;
	}

	public void setFpqqlsh(String fpqqlsh) {
		this.fpqqlsh = fpqqlsh;
	}

	public String getPtbm() {
		return ptbm;
	}

	public void setPtbm(String ptbm) {
		this.ptbm = ptbm;
	}

	public String getNsrsbh() {
		return nsrsbh;
	}

	public void setNsrsbh(String nsrsbh) {
		this.nsrsbh = nsrsbh;
	}

	public String getNsrmc() {
		return nsrmc;
	}

	public void setNsrmc(String nsrmc) {
		this.nsrmc = nsrmc;
	}

	public String getDzda() {
		return dzda;
	}

	public void setDzda(String dzda) {
		this.dzda = dzda;
	}

	public String getSwjgdm() {
		return swjgdm;
	}

	public void setSwjgdm(String swjgdm) {
		this.swjgdm = swjgdm;
	}

	public String getDkbz() {
		return dkbz;
	}

	public void setDkbz(String dkbz) {
		this.dkbz = dkbz;
	}

	public String getPydm() {
		return pydm;
	}

	public void setPydm(String pydm) {
		this.pydm = pydm;
	}

	public String getKpxm() {
		return kpxm;
	}

	public void setKpxm(String kpxm) {
		this.kpxm = kpxm;
	}

	public String getBmbbbh() {
		return bmbbbh;
	}

	public void setBmbbbh(String bmbbbh) {
		this.bmbbbh = bmbbbh;
	}

	public String getXhfnsrsbh() {
		return xhfnsrsbh;
	}

	public void setXhfnsrsbh(String xhfnsrsbh) {
		this.xhfnsrsbh = xhfnsrsbh;
	}

	public String getXhfmc() {
		return xhfmc;
	}

	public void setXhfmc(String xhfmc) {
		this.xhfmc = xhfmc;
	}

	public String getXhfdz() {
		return xhfdz;
	}

	public void setXhfdz(String xhfdz) {
		this.xhfdz = xhfdz;
	}

	public String getXhfdh() {
		return xhfdh;
	}

	public void setXhfdh(String xhfdh) {
		this.xhfdh = xhfdh;
	}

	public String getXhfyhzh() {
		return xhfyhzh;
	}

	public void setXhfyhzh(String xhfyhzh) {
		this.xhfyhzh = xhfyhzh;
	}

	public String getGhfmc() {
		return ghfmc;
	}

	public void setGhfmc(String ghfmc) {
		this.ghfmc = ghfmc;
	}

	public String getGhfnsrsbh() {
		return ghfnsrsbh;
	}

	public void setGhfnsrsbh(String ghfnsrsbh) {
		this.ghfnsrsbh = ghfnsrsbh;
	}

	public String getGhfdz() {
		return ghfdz;
	}

	public void setGhfdz(String ghfdz) {
		this.ghfdz = ghfdz;
	}

	public String getGhfsf() {
		return ghfsf;
	}

	public void setGhfsf(String ghfsf) {
		this.ghfsf = ghfsf;
	}

	public String getGhfgddh() {
		return ghfgddh;
	}

	public void setGhfgddh(String ghfgddh) {
		this.ghfgddh = ghfgddh;
	}

	public String getGhfsj() {
		return ghfsj;
	}

	public void setGhfsj(String ghfsj) {
		this.ghfsj = ghfsj;
	}

	public String getGhfemail() {
		return ghfemail;
	}

	public void setGhfemail(String ghfemail) {
		this.ghfemail = ghfemail;
	}

	public String getGhfqylx() {
		return ghfqylx;
	}

	public void setGhfqylx(String ghfqylx) {
		this.ghfqylx = ghfqylx;
	}

	public String getGhfyhzh() {
		return ghfyhzh;
	}

	public void setGhfyhzh(String ghfyhzh) {
		this.ghfyhzh = ghfyhzh;
	}

	public String getHydm() {
		return hydm;
	}

	public void setHydm(String hydm) {
		this.hydm = hydm;
	}

	public String getHymc() {
		return hymc;
	}

	public void setHymc(String hymc) {
		this.hymc = hymc;
	}

	public String getKpy() {
		return kpy;
	}

	public void setKpy(String kpy) {
		this.kpy = kpy;
	}

	public String getSky() {
		return sky;
	}

	public void setSky(String sky) {
		this.sky = sky;
	}

	public String getFhr() {
		return fhr;
	}

	public void setFhr(String fhr) {
		this.fhr = fhr;
	}

	public String getKprq() {
		return kprq;
	}

	public void setKprq(String kprq) {
		this.kprq = kprq;
	}

	public String getKplx() {
		return kplx;
	}

	public void setKplx(String kplx) {
		this.kplx = kplx;
	}

	public String getYfpdm() {
		return yfpdm;
	}

	public void setYfpdm(String yfpdm) {
		this.yfpdm = yfpdm;
	}

	public String getYfphm() {
		return yfphm;
	}

	public void setYfphm(String yfphm) {
		this.yfphm = yfphm;
	}

	public String getTschbz() {
		return tschbz;
	}

	public void setTschbz(String tschbz) {
		this.tschbz = tschbz;
	}

	public String getCzdm() {
		return czdm;
	}

	public void setCzdm(String czdm) {
		this.czdm = czdm;
	}

	public String getQdbz() {
		return qdbz;
	}

	public void setQdbz(String qdbz) {
		this.qdbz = qdbz;
	}

	public String getQdxmmc() {
		return qdxmmc;
	}

	public void setQdxmmc(String qdxmmc) {
		this.qdxmmc = qdxmmc;
	}

	public String getChyy() {
		return chyy;
	}

	public void setChyy(String chyy) {
		this.chyy = chyy;
	}

	public String getKphjje() {
		return kphjje;
	}

	public void setKphjje(String kphjje) {
		this.kphjje = kphjje;
	}

	public String getHjbhsje() {
		return hjbhsje;
	}

	public void setHjbhsje(String hjbhsje) {
		this.hjbhsje = hjbhsje;
	}

	public String getHjse() {
		return hjse;
	}

	public void setHjse(String hjse) {
		this.hjse = hjse;
	}

	public String getBz() {
		return bz;
	}

	public void setBz(String bz) {
		this.bz = bz;
	}

	public String getByzd1() {
		return byzd1;
	}

	public void setByzd1(String byzd1) {
		this.byzd1 = byzd1;
	}

	public String getByzd2() {
		return byzd2;
	}

	public void setByzd2(String byzd2) {
		this.byzd2 = byzd2;
	}

	public String getByzd3() {
		return byzd3;
	}

	public void setByzd3(String byzd3) {
		this.byzd3 = byzd3;
	}

	public String getByzd4() {
		return byzd4;
	}

	public void setByzd4(String byzd4) {
		this.byzd4 = byzd4;
	}

	public String getByzd5() {
		return byzd5;
	}

	public void setByzd5(String byzd5) {
		this.byzd5 = byzd5;
	}

	public String getClassalias() {
		return classalias;
	}

	public void setClassalias(String classalias) {
		this.classalias = classalias;
	}

}