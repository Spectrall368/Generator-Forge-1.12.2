<#include "mcelements.ftl">
<#include "mcitems.ftl">
<#-- @formatter:off -->
{
	TileEntity _ent = world.getTileEntity(${toBlockPos(input$x,input$y,input$z)});
	int _amount = ${opt.toInt(input$amount)};
    if (_ent != null) {
		IFluidHandler _cap = _ent.getCapability(CapabilityFluidHandler.FLUID_HANDLER_CAPABILITY, ${input$direction});
		if (_cap != null)
		    _cap.fill(new FluidStack(${generator.map(field$fluid, "fluids")}, _amount), true);
    }
}
<#-- @formatter:on -->