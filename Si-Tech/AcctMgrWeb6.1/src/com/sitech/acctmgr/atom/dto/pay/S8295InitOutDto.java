package com.sitech.acctmgr.atom.dto.pay;

import com.sitech.acctmgr.atom.domains.user.GroupUserInfo;
import com.sitech.acctmgr.common.dto.CommonOutDTO;
import com.sitech.jcfx.anno.ConsType;
import com.sitech.jcfx.anno.ParamDesc;
import com.sitech.jcfx.dt.MBean;

import java.util.List;

/**
 * Created by jiassa on 16/9/6.
 */
public class S8295InitOutDto  extends CommonOutDTO{

    @ParamDesc(path = "USER_LIST", cons = ConsType.STAR, type = "compx", len = "1", desc = "集团用户列表", memo = "略")
    private List<GroupUserInfo> userList;

    @ParamDesc(path = "CNT", cons = ConsType.CT001, type = "int", len = "1", desc = "帐户列表个数", memo = "略")
    private int cnt;

    @Override
    public MBean encode() {
        MBean result = new MBean();
        result.setBody(getPathByProperName("userList"), userList);
        result.setBody(getPathByProperName("cnt"), cnt);
        return result;
    }

    public int getCnt() {
        return cnt;
    }

    public void setCnt(int cnt) {
        this.cnt = cnt;
    }

    public List<GroupUserInfo> getUserList() {
        return userList;
    }

    public void setUserList(List<GroupUserInfo> userList) {
        this.userList = userList;
    }
}