private static Entity findEntityInWorldRange(IWorld world, Class<? extends Entity> clazz, double x, double y, double z, double range) {
	return (Entity) world.getEntitiesWithinAABB(clazz, new AxisAlignedBB(x - range / 2.0, y - range / 2.0, z - range / 2.0, x + range / 2.0, y + range / 2.0, z + range / 2.0), e -> true)
		.stream().sorted(Comparator.comparingDouble(e -> e.getDistanceSq(x, y, z))).findFirst().orElse(null);
}