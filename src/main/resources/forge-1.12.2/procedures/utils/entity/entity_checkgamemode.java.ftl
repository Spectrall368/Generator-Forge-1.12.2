private static GameType getEntityGameType(Entity entity) {
	if(entity instanceof EntityPlayerMP) {
		return ((EntityPlayerMP) entity).interactionManager.getGameType();
	} else if(entity instanceof EntityPlayer && ((EntityPlayer) entity).world.isRemote) {
		NetworkPlayerInfo playerInfo = Minecraft.getMinecraft().getConnection().getPlayerInfo(((EntityPlayer) entity).getGameProfile().getId());
		if (playerInfo != null)
			return playerInfo.getGameType();
	}
	return null;
}