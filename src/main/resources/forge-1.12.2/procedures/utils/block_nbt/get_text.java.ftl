private static String getBlockNBTString(World world, BlockPos pos, String tag) {
	TileEntity blockEntity = world.getTileEntity(pos);
	if (blockEntity != null)
		return blockEntity.getTileData().getString(tag);
	return "";
}