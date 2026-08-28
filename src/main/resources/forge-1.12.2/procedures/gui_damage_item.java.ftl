if(${input$entity} instanceof EntityPlayer && ((EntityPlayer) ${input$entity}).openContainer instanceof ${JavaModName}Menus.MenuAccessor) {
	ItemStack stack = ((${JavaModName}Menus.MenuAccessor) ((EntityPlayer) ${input$entity}).openContainer).getSlots().get(${opt.toInt(input$slotid)}).getStack();
	if(stack != null) {
		if(stack.attemptDamageItem(${opt.toInt(input$amount)}, new Random(), null)) {
			stack.shrink(1);
			stack.setItemDamage(0);
		}
		((EntityPlayer) ${input$entity}).openContainer.detectAndSendChanges();
	}
}