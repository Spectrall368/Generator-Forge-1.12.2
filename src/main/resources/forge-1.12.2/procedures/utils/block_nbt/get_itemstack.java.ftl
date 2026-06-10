private static ItemStack getBlockNBTItemStack(World world, BlockPos pos, String tag) {
	TileEntity blockEntity = world.getTileEntity(pos);
	if (blockEntity != null)
		return ItemStack.read(blockEntity.getTileData().getCompound(tag));
	return ItemStack.EMPTY;
}