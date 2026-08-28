<#include "mcitems.ftl">
/*@float*/(${input$entity} instanceof EntityPlayer ? ((EntityPlayer) ${input$entity}).getCooldownTracker().getCooldown(${mappedMCItemToItem(input$item)}, 0f) * 100 : 0)