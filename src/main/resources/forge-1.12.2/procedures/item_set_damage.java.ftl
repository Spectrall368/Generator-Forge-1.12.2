<#include "mcitems.ftl">
(${mappedMCItemToItemStackCode(input$item, 1)}).setItemDamage(${opt.toInt(input$amount)});
