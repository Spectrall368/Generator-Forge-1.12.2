private static boolean hasEntityInInventory(Entity entity, ItemStack itemstack) {
	if (entity instanceof EntityPlayer) {
	    InventoryPlayer inventory = ((EntityPlayer) entity).inventory;
	    List<NonNullList<ItemStack>> compartments = com.google.common.collect.ImmutableList.of(inventory.mainInventory, inventory.armorInventory, inventory.offHandInventory);
        for (List<ItemStack> list : compartments) {
            for (ItemStack itemstack2 : list) {
                if (itemstack.isItemEqual(itemstack2)) {
                    return true;
                }
            }
        }
    }
	return false;
}