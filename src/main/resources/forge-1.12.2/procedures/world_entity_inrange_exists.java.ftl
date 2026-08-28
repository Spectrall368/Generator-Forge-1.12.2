(!world.getEntitiesWithinAABB(${generator.map(field$entity, "entities", 0)}.class,
	new AxisAlignedBB(Vec3d.ZERO, Vec3d.ZERO).offset(new Vec3d(${input$x}, ${input$y}, ${input$z})).grow(${input$range} / 2d), e -> true)
	.isEmpty())