private static int getFluidTankCapacity(World level, BlockPos pos, int tank, Direction direction) {
    AtomicInteger result = new AtomicInteger(0);
    TileEntity entity = level.getTileEntity(pos);
    if (entity != null) {
		IFluidHandler cap = entity.getCapability(CapabilityFluidHandler.FLUID_HANDLER_CAPABILITY, direction);
		if (cap != null)
		    result.set(cap.getTankProperties()[tank].getCapacity());
    }

	return result.get();
}