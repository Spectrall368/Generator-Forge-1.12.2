private static ItemStack itemFromBlockInventory(World world, BlockPos pos, int slot) {
    AtomicReference<ItemStack> result = new AtomicReference<>(ItemStack.EMPTY);
    TileEntity entity = world.getTileEntity(pos);
    if (entity != null) {
		IItemHandler cap = entity.getCapability(CapabilityItemHandler.ITEM_HANDLER_CAPABILITY, null);
		if (cap != null)
		    result.set(cap.getStackInSlot(slot));
    }

	return result.get();
}