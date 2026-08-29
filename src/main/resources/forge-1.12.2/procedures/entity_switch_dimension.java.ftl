<#if field$dimension??><#--Here for legacy reasons as field$dimension does not exist in older workspaces-->
{
	Entity _ent = ${input$entity};
	if(!_ent.world.isRemote&&!_ent.isRiding()&&!_ent.isBeingRidden()
			&&_ent instanceof EntityPlayerMP) {
			int dimensionID = ${generator.map(field$dimension, "dimensions")};

        	if (_player.dimension == destinationType) return;
	
		class TeleporterDirect extends Teleporter {
	
			public TeleporterDirect(WorldServer worldserver) {
				super(worldserver);
			}
	
			@Override public void placeInPortal(Entity entity, float yawrotation) {
			}
	
			@Override public boolean placeInExistingPortal(Entity entity, float yawrotation) {
				return true;
			}
	
			@Override public boolean makePortal(Entity entity) {
				return true;
			}
		}
			EntityPlayerMP _player = (EntityPlayerMP) _ent;
		_player.mcServer.getPlayerList()
				.transferPlayerToDimension(_player,dimensionID,new TeleporterDirect(_player.getServerWorld()));
				_player.connection.setPlayerLocation(
				DimensionManager.getWorld(dimensionID).getSpawnPoint().getX(),
				DimensionManager.getWorld(dimensionID).getSpawnPoint().getY()+1,
				DimensionManager.getWorld(dimensionID).getSpawnPoint().getZ(),
				_player.rotationYaw,_player.rotationPitch);
	}
}
</#if>
