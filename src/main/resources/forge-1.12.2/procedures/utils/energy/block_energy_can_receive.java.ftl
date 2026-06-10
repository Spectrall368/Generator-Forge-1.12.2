private static boolean canReceiveEnergy(World level, BlockPos pos, Direction direction) {
    AtomicBoolean result = new AtomicBoolean(false);
    TileEntity entity = level.getTileEntity(pos);
    if (entity != null) {
		IEnergyStorage cap = entity.getCapability(CapabilityEnergy.ENERGY, direction);
		if (cap != null)
		    result.set(cap.canReceive());
    }

	return result.get();
}