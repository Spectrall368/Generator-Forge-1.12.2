<@head>if (${input$entity} instanceof EntityPlayer && ((EntityPlayer) ${input$entity}).openContainer instanceof ${JavaModName}Menus.MenuAccessor) {</@head>
	((${JavaModName}Menus.MenuAccessor) ((EntityPlayer) ${input$entity}).openContainer).getSlots().get(${opt.toInt(input$slotid)}).putStack(ItemStack.EMPTY);
<@tail>
	((EntityPlayer) ${input$entity}).openContainer.detectAndSendChanges();
}</@tail>