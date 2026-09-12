<#include "mcitems.ftl">
<#include "mcelements.ftl">
{
	Entity _entity = ${input$entity};
	if (_entity instanceof EntityPlayer) {
		((EntityPlayer) _entity).inventory.armorInventory.set(${opt.toInt(input$slotid)}, ${mappedMCItemToItemStackCode(input$item, 1)});
		((EntityPlayer) _entity).inventory.markDirty();
	} else if (_entity instanceof EntityLivingBase) {
		((EntityLivingBase) _entity).setItemStackToSlot(${toArmorSlot(input$slotid)}, ${mappedMCItemToItemStackCode(input$item, 1)});
	}
}