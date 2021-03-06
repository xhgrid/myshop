
<%
 /**
  * 功能：异步通知页面
  * 版本：1.0
  * 日期：2012-10-11
  * 作者：中国银联UPMP团队
  * 版权：中国银联
  * 说明：以下代码只是为了方便商户测试而提供的样例代码，商户可以根据自己的需要，按照技术文档编写,并非一定要使用该代码。该代码仅供参考。
  * */
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="net.shopxx.plugin.wap_unionpay.service.*"%>
<%
	//获取银联POST过来异步通知信息
	Map<String,String> params = new HashMap<String,String>();
	Map requestParams = request.getParameterMap();
	for (Iterator iter = requestParams.keySet().iterator(); iter.hasNext();) {
		String name = (String) iter.next();
		String[] values = (String[]) requestParams.get(name);
		String valueStr = "";
		for (int i = 0; i < values.length; i++) {
			valueStr = (i == values.length - 1) ? valueStr + values[i]
					: valueStr + values[i] + ",";
		}
		params.put(name, valueStr);
	}

	if(UpmpService.verifySignature(params)){// 服务器签名验证成功
		//请在这里加上商户的业务逻辑程序代码
		//获取通知返回参数，可参考接口文档中通知参数列表(以下仅供参考)
		String transStatus = request.getParameter("transStatus");// 交易状态
		if (null != transStatus && transStatus.equals("00")) {
		    // 交易处理成功

		} else {
		}
	
		out.println("success");
	}else{// 服务器签名验证失败
		out.println("fail");
	}
%>
