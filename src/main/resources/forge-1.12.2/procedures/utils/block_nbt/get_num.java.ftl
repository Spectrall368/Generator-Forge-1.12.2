private static double getBlockNBTNumber(World world, BlockPos pos, String tag) {
	TileEntity blockEntity = world.getTileEntity(pos);
	if (blockEntity != null)
		return blockEntity.getTileData().getDouble(tag);
	return -1;
}