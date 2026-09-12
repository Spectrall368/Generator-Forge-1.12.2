<#-- @formatter:off -->
if(${input$entity} instanceof EntityPlayerMP)
	((EntityPlayerMP) ${input$entity}).openGui(${JavaModName}.INSTANCE, ${JavaModName}Screens.${field$guiname?upper_case}_ID, world, ${opt.toInt(input$x)}, ${opt.toInt(input$y)}, ${opt.toInt(input$z)});
<#-- @formatter:on -->