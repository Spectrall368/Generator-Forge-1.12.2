<#include "mcitems.ftl">
if (${input$entity} instanceof EntityPlayer) {
	ItemStack _setstack = ${mappedMCItemToItemStackCode(input$item, 1)}.copy();
	_setstack.setCount(${opt.toInt(input$amount)});
	ItemHandlerHelper.giveItemToPlayer(((EntityPlayer) ${input$entity}), _setstack);
}