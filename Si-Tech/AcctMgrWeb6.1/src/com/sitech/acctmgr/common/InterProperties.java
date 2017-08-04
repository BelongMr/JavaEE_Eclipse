package com.sitech.acctmgr.common;


import org.apache.commons.configuration.ConfigurationException;
import org.apache.commons.configuration.PropertiesConfiguration;
import org.apache.commons.configuration.reloading.FileChangedReloadingStrategy;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;


/**
 * <p>Title: 读取app配置文件  </p>
 * <p>Description: 读取可刷新的配置文件  </p>
 * <p>Copyright: Copyright (c) 2014</p>
 * <p>Company: SI-TECH </p>
 *
 * @author
 * @version 1.0
 */
public class InterProperties {

    private static final Logger log = LoggerFactory.getLogger(InterProperties.class);
    private static PropertiesConfiguration config;

    static {
        config = null;
        try {
            config = new PropertiesConfiguration("acctmgrconfig/inter.properties");
            config.setReloadingStrategy(new FileChangedReloadingStrategy());
        } catch (ConfigurationException e) {
            log.error(e.getMessage());
        }

    }


    public static String getConfigByMap(String key) {

        String value = config.getString(key);
        if (value != null)
            return value.trim();

        return value;
    }

    public static int getConfigInt(String key) {
        int value = config.getInt(key);
        return value;
    }

    public static boolean getConfigBool(String key) {
        boolean value = config.getBoolean(key);
        return value;
    }

    /**
     * 名称：
     *
     * @param
     * @return
     * @throws InterruptedException
     */
    public static void main(String[] args) throws InterruptedException {

        System.out.println("测试读取配置");
        log.info(InterProperties.getConfigByMap("LOGIN_PDOM"));

    }

}
