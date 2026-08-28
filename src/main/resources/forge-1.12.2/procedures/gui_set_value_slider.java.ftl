<#if w.hasElementsOfType("gui")>
if (${input$entity} instanceof EntityPlayer && ((EntityPlayer) ${input$entity}).openContainer instanceof ${JavaModName}Menus.MenuAccessor)
	((${JavaModName}Menus.MenuAccessor) ((EntityPlayer) ${input$entity}).openContainer).sendMenuStateUpdate((EntityPlayer) ${input$entity}, 2, "${field$slider}", ${input$value}, true);
</#if>