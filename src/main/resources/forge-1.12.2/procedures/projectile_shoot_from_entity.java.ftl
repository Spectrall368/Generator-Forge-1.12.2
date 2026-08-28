{
	Entity _shootFrom = ${input$entity};
	World projectileLevel = _shootFrom.world;
	if (!projectileLevel.isRemote) {
		Entity _entityToSpawn = ${input$projectile};
		_entityToSpawn.setPosition(_shootFrom.posX, (_shootFrom.posY + _shootFrom.getHeight())- 0.1, _shootFrom.posZ);
		if (_entityToSpawn instanceof IProjectile)
			((IProjectile) _entityToSpawn).shoot(_shootFrom.getLookVec().x, _shootFrom.getLookVec().y, _shootFrom.getLookVec().z, ${opt.toFloat(input$speed)}, ${opt.toFloat(input$inaccuracy)});
		projectileLevel.spawnEntity(_entityToSpawn);
	}
}
