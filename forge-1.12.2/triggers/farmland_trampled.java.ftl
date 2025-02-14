@SubscribeEvent public void onFarmlandTrampled(BlockEvent.FarmlandTrampleEvent event){
	Entity entity = event.getEntity();
	float falldistance = event.getFallDistance();
	Map<String, Object> dependencies = new HashMap<>();
	dependencies.put("x",event.getPos().getX());
	dependencies.put("y",event.getPos().getY());
	dependencies.put("z",event.getPos().getZ());
	dependencies.put("world",event.getWorld().getWorld());
	dependencies.put("entity",entity);
	dependencies.put("falldistance",falldistance);
	dependencies.put("event",event);
	this.executeProcedure(dependencies);
}
