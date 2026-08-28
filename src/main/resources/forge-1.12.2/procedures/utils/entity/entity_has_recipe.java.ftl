private static boolean hasEntityRecipe(Entity entity, ResourceLocation recipe) {
	if (entity instanceof EntityPlayerMP) {
	    EntityPlayerMP player = ((EntityPlayerMP) entity);
	    Optional<? extends IRecipe<?>> recipeOpt = player.world.getRecipeManager().getRecipe(recipe);
		return player.getRecipeBook().isUnlocked(recipeOpt.get());
    } else if (entity instanceof ClientPlayerEntity && ((ClientPlayerEntity) entity).world.isRemote()) {
	    ClientPlayerEntity player = ((ClientPlayerEntity) entity);
	    Optional<? extends IRecipe<?>> recipeOpt = player.world.getRecipeManager().getRecipe(recipe);
		return player.getRecipeBook().isUnlocked(recipeOpt.get());
    }
	return false;
}