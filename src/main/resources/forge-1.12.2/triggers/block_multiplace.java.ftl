@SubscribeEvent public void onBlockMultiPlace(BlockEvent.EntityMultiPlaceEvent event) {
	Entity entity = event.getEntity();
	Map<String, Object> dependencies = new HashMap<>();
	dependencies.put("x",event.getPos().getX());
	dependencies.put("y",event.getPos().getY());
	dependencies.put("z",event.getPos().getZ());
	dependencies.put("px",entity.posX);
	dependencies.put("py",entity.posY);
	dependencies.put("pz",entity.posZ);
	dependencies.put("world",event.getWorld().getWorld());
	dependencies.put("entity",entity);
	dependencies.put("event",event);
	this.executeProcedure(dependencies);
}
