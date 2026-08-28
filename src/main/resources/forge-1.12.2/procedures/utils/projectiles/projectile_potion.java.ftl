private static EntityThrowable initPotionProperties(EntityThrowable entityToSpawn, Entity shooter, Vec3d acceleration) {
    if(shooter != null) {
        ObfuscationReflectionHelper.setPrivateValue(EntityThrowable.class, entityToSpawn, shooter, "field_70192_c");
        ObfuscationReflectionHelper.setPrivateValue(EntityThrowable.class, entityToSpawn, shooter.getUniqueID(), "field_85053_h");
    }
	if (!Vec3d.ZERO.equals(acceleration)) {
        entityToSpawn.motionX = acceleration.x;
        entityToSpawn.motionY = acceleration.y;
        entityToSpawn.motionZ = acceleration.z;
		entityToSpawn.isAirBorne = true;
	}
	return entityToSpawn;
}