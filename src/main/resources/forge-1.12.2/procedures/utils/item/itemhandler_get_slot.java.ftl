private static ItemStack getItemStackFromItemStackSlot(int slotID, ItemStack itemStack) {
	AtomicReference<ItemStack> result = new AtomicReference<>(ItemStack.EMPTY);
	if(itemStack.hasCapability(CapabilityItemHandler.ITEM_HANDLER_CAPABILITY, null)) {
        IItemHandler capability = itemStack.getCapability(CapabilityItemHandler.ITEM_HANDLER_CAPABILITY, null);
		result.set(capability.getStackInSlot(slotID).copy());
	}

	return result.get();
}