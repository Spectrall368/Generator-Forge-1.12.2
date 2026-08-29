<@addTemplate file="utils/world/execute_command_context.java.ftl"/>
private static String executeCommandGetResult(IWorld world, int posX, int posY, posZ, String command) {
	StringBuilder result = new StringBuilder();
	if (world instanceof WorldServer) {
		ICommandSender dataConsumer = executeCommand(world, posX, posY, posZ) {
			@Override public void sendMessage(ITextComponent message) {
				result.append(message.getString());
			}
		};
		world.getMinecraftServer().getCommandManager().executeCommand(dataConsumer, command);
	}
	return result.toString();
}