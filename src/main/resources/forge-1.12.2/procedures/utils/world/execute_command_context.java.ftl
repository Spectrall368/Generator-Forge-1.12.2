private static ICommandSender executeCommand(World world, int x, int y, int z) {
    return new ICommandSender() {
			@Override public String getName() {
				return "";
			}

			@Override public boolean canUseCommand(int permission, String command) {
				return permission <= 4;
			}

			@Override public BlockPos getPosition() {
				return new BlockPos(x, y, z);
			}

			@Override public Vec3d getPositionVector() {
				return new Vec3d(x, y, z);
			}

			@Override public World getEntityWorld() {
				return world;
			}

			@Override public MinecraftServer getServer() {
				return world.getMinecraftServer();
			}
		};
}