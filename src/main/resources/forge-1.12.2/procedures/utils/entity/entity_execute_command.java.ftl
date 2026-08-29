private static ICommandSender executeCommand(Entity entity) {
    return new ICommandSender() {
			@Override public String getName() {
				return entity.getName();
			}

			@Override public boolean canUseCommand(int permission, String command) {
				return permission <= 4;
			}

			@Override public BlockPos getPosition() {
				return entity.getPosition();
			}

			@Override public Vec3d getPositionVector() {
				return entity.getPositionVector();
			}

			@Override public World getEntityWorld() {
				return entity.world;
			}

			@Override public Entity getCommandSenderEntity() {
				return entity;
			}

			@Override public MinecraftServer getServer() {
				return entity.world.getMinecraftServer();
			}
		};
}