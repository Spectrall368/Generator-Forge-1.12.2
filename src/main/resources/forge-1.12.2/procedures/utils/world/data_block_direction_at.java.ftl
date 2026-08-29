private static EnumFacing getBlockDirection(World world, BlockPos pos) {
	IBlockState blockState = world.getBlockState(pos);
	IProperty property = blockState.getBlock().getBlockState().getProperty("facing");
	if (property != null && blockState.getValue(property) instanceof EnumFacing)
		return ((EnumFacing) blockState.getValue(property));
	else if (blockState.getPropertyKeys().contains(BlockRotatedPillar.AXIS))
		return EnumFacing.getFacingFromAxis(EnumFacing.AxisDirection.POSITIVE, blockState.getValue(BlockRotatedPillar.AXIS));
	else if (blockState.getPropertyKeys().contains(BlockPortal.AXIS))
		return EnumFacing.getFacingFromAxis(EnumFacing.AxisDirection.POSITIVE, blockState.getValue(BlockPortal.AXIS));
	return EnumFacing.NORTH;
}