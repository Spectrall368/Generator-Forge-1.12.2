private static int drainTankSimulate(World level, BlockPos pos, int amount, Direction direction) {
    AtomicInteger result = new AtomicInteger(0);
    TileEntity entity = level.getTileEntity(pos);
    if (entity != null) {
		IFluidHandler cap = entity.getCapability(CapabilityFluidHandler.FLUID_HANDLER_CAPABILITY, direction);
		if (cap != null)
		    result.set(cap.drain(amount, false).getAmount());
    }

	return result.get();
}