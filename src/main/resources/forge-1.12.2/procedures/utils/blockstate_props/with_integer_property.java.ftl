private static BlockState blockStateWithInt(IBlockState blockState, String property, int newValue) {
	IProperty prop = blockState.getBlock().blockState.getProperty(property);
	return prop instanceof PropertyInteger && prop.getAllowedValues().contains(newValue) ? blockState.withProperty((PropertyInteger) prop, newValue) : blockState;
}