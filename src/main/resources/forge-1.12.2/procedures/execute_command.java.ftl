<@addTemplate file="utils/world/execute_command_context.java.ftl"/>
if (world instanceof WorldServer)
	world.getMinecraftServer().getCommandManager().executeCommand(executeCommand(world, ${input$x}, ${input$y}, ${input$z}), ${input$command});