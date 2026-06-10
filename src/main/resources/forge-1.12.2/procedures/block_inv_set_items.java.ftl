<#include "mcelements.ftl">
<#include "mcitems.ftl">
<#-- @formatter:off -->
{
	TileEntity _ent = world.getTileEntity(${toBlockPos(input$x,input$y,input$z)});
    if (_ent != null) {
		IItemHandler _cap = _ent.getCapability(CapabilityItemHandler.ITEM_HANDLER_CAPABILITY, null);
		if (_cap != null && _cap instanceof IItemHandlerModifiable) {
            final ItemStack _setstack = ${mappedMCItemToItemStackCode(input$item, 1)}.copy();
            _setstack.setCount(${opt.toInt(input$amount)});
            ((IItemHandlerModifiable) _cap).setStackInSlot(${opt.toInt(input$slotid)}, _setstack);
		}
	}
}
<#-- @formatter:on -->