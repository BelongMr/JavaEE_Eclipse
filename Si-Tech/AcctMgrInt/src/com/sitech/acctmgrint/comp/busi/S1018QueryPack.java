	package com.sitech.acctmgrint.comp.busi;

/**
 * <p>Title: S1080Query类的包装类</p>
 * <p>Description: 把S1080Query类进一步封装（功能和S1080Query一样，为了方便c代码的调用）</p>
 * <p>Copyright: Copyright (c) 2017</p>
 * <p>Company: SI-TECH </p>
 * @author yucl
 * @version 1.0
 */
public class S1018QueryPack {
	public String s1018Query_Fun(String inParam){
		return new S1018Query().s1018Query(inParam);
	}
	public static void main(String[] args) {

		String inParam = "10.109.222.97|13766662921|13766662921|YnM040|aan70W||-1||1018";

		S1018QueryPack s1018Qry = new S1018QueryPack();
		String outStr = s1018Qry.s1018Query_Fun(inParam);
		System.out.println(outStr);
	}
}
