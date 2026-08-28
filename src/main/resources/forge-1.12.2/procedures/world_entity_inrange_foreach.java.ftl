{
	final Vec3d _center = new Vec3d(${input$x}, ${input$y}, ${input$z});
	for (Entity entityiterator : world.getEntitiesWithinAABB(Entity.class, new AxisAlignedBB(_center, _center).grow(${input$range} / 2d), e -> true)
		.stream().sorted(Comparator.comparingDouble(_entcnd -> _entcnd.getDistanceSq(_center))).collect(Collectors.toList())) {
		${statement$foreach}
	}
}