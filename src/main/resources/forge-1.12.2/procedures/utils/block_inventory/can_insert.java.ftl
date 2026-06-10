public static boolean canInsertInBlockInventory(World world, BlockPos pos, int slotId, int amount, ItemStack itemstack) {
    AtomicReference<Boolean> result = new AtomicReference<>(false);
    TileEntity entity = world.getTileEntity(pos);
    if (entity != null && slotId >= 0) {
		IItemHandler cap = entity.getCapability(CapabilityItemHandler.ITEM_HANDLER_CAPABILITY, null);
		if (cap != null) {
		    if(slotId < cap.getSlots())
		        result.set(cap.isItemValid(slotId, itemstack));
	    }
	}

	return result.get();
}