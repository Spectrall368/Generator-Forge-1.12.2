<#include "mcitems.ftl">
(${input$entity} instanceof EntityPlayer && ((EntityPlayer) ${input$entity}).getCooldownTracker().hasCooldown(${mappedMCItemToItem(input$item)}))