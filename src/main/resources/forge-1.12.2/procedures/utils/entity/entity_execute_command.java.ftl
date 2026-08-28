private static ICommandSender executeCommand(Entity entity) {
    return new ICommandSender() {
			@Override public String getName() {
				return "";
			}

			@Override public boolean canUseCommand(int permission, String command) {
				return true;
			}

			@Override public BlockPos getPosition() {
				return entity.getPosition();
			}

			@Override public Vec3d getPositionVector() {
				return new Vec3d(entity.posX, entity.posY, entity.posZ);
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