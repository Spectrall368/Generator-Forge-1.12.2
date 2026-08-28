private static String executeCommandGetResult(Entity entity, String command) {
	StringBuilder result = new StringBuilder();
	if(!entity.world.isRemote() && entity.getServer() != null) {
		ICommandSource dataConsumer = new ICommandSource() {
			@Override public void sendMessage(ITextComponent message) {
				result.append(message.getString());
			}

			@Override public boolean shouldReceiveFeedback() {
				return true;
			}

			@Override public boolean shouldReceiveErrors() {
				return true;
			}

			@Override public boolean allowLogging() {
				return false;
			}
		};
		entity.getServer().getCommandManager().handleCommand(new CommandSource(
				dataConsumer, entity.getPositionVec(), entity.getPitchYaw(),
				entity.world instanceof ServerWorld ? (ServerWorld) entity.world : null, 4,
				entity.getName().getString(), entity.getDisplayName(), entity.world.getServer(), entity
		), command);
	}
	return result.toString();
}