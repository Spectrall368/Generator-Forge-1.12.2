private static EntityFireball initProjectileProperties(EntityFireball entityToSpawn, Entity shooter, Vec3d acceleration) {
	entityToSpawn.shootingEntity = (shooter instanceof EntityLivingBase ? ((EntityLivingBase) shooter) : null);
	if (!Vec3d.ZERO.equals(acceleration)) {
		entityToSpawn.motionX = acceleration.x;
		entityToSpawn.motionY = acceleration.y;
		entityToSpawn.motionZ = acceleration.z;
		entityToSpawn.isAirBorne = true;
	}
	entityToSpawn.accelerationX = acceleration.x;
	entityToSpawn.accelerationY = acceleration.y;
	entityToSpawn.accelerationZ = acceleration.z;

	return entityToSpawn;
}