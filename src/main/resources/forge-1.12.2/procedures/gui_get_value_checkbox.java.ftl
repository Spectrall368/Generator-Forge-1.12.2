<#if w.hasElementsOfType("gui")>
((${input$entity} instanceof EntityPlayer && ((EntityPlayer) ${input$entity}).openContainer instanceof ${JavaModName}Menus.MenuAccessor) && ((${JavaModName}Menus.MenuAccessor) ((EntityPlayer) ${input$entity}).openContainer).getMenuState(1, "${field$checkbox}", false))
<#else>false</#if>