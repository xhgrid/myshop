<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta http-equiv="content-type" content="text/html; charset=utf-8" />
		<title>分销商品列表</title>
		<link href="${base}/resources/admin/css/common.css" rel="stylesheet" type="text/css" />
		<script type="text/javascript" src="${base}/resources/admin/js/jquery.js"></script>
		<script type="text/javascript" src="${base}/resources/admin/js/common.js"></script>
		<style type="text/css">
			.moreTable th {
				width: 80px;
				line-height: 25px;
				padding: 5px 10px 5px 0px;
				text-align: right;
				font-weight: normal;
				color: #333333;
				background-color: #f8fbff;
			}
			
			.moreTable td {
				line-height: 25px;
				padding: 5px;
				color: #666666;
			}
			
			.promotion {
				color: #cccccc;
			}
		</style>
		<script type="text/javascript">
			$().ready(function() {
			
				var $listForm = $("#listForm");
				var $moreButton = $("#moreButton");
				var $tongbuButton = $("#tongbuButton");
				var $refreshButton = $("#refreshButton");
				var $ids = $("#listTable input[name='ids']");
				var $pageSizeSelect = $("#pageSizeSelect");
				var $pageSizeOption = $("#pageSizeOption a");
				var $moreOperation = $("#moreOperation");
				var $searchPropertySelect = $("#searchPropertySelect");
				var $searchPropertyOption = $("#searchPropertyOption a");
				var $searchValue = $("#searchValue");
				var $listTable = $("#listTable");
				var $selectAll = $("#selectAll");
				var $contentRow = $("#listTable tr:gt(0)");
				
				[@flash_message /]
				
				//同步到本店铺
				$tongbuButton.click( function() {
					var $this = $(this);
					if ($this.hasClass("disabled")) {
						return false;
					}
					var $checkedIds = $("#listTable input[name='ids']:enabled:checked");
					$.dialog({
						type: "warn",
						content: "您确认要同步选择商品到您的店铺吗?",
						ok: message("admin.dialog.ok"),
						cancel: message("admin.dialog.cancel"),
						onOk: function() {
							$.ajax({
								url: "tongbu.jhtml",
								type: "POST",
								data: $checkedIds.serialize(),
								dataType: "json",
								cache: false,
								success: function(message) {
									$.message(message);
								}
							});
						}
					});
				});
				
				// 更多选项
				$moreButton.click(function() {
					$.dialog({
						title: "${message("admin.product.moreOption")}",
						[@compress single_line = true]
							content: '
							<table id="moreTable" class="moreTable">
								<tr>
									<th>
										${message("Product.productCategory")}:
									<\/th>
									<td>
										<select name="productCategoryId">
											<option value="">${message("admin.common.choose")}<\/option>
											[#list productCategoryTree as productCategory]
												<option value="${productCategory.id}"[#if productCategory.id == productCategoryId] selected="selected"[/#if]>
													[#if productCategory.grade != 0]
														[#list 1..productCategory.grade as i]
															&nbsp;&nbsp;
														[/#list]
													[/#if]
													${productCategory.name}
												<\/option>
											[/#list]
										<\/select>
									<\/td>
								<\/tr>
								<tr>
									<th>
										${message("Product.brand")}:
									<\/th>
									<td>
										<select name="brandId">
											<option value="">${message("admin.common.choose")}<\/option>
											[#list brands as brand]
												<option value="${brand.id}"[#if brand.id == brandId] selected="selected"[/#if]>
													${brand.name}
												<\/option>
											[/#list]
										<\/select>
									<\/td>
								<\/tr>
								<tr>
									<th>
										${message("Product.promotions")}:
									<\/th>
									<td>
										<select name="promotionId">
											<option value="">${message("admin.common.choose")}<\/option>
											[#list promotions as promotion]
												<option value="${promotion.id}"[#if promotion.id == promotionId] selected="selected"[/#if]>
													${promotion.name}
												<\/option>
											[/#list]
										<\/select>
									<\/td>
								<\/tr>
								<tr>
									<th>
										${message("Product.tags")}:
									<\/th>
									<td>
										<select name="tagId">
											<option value="">${message("admin.common.choose")}<\/option>
											[#list tags as tag]
												<option value="${tag.id}"[#if tag.id == tagId] selected="selected"[/#if]>
													${tag.name}
												<\/option>
											[/#list]
										<\/select>
									<\/td>
								<\/tr>
							<\/table>',
						[/@compress]
						width: 470,
						modal: true,
						ok: "${message("admin.dialog.ok")}",
						cancel: "${message("admin.dialog.cancel")}",
						onOk: function() {
							$("#moreTable :input").each(function() {
								var $this = $(this);
								$("#" + $this.attr("name")).val($this.val());
							});
							$listForm.submit();
						}
					});
				});
				
				// 选择
				$ids.click( function() {
					var $this = $(this);
					if ($this.prop("checked")) {
						$this.closest("tr").addClass("selected");
						$tongbuButton.removeClass("disabled");
					} else {
						$this.closest("tr").removeClass("selected");
						if ($("#listTable input[name='ids']:enabled:checked").size() > 0) {
							$tongbuButton.removeClass("disabled");
						} else {
							$tongbuButton.addClass("disabled");
						}
					}
				});
				
				// 刷新
				$refreshButton.click( function() {
					location.reload(true);
					return false;
				});
				
				// 每页记录数
				$pageSizeOption.click( function() {
					var $this = $(this);
					$pageSize.val($this.attr("val"));
					$pageNumber.val("1");
					$listForm.submit();
					return false;
				});
				
				// 搜索选项
				$searchPropertySelect.mouseover( function() {
					var $this = $(this);
					var offset = $this.offset();
					var $menuWrap = $this.closest("div.menuWrap");
					var $popupMenu = $menuWrap.children("div.popupMenu");
					$popupMenu.css({left: offset.left - 1, top: offset.top + $this.height() + 2}).show();
					$menuWrap.mouseleave(function() {
						$popupMenu.hide();
					});
				});
				
				// 搜索选项
				$searchPropertyOption.click( function() {
					var $this = $(this);
					$searchProperty.val($this.attr("val"));
					$searchPropertyOption.removeClass("current");
					$this.addClass("current");
					return false;
				});
				
				// 全选
				$selectAll.click( function() {
					var $this = $(this);
					var $enabledIds = $("#listTable input[name='ids']:enabled");
					if ($this.prop("checked")) {
						$enabledIds.prop("checked", true);
						if ($enabledIds.filter(":checked").size() > 0) {
							$tongbuButton.removeClass("disabled");
							$contentRow.addClass("selected");
						} else {
							$tongbuButton.addClass("disabled");
						}
					} else {
						$enabledIds.prop("checked", false);
						$tongbuButton.addClass("disabled");
						$contentRow.removeClass("selected");
					}
				});
			});
			    
			/** 审核*/
			function check(_this, id){
			    var value = $(_this).prev().val();
			    $.ajax({
			    	url: "check.jhtml",
			    	type: "post",
			    	data: {id: id, checkStatus: value},
			    	dataType: "json",
			    	cache: false,
			    	beforeSend: function() {
						$(_this).prop("disabled", true);
					},
					success: function(data) {
			    		$.message(data);
			    		setTimeout(function() {
			    			window.location.reload();
						}, 3000);
			    	}
				});
				
				// 排序
				$sort.click( function() {
					var orderProperty = $(this).attr("name");
					if ($orderProperty.val() == orderProperty) {
						if ($orderDirection.val() == "asc") {
							$orderDirection.val("desc")
						} else {
							$orderDirection.val("asc");
						}
					} else {
						$orderProperty.val(orderProperty);
						$orderDirection.val("asc");
					}
					$pageNumber.val("1");
					$listForm.submit();
					return false;
				});
				
				// 排序图标
				if ($orderProperty.val() != "") {
					$sort = $("#listTable a[name='" + $orderProperty.val() + "']");
					if ($orderDirection.val() == "asc") {
						$sort.removeClass("desc").addClass("asc");
					} else {
						$sort.removeClass("asc").addClass("desc");
					}
				}
				
				// 页码输入
				$pageNumber.keypress(function(event) {
					var key = event.keyCode ? event.keyCode : event.which;
					if ((key == 13 && $(this).val().length > 0) || (key >= 48 && key <= 57)) {
						return true;
					} else {
						return false;
					}
				});
				
				// 表单提交
				$listForm.submit(function() {
					if (!/^\d*[1-9]\d*$/.test($pageNumber.val())) {
						$pageNumber.val("1");
					}
					if ($searchValue.size() > 0 && $searchValue.val() != "" && $searchProperty.val() == "") {
						$searchProperty.val($searchPropertyOption.eq(0).attr("val"));
					}
				});
				
				// 页码跳转
				$.pageSkip = function(pageNumber) {
					$pageNumber.val(pageNumber);
					$listForm.submit();
					return false;
				}
				
				// 列表查询
				if (location.search != "") {
					addCookie("listQuery", location.search);
				} else {
					removeCookie("listQuery");
				}
			}
		</script>
	</head>
	<body>
		<div class="path">
			<a href="${base}/admin/common/index.jhtml">${message("admin.path.index")}</a> &raquo; 分销商品列表 <span>(${message("admin.page.total", page.total)})</span>
		</div>
		<form id="listForm" action="list.jhtml" method="get">
			<input type="hidden" id="productCategoryId" name="productCategoryId" value="${productCategoryId}" />
			<input type="hidden" id="brandId" name="brandId" value="${brandId}" />
			<input type="hidden" id="promotionId" name="promotionId" value="${promotionId}" />
			<input type="hidden" id="tagId" name="tagId" value="${tagId}" />
			<input type="hidden" id="isMarketable" name="isMarketable" value="[#if isMarketable??]${isMarketable?string("true", "false")}[/#if]" />
			<input type="hidden" id="isList" name="isList" value="[#if isList??]${isList?string("true", "false")}[/#if]" />
			<input type="hidden" id="isTop" name="isTop" value="[#if isTop??]${isTop?string("true", "false")}[/#if]" />
			<input type="hidden" id="isGift" name="isGift" value="[#if isGift??]${isGift?string("true", "false")}[/#if]" />
			<input type="hidden" id="isOutOfStock" name="isOutOfStock" value="[#if isOutOfStock??]${isOutOfStock?string("true", "false")}[/#if]" />
			<input type="hidden" id="isStockAlert" name="isStockAlert" value="[#if isStockAlert??]${isStockAlert?string("true", "false")}[/#if]" />
			<div class="bar">
				<div class="buttonWrap">
					<a href="javascript:;" id="tongbuButton" class="iconButton disabled">
						<span class="addIcon">&nbsp;</span>同步到本店铺
					</a>
					<a href="javascript:;" id="refreshButton" class="iconButton">
						<span class="refreshIcon">&nbsp;</span>${message("admin.common.refresh")}
					</a>
					<div class="menuWrap">
						<div class="popupMenu">
							<ul id="filterOption" class="check">
								<li>
									<a href="javascript:;" name="isMarketable" val="true"[#if isMarketable?? && isMarketable] class="checked"[/#if]>${message("admin.product.isMarketable")}</a>
								</li>
								<li>
									<a href="javascript:;" name="isMarketable" val="false"[#if isMarketable?? && !isMarketable] class="checked"[/#if]>${message("admin.product.notMarketable")}</a>
								</li>
								<li class="separator">
									<a href="javascript:;" name="isList" val="true"[#if isList?? && isList] class="checked"[/#if]>${message("admin.product.isList")}</a>
								</li>
								<li>
									<a href="javascript:;" name="isList" val="false"[#if isList?? && !isList] class="checked"[/#if]>${message("admin.product.notList")}</a>
								</li>
								<li class="separator">
									<a href="javascript:;" name="isTop" val="true"[#if isTop?? && isTop] class="checked"[/#if]>${message("admin.product.isTop")}</a>
								</li>
								<li>
									<a href="javascript:;" name="isTop" val="false"[#if isTop?? && !isTop] class="checked"[/#if]>${message("admin.product.notTop")}</a>
								</li>
								<li class="separator">
									<a href="javascript:;" name="isGift" val="true"[#if isGift?? && isGift] class="checked"[/#if]>${message("admin.product.isGift")}</a>
								</li>
								<li>
									<a href="javascript:;" name="isGift" val="false"[#if isGift?? && !isGift] class="checked"[/#if]>${message("admin.product.nonGift")}</a>
								</li>
								<li class="separator">
									<a href="javascript:;" name="isOutOfStock" val="false"[#if isOutOfStock?? && !isOutOfStock] class="checked"[/#if]>${message("admin.product.isStack")}</a>
								</li>
								<li>
									<a href="javascript:;" name="isOutOfStock" val="true"[#if isOutOfStock?? && isOutOfStock] class="checked"[/#if]>${message("admin.product.isOutOfStack")}</a>
								</li>
								<li class="separator">
									<a href="javascript:;" name="isStockAlert" val="false"[#if isStockAlert?? && !isStockAlert] class="checked"[/#if]>${message("admin.product.normalStore")}</a>
								</li>
								<li>
									<a href="javascript:;" name="isStockAlert" val="true"[#if isStockAlert?? && isStockAlert] class="checked"[/#if]>${message("admin.product.isStockAlert")}</a>
								</li>
							</ul>
						</div>
					</div>
					<a href="javascript:;" id="moreButton" class="button">${message("admin.product.moreOption")}</a>
					<div class="menuWrap">
						<a href="javascript:;" id="pageSizeSelect" class="button">
							${message("admin.page.pageSize")}<span class="arrow">&nbsp;</span>
						</a>
						<div class="popupMenu">
							<ul id="pageSizeOption">
								<li>
									<a href="javascript:;"[#if page.pageSize == 10] class="current"[/#if] val="10">10</a>
								</li>
								<li>
									<a href="javascript:;"[#if page.pageSize == 20] class="current"[/#if] val="20">20</a>
								</li>
								<li>
									<a href="javascript:;"[#if page.pageSize == 50] class="current"[/#if] val="50">50</a>
								</li>
								<li>
									<a href="javascript:;"[#if page.pageSize == 100] class="current"[/#if] val="100">100</a>
								</li>
							</ul>
						</div>
					</div>
				</div>
				<div class="menuWrap">
					<div class="search">
						<span id="searchPropertySelect" class="arrow">&nbsp;</span>
						<input type="text" id="searchValue" name="searchValue" value="${page.searchValue}" maxlength="200" />
						<button type="submit">&nbsp;</button>
					</div>
					<div class="popupMenu">
						<ul id="searchPropertyOption">
							<li>
								<a href="javascript:;"[#if page.searchProperty == "name"] class="current"[/#if] val="name">${message("Product.name")}</a>
							</li>
							<li>
								<a href="javascript:;"[#if page.searchProperty == "sn"] class="current"[/#if] val="sn">${message("Product.sn")}</a>
							</li>
						</ul>
					</div>
				</div>
			</div>
			<table id="listTable" class="list">
				<tr>
					<th class="check">
						<input type="checkbox" id="selectAll" />
					</th>
					<th>
						<a href="javascript:;" class="sort" name="name">${message("Product.name")}</a>
					</th>
					<th>
						<a href="javascript:;" class="sort" name="productCategory">${message("Product.productCategory")}</a>
					</th>
					<th>
						<a href="javascript:;" class="sort" name="price">${message("Product.price")}</a>
					</th>
					<th>
						<a href="javascript:;" class="sort" name="createDate">${message("admin.common.createDate")}</a>
					</th>
					<th>
						<span>${message("admin.common.handle")}</span>
					</th>
				</tr>
				[#list page.content as product]
					<tr>
						<td>
							<input type="checkbox" name="ids" value="${product.id}" />
						</td>
						<td>
							<span title="${product.fullName}">
								${abbreviate(product.fullName, 50, "...")}
								[#if product.isGift]
									<span class="gray">[${message("admin.product.gifts")}]</span>
								[/#if]
							</span>
							[#list product.validPromotions as promotion]
								<span class="promotion">${promotion.name}</span>
							[/#list]
						</td>
						<td>
							${product.productCategory.name}
						</td>
						<td>
							${currency(product.price)}
						</td>
						<td>
							<span title="${product.createDate?string("yyyy-MM-dd HH:mm:ss")}">${product.createDate}</span>
						</td>
						<td>
							[#if product.isMarketable]
								<a href="${base}[#if product.entcode=='macrogw']/gw[/#if]${product.path}" target="_blank">[${message("admin.common.view")}]</a>
							[#else]
								[${message("admin.product.notMarketable")}]
							[/#if]
						</td>
					</tr>
				[/#list]
			</table>
			[@pagination pageNumber = page.pageNumber totalPages = page.totalPages]
				[#include "/admin/include/pagination.ftl"]
			[/@pagination]
		</form>
	</body>
</html>