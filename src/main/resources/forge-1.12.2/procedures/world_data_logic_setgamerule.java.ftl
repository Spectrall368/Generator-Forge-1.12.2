<#if generator.map(field$gamerulesboolean, "gamerules") != "null">
<@addTemplate file="utils/world/execute_command.java.ftl"/>
if(!world.isRemote && world.getMinecraftServer() != null)
	world.getMinecraftServer().getCommandManager().executeCommand(executeCommand(world), String.format("gamerule %s %b", "${generator.map(field$gamerulesboolean, "gamerules")}", ${input$gameruleValue}));
</#if>