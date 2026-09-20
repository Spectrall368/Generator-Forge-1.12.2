private static boolean canExtractEnergy(World level, BlockPos pos, EnumFacing direction) {
    AtomicBoolean result = new AtomicBoolean(false);
    TileEntity entity = level.getTileEntity(pos);
    if (entity != null) {
		IEnergyStorage cap = entity.getCapability(CapabilityEnergy.ENERGY, direction);
		if (cap != null)
		    result.set(cap.canExtract());
    }

	return result.get();
}