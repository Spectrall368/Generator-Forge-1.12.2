<@addTemplate file="utils/blockstate_props/property_from_string.java.ftl"/>
private static EnumFacing getDirectionFromBlockState(IBlockState blockState) {
	IProperty prop = getPropertyByName(blockState, "facing");
	if (prop instanceof PropertyDirection) return blockState.getValue((PropertyDirection) prop);
	prop = getPropertyByName(blockState, "axis");
	return prop instanceof PropertyEnum && ((PropertyEnum) prop).getAllowedValues().toArray()[0] instanceof EnumFacing.Axis ?
		EnumFacing.getFacingFromAxisDirection((Direction.Axis) blockState.get((PropertyEnum) prop), EnumFacing.AxisDirection.POSITIVE) : EnumFacing.NORTH;
}