<#include "mcelements.ftl">
<#include "mcitems.ftl">
<#if field$nbt == "FALSE" && field$state == "FALSE">
world.setBlockState(${toBlockPos(input$x,input$y,input$z)}, ${mappedBlockToBlockStateCode(input$block)},3);
<#else>
{
	BlockPos _bp = ${toBlockPos(input$x,input$y,input$z)};
	IBlockState _bs = ${mappedBlockToBlockStateCode(input$block)};

	<#if field$state == "TRUE">
	IBlockState _bso = world.getBlockState(_bp);
	for(Map.Entry<IProperty<?>, Comparable<?>> entry : _bso.getProperties().entrySet()) {
		IProperty _property = entry.getKey();
		if (_bs.getPropertyKeys().contains(_property))
			_bs = _bs.withProperty(_property, (Comparable) entry.getValue());
	}
	</#if>

	<#if field$nbt == "TRUE">
	TileEntity _te = world.getTileEntity(_bp);
	NBTTagCompound _bnbt = null;
	if(_te != null) {
		_bnbt = _te.writeToNBT(new NBTTagCompound());
		_te.invalidate();
	}
	</#if>

	world.setBlockState(_bp, _bs, 3);

	<#if field$nbt == "TRUE">
	if(_bnbt != null) {
		_te = world.getTileEntity(_bp);
		if(_te != null) {
			try {
				_te.readFromNBT(_bnbt);
			} catch(Exception ignored) {}
		}
	}
	</#if>
}
</#if>