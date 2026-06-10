private static int getBlockTanks(World level, BlockPos pos, Direction direction) {
    AtomicInteger result = new AtomicInteger(0);
    TileEntity entity = level.getTileEntity(pos);
    if (entity != null) {
		IFluidHandler cap = entity.getCapability(CapabilityFluidHandler.FLUID_HANDLER_CAPABILITY, direction);
		if (cap != null)
		    result.set(capability.getTankProperties().length);
    }

	return result.get();
}