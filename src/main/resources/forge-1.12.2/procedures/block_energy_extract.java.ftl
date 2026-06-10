<#include "mcelements.ftl">
<#-- @formatter:off -->
{
	TileEntity _ent = world.getTileEntity(${toBlockPos(input$x,input$y,input$z)});
	int _amount = ${opt.toInt(input$amount)};
    if (_ent != null) {
		IEnergyStorage _cap = _ent.getCapability(CapabilityEnergy.ENERGY, ${input$direction});
		if (_cap != null)
		    _cap.extractEnergy(_amount, false);
    }
}
<#-- @formatter:on -->