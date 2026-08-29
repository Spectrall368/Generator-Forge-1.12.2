<#include "mcitems.ftl">
<#include "mcelements.ftl">
if (${input$entity} instanceof EntityLivingBase) {
	((EntityLivingBase) ${input$entity}).setItemStackToSlot(${toArmorSlot(input$slotid)}, ${mappedMCItemToItemStackCode(input$item, 1)});
}