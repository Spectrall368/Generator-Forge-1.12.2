private static int fillTankSimulate(World level, BlockPos pos, int amount, Direction direction, Fluid fluid) {
    AtomicInteger result = new AtomicInteger(0);
    TileEntity entity = level.getTileEntity(pos);
    if (entity != null) {
		IFluidHandler cap = entity.getCapability(CapabilityFluidHandler.FLUID_HANDLER_CAPABILITY, direction);
		if (cap != null)
            result.set(cap.fill(new FluidStack(fluid, amount), false));
    }

	return result.get();
}