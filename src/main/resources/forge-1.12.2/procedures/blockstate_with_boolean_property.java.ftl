<#include "mcitems.ftl">
/*@BlockState*/(${mappedBlockToBlock(input$block)}.blockState.getProperty(${input$property}) instanceof PropertyBool ?
	${mappedBlockToBlockStateCode(input$block)}.withProperty((PropertyBool) ${mappedBlockToBlock(input$block)}.blockState.getProperty(${input$property}), ${input$value}) : ${mappedBlockToBlockStateCode(input$block)})