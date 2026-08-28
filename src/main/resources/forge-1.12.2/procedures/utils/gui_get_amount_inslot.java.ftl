private static int getAmountInGUISlot(Entity entity, int sltid) {
	if(entity instanceof EntityPlayer && ((EntityPlayer) entity).openContainer instanceof ${JavaModName}Menus.MenuAccessor) {
		ItemStack stack = ((${JavaModName}Menus.MenuAccessor) ((EntityPlayer) entity).openContainer).getSlots().get(sltid).getStack();
		if(stack != null)
			return stack.getCount();
	}
	return 0;
}