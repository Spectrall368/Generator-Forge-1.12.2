<#include "mcelements.ftl">
<@head>
if(!world.isRemote) {
	BlockPos _bp = ${toBlockPos(input$x,input$y,input$z)};
	TileEntity _tileEntity = world.getTileEntity(_bp);
	BlockState _bs = world.getBlockState(_bp);
	if(_tileEntity != null) {
</@head>
		_tileEntity.getTileData().setString(${input$tagName}, ${input$tagValue});
<@tail>
	}

	world.notifyBlockUpdate(_bp, _bs, _bs, 3);
}</@tail>