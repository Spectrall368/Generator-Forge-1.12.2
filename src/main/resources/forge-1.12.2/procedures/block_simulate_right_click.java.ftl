<#include "mcelements.ftl">
if(${input$entity} instanceof EntityPlayer) {
	Entity _ent = ${input$entity};
	BlockPos _bp = ${toBlockPos(input$x,input$y,input$z)};
	_ent.world.getBlockState(_bp).getBlock().onBlockActivated(_ent.world, _bp, _ent.world.getBlockState(_bp), (EntityPlayer) ${input$entity}, EnumHand.MAIN_HAND,
        	EnumFacing.UP, _bp.getX(), _bp.getY(), _bp.getZ());
}