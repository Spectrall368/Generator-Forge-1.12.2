@SubscribeEvent public void onLivingDropXp(LivingExperienceDropEvent event) {
	if (event != null && event.getEntity() != null) {
		Entity entity = event.getEntity();
		double i = entity.posX;
		double j = entity.posY;
		double k = entity.posZ;
		PlayerEntity attacked = event.getAttackingPlayer();
		int droppedxp = (int) event.getDroppedExperience();
		int originalxp = (int) event.getOriginalExperience();
		World world = entity.world;
		Map<String, Object> dependencies = new HashMap<>();
		dependencies.put("x", i);
		dependencies.put("y", j);
		dependencies.put("z", k);
		dependencies.put("droppedexperience", droppedxp);
		dependencies.put("originalexperience", originalxp);
		dependencies.put("sourceentity", attacked);
		dependencies.put("world", world);
		dependencies.put("entity", entity);
		dependencies.put("event", event);
		this.executeProcedure(dependencies);
	}
}
