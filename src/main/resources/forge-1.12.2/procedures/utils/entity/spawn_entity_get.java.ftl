private static Entity spawnEntity(Entity entity, BlockPos blockpos, IWorld world) {
    entity.setPosition(blockpos.getX(), blockpos.getY(), blockpos.getZ());

    if (entity instanceof EntityMob)
        ((EntityMob) entity).onInitialSpawn(world.getDifficultyForLocation(entity.getPosition()), null);

    world.spawnEntity(entity);
    return entity;
}