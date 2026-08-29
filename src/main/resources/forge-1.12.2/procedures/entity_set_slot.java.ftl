<#include "mcitems.ftl">
{
	final int _slotid = ${opt.toInt(input$slotid)};
	final ItemStack _setstack = ${mappedMCItemToItemStackCode(input$slotitem, 1)}.copy();
	_setstack.setCount(${opt.toInt(input$amount)});
	if(${input$entity}.hasCapability(CapabilityItemHandler.ITEM_HANDLER_CAPABILITY, null)) {
	    IItemHandler capability = ${input$entity}.getCapability(CapabilityItemHandler.ITEM_HANDLER_CAPABILITY, null);
		if (capability instanceof IItemHandlerModifiable)
            		((IItemHandlerModifiable) capability).setStackInSlot(_slotid, _setstack);
	}
}