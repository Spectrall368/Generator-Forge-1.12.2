private static boolean hasEntityRecipe(Entity entity, ResourceLocation recipe) {
	if (entity instanceof EntityPlayerMP) {
	    EntityPlayerMP player = ((EntityPlayerMP) entity);
	    Optional<? extends IRecipe<?>> recipeOpt = player.world.getRecipeManager().getRecipe(recipe);
		return player.getRecipeBook().isUnlocked(recipeOpt.get());
    } else if (entity instanceof AbstractClientPlayer && ((AbstractClientPlayer) entity).world.isRemote) {
	    AbstractClientPlayer player = ((AbstractClientPlayer) entity);
	    Optional<? extends IRecipe<?>> recipeOpt = player.world.getRecipeManager().getRecipe(recipe);
		return player.getRecipeBook().isUnlocked(recipeOpt.get());
    }
	return false;
}