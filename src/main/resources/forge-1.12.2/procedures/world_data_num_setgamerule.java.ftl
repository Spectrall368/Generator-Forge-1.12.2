<#if generator.map(field$gamerulesnumber, "gamerules") != "null">
<@addTemplate file="utils/world/execute_command.java.ftl"/>
if(!world.isRemote && world.getMinecraftServer() != null)
	world.getMinecraftServer().getCommandManager().executeCommand(executeCommand(world), String.format("gamerule %s %d", "${generator.map(field$gamerulesnumber, "gamerules")}", ${opt.toInt(input$gameruleValue)}));
</#if>