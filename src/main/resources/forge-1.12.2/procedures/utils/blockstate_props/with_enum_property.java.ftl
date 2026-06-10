private static BlockState blockStateWithEnum(IBlockState blockState, String property, String newValue) {
	IProperty prop = blockState.getBlock().blockState.getProperty(property);
	return prop instanceof PropertyEnum && ((PropertyEnum) prop).parseValue(newValue).isPresent() ? blockState.withProperty((PropertyEnum) prop, (Enum) ((PropertyEnum) prop).parseValue(newValue).get()) : blockState;
}