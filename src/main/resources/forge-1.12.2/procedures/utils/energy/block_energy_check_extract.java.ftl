private static int extractEnergySimulate(World level, BlockPos pos, int amount, Direction direction) {
    AtomicInteger result = new AtomicInteger(0);
    TileEntity entity = level.getTileEntity(pos);
    if (entity != null) {
		IEnergyStorage cap = entity.getCapability(CapabilityEnergy.ENERGY, direction);
		if (cap != null)
		    result.set(cap.extractEnergy(amount, true));
    }

	return result.get();
}