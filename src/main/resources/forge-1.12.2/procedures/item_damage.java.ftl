<#include "mcitems.ftl">
{
	ItemStack _ist = ${mappedMCItemToItemStackCode(input$item, 1)};
	if(_ist.attemptDamageItem(${opt.toInt(input$amount)}, new Random(), null)) {
        _ist.shrink(1);
        _ist.setItemDamage(0);
    }
}