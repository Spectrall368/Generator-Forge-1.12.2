@SubscribeEvent public void onRightClickBlock(PlayerInteractEvent.RightClickBlock event) {
	EntityPlayer entity=event.getEntityPlayer();

	if (event.getHand() != entity.getActiveHand())
		return;

	int i=event.getPos().getX();
	int j=event.getPos().getY();
	int k=event.getPos().getZ();
	World world=event.getWorld();
	Map<String, Object> dependencies = new HashMap<>();
	dependencies.put("x", i);
	dependencies.put("y", j);
	dependencies.put("z", k);
	dependencies.put("world", world);
	dependencies.put("entity", entity);
	dependencies.put("direction", event.getFace());
	dependencies.put("event", event);
	this.executeProcedure(dependencies);
}
