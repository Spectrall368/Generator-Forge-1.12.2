<#include "mcelements.ftl">
<#-- @formatter:off -->
{
	TileEntity _ent = world.getTileEntity(${toBlockPos(input$x,input$y,input$z)});
    if (_ent != null) {
		IItemHandler _cap = _ent.getCapability(CapabilityItemHandler.ITEM_HANDLER_CAPABILITY, null);
		if (_cap != null && _cap instanceof IItemHandlerModifiable) {
            ItemStack _stk = _cap.getStackInSlot(${opt.toInt(input$slotid)}).copy();
            _stk.shrink(${opt.toInt(input$amount)});
            ((IItemHandlerModifiable) _cap).setStackInSlot(${opt.toInt(input$slotid)}, _stk);
		}
	}
}
<#-- @formatter:on -->