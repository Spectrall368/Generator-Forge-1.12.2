private static EntityArrow initArrowProjectile(EntityArrow entityToSpawn, Entity shooter, float damage, boolean silent, boolean fire, boolean particles, EntityArrow.PickupStatus pickup) {
	entityToSpawn.shootingEntity = shooter;
	entityToSpawn.setDamage(damage);
	if (silent)
		entityToSpawn.setSilent(true);
	if (fire)
		entityToSpawn.setFire(100);
	if (particles)
		entityToSpawn.setIsCritical(true);
	entityToSpawn.pickupStatus = pickup;
	return entityToSpawn;
}