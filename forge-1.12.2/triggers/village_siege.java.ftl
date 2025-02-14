@SubscribeEvent public void onVillageSiege(VillageSiegeEvent event) {
	EntityPlayer entity=event.getPlayer();
	double i=event.getAttemptedSpawnPos().x;
	double j=event.getAttemptedSpawnPos().y;
	double k=event.getAttemptedSpawnPos().z;
	World world=event.getWorld();
	Map<String, Object> dependencies = new HashMap<>();
	dependencies.put("x", i);
	dependencies.put("y", j);
	dependencies.put("z", k);
	dependencies.put("world", world);
	dependencies.put("entity", entity);
	dependencies.put("event", event);
	this.executeProcedure(dependencies);
}
