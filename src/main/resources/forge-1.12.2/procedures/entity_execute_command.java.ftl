<@addTemplate file="utils/entity/entity_execute_command.java.ftl"/>
{
	Entity _ent = ${input$entity};
	if(!_ent.world.isRemote && _ent.world.getMinecraftServer() != null) {
			_ent.world.getMinecraftServer().getCommandManager().executeCommand(executeCommand(_ent), ${input$command});
	}
}