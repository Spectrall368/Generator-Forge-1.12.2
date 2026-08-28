if (world instanceof WorldServer) {
    World _worldorig = world;

    world = world.getMinecraftServer().getWorld(${generator.map(field$dimension, "dimensions")});

    if (world != null) {
        ${statement$worldstatements}
    }

    world = _worldorig;
}