private static IProperty getPropertyByName(IBlockState state, String name) {
	for (IProperty property : state.getPropertyKeys()) {
		if (property.getName().equals(name))
			return property;
	}

	return null;
}