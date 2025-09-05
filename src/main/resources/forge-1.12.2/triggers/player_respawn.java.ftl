@SubscribeEvent public void onPlayerRespawned(net.minecraftforge.fml.common.gameevent.PlayerEvent.PlayerRespawnEvent event){
	Entity entity = event.player;
	Map<String, Object> dependencies = new HashMap<>();
	dependencies.put("x",entity.posX);
	dependencies.put("y",entity.posY);
	dependencies.put("z",entity.posZ);
	dependencies.put("world",entity.world);
	dependencies.put("entity",entity);
	dependencies.put("endconquered",event.isEndConquered());
	dependencies.put("event",event);
	this.executeProcedure(dependencies);
}
