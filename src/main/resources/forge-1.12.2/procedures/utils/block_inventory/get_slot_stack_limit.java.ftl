private static int getBlockInventorySlotStackLimit(World world, BlockPos pos, int slotId) {
    AtomicReference<Integer> result = new AtomicReference<>(0);
    TileEntity entity = world.getTileEntity(pos);
    if (entity != null && slotId >= 0) {
		IItemHandler cap = entity.getCapability(CapabilityItemHandler.ITEM_HANDLER_CAPABILITY, null);
		if (cap != null) {
		    if(slotId < cap.getSlots())
		        result.set(capability.getSlotLimit(slotId));
	    }
	}

	return result.get();
}