private static int getBlockInventorySlotCount(World world, BlockPos pos) {
    AtomicReference<Integer> result = new AtomicReference<>(0);
    TileEntity entity = world.getTileEntity(pos);
    if (entity != null) {
		IItemHandler cap = entity.getCapability(CapabilityItemHandler.ITEM_HANDLER_CAPABILITY, null);
		if (cap != null)
            result.set(cap.getSlots());
    }

	return result.get();
}