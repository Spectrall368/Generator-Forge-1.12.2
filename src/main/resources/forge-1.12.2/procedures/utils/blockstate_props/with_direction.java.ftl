private static BlockState blockStateWithDirection(IBlockState blockState, Direction newValue) {
	IProperty prop = blockState.getBlock().blockState.getProperty("facing");
	if (prop instanceof PropertyDirection && ((PropertyDirection) prop).getAllowedValues().contains(newValue)) return blockState.withProperty((PropertyDirection) prop, newValue);
	prop = blockState.getBlock().blockState.getProperty("axis");
	return prop instanceof PropertyEnum && ((PropertyEnum) prop).getAllowedValues().contains(newValue.getAxis()) ? blockState.withProperty((PropertyEnum) prop, newValue.getAxis()) : blockState;
}