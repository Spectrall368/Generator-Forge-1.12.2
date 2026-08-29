<#include "mcitems.ftl">
if (${input$entity} instanceof EntityPlayer)
	((EntityPlayer) ${input$entity}).inventory
        .clearMatchingItems(${mappedMCItemToItem(input$item)}, ${getMappedMCItemMetadata(input$item)}, ${opt.toInt(input$amount)}, null);