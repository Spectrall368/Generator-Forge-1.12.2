<#include "mcitems.ftl">
<@head>if (${input$entity} instanceof EntityLivingBase) {
	EntityLivingBase _entity = (EntityLivingBase) ${input$entity};</@head>
	ItemStack _setstack${cbi} = ${mappedMCItemToItemStackCode(input$item, 1)}.copy();
	_setstack${cbi}.setCount(${opt.toInt(input$amount)});
	_entity.setHeldItem(EnumHand.MAIN_HAND, _setstack${cbi});
<@tail>
	if (${input$entity} instanceof EntityPlayer) ((EntityPlayer) ${input$entity}).inventory.markDirty();
}</@tail>