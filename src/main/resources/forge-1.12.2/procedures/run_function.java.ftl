<#include "mcelements.ftl">
<@addTemplate file="utils/world/execute_command_context.java.ftl"/>
if(world instanceof WorldServer && world.getMinecraftServer() != null) {
	FunctionObject _fopt = world.getMinecraftServer().getFunctionManager().getFunction(${toResourceLocation(input$function)});
	if(_fopt != null)
		world.getMinecraftServer().getFunctionManager().execute(_fopt, executeCommand(world, ${input$x}, ${input$y}, ${input$z}));
}