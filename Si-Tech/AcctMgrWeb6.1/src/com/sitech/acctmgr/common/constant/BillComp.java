package com.sitech.acctmgr.common.constant;

import java.io.Serializable;
import java.util.Comparator;
import java.util.Map;

public class BillComp implements Comparator<Map<String, Object>>, Serializable {

    @Override
    public int compare(Map<String, Object> o1, Map<String, Object> o2) {

        int iBillCycle1 = Integer.parseInt(o1.get("BILL_CYCLE").toString());
        int iBillCycle2 = Integer.parseInt(o2.get("BILL_CYCLE").toString());

        if (iBillCycle1 < iBillCycle2) {
            return 1;
        } else if (iBillCycle1 > iBillCycle2) {
            return -1;
        }

        return 0;
    }

}
