<@head>if (${input$entity} instanceof EntityPlayer && ((EntityPlayer) ${input$entity}).openContainer instanceof ${JavaModName}Menus.MenuAccessor) {</@head>
	((${JavaModName}Menus.MenuAccessor) ((EntityPlayer) ${input$entity}).openContainer).getSlots().get(${opt.toInt(input$slotid)}).decrStackSize(${opt.toInt(input$amount)});
<@tail>
	((EntityPlayer) ${input$entity}).openContainer.detectAndSendChanges();
}</@tail>