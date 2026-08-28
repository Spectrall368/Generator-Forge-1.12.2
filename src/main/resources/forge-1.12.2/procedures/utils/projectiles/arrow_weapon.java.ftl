private static EntityArrow createArrowWeaponItemStack(EntityArrow entityToSpawn, int knockback, byte piercing) {
	if (knockback > 0)
		entityToSpawn.setKnockbackStrength(knockback);
	return entityToSpawn;
}