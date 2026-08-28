<#include "mcitems.ftl">
if(${input$entity} instanceof EntityPlayer)
	((EntityPlayer) ${input$entity}).getCooldownTracker().setCooldown(${mappedMCItemToItem(input$item)}, ${opt.toInt(input$ticks)});
