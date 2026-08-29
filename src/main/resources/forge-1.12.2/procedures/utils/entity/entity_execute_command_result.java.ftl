<@addTemplate file="utils/world/entity_execute_command.java.ftl"/>
private static String executeCommandGetResult(Entity entity, String command) {
	StringBuilder result = new StringBuilder();
	if(!entity.world.isRemote && entity.getMinecraftServer() != null) {
		ICommandSender dataConsumer = executeCommand(entity) {
			@Override public void sendMessage(ITextComponent message) {
				result.append(message.getString());
			}
		};
		entity.getMinecraftServer().getCommandManager().executeCommand(dataConsumer, command);
	}
	return result.toString();
}