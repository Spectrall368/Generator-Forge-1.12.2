@SubscribeEvent public void onPlayerLoggedOut(net.minecraftforge.fml.common.gameevent.PlayerEvent.PlayerLoggedOutEvent event){
	Entity entity = event.player;
	Map<String, Object> dependencies = new HashMap<>();
	dependencies.put("x",entity.posX);
	dependencies.put("y",entity.posY);
	dependencies.put("z",entity.posZ);
	dependencies.put("world",entity.world);
	dependencies.put("entity",entity);
	dependencies.put("event",event);
	this.executeProcedure(dependencies);
}
