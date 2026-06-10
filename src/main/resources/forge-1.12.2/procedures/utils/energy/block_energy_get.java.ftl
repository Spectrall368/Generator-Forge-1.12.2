public static int getEnergyStored(World level, BlockPos pos, Direction direction) {
    AtomicInteger result = new AtomicInteger(0);
    TileEntity entity = level.getTileEntity(pos);
    if (entity != null) {
		IEnergyStorage cap = entity.getCapability(CapabilityEnergy.ENERGY, direction);
		if (cap != null)
            result.set(cap.getEnergyStored());
    }

	return result.get();
}