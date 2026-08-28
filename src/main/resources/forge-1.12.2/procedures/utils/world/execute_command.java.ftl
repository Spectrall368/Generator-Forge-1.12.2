private static ICommandSender executeCommand(World world) {
    return new ICommandSender() {
			@Override public String getName() {
				return "";
			}

			@Override public boolean canUseCommand(int permission, String command) {
				return permission <= 4;
			}

			@Override public World getEntityWorld() {
				return world;
			}

			@Override public MinecraftServer getServer() {
				return world.getMinecraftServer();
			}
		};
}