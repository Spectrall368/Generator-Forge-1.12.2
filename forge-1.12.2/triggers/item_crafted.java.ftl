@SubscribeEvent public void onItemCrafted(net.minecraftforge.fml.common.gameevent.PlayerEvent.ItemCraftedEvent event){
	Entity entity = event.player;
	World world = entity.world;
	double i=entity.posX;
	double j=entity.posY;
	double k=entity.posZ;
	ItemStack itemStack = event.crafting;
	Map<String, Object> dependencies = new HashMap<>();
	dependencies.put("x",i);
	dependencies.put("y",j);
	dependencies.put("z",k);
	dependencies.put("world",world);
	dependencies.put("entity",entity);
	dependencies.put("itemstack",itemStack);
	dependencies.put("event",event);
	this.executeProcedure(dependencies);
}
