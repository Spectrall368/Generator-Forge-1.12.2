<#include "procedures.java.ftl">

<#-- Item-related triggers -->
<#macro CreativeTabs tabs="[]">
	<#if tabs == "[]">
		null
	<#else>
		${tabs[tabs?size - 1]}
	</#if>
</#macro>

<#macro addSpecialInformation procedure="" translationKeyHeader="" isBlock=false>
	<#if procedure?has_content && (hasProcedure(procedure) || !procedure.getFixedValue().isEmpty())>
		@Override @SideOnly(Side.CLIENT) public void addInformation(ItemStack itemstack, World world, List<String> list, ITooltipFlag flag) {
		super.addInformation(itemstack, world, list, flag);
		<#if hasProcedure(procedure)>
			Entity entity = Minecraft.getMinecraft().player;
			String hoverText = <@procedureCode procedure, {
				"x": "entity != null ? entity.posX : 0.0",
				"y": "entity != null ? entity.posY : 0.0",
				"z": "entity != null ? entity.posZ : 0.0",
				"entity": "entity",
				"world": "world",
				"itemstack": "itemstack"
			}, false/>;
			if (hoverText != null) {
				for (String line : hoverText.split("\n")) {
					list.add(new TextComponentString(line));
				}
			}
		<#elseif translationKeyHeader?has_content>
			<#list procedure.getFixedValue() as entry>
				list.add(new TextComponentTranslation("${translationKeyHeader}.description_${entry?index}").getFormattedText());
			</#list>
		<#else>
			<#list procedure.getFixedValue() as entry>
				list.add(new TextComponentString("${JavaConventions.escapeStringForJava(entry)}").getFormattedText());
			</#list>
		</#if>
		}
	</#if>
</#macro>

<#macro onEntitySwing procedure="">
<#if hasProcedure(procedure)>
@Override public boolean onEntitySwing(EntityLivingBase entity, ItemStack itemstack) {
	boolean retval = super.onEntitySwing(entity, itemstack);
	<@procedureCode procedure, {
		"x": "entity.posX",
		"y": "entity.posY",
		"z": "entity.posZ",
		"world": "entity.world",
		"entity": "entity",
		"itemstack": "itemstack"
	}/>
	return retval;
}
</#if>
</#macro>

<#macro onCrafted procedure="">
<#if hasProcedure(procedure)>
@Override public void onCreated(ItemStack itemstack, World world, EntityPlayer entity) {
	super.onCreated(itemstack, world, entity);
	<@procedureCode data.onCrafted, {
		"x": "entity.posX",
		"y": "entity.posY",
		"z": "entity.posZ",
		"world": "world",
		"entity": "entity",
		"itemstack": "itemstack"
	}/>
}
</#if>
</#macro>

<#macro onEntityHitWith procedure="" hurtStack=false hurtStackAmount=2>
<#if hasProcedure(procedure) || hurtStack>
@Override public boolean hitEntity(ItemStack itemstack, EntityLivingBase entity, EntityLivingBase sourceentity) {
	<#if hurtStack>
		itemstack.damageItem(${hurtStackAmount}, entity);
	<#else>
		boolean retval = super.hitEntity(itemstack, entity, sourceentity);
	</#if>
	<#if hasProcedure(procedure)>
		<@procedureCode procedure, {
			"x": "entity.posX",
			"y": "entity.posY",
			"z": "entity.posZ",
			"world": "entity.world",
			"entity": "entity",
			"sourceentity": "sourceentity",
			"itemstack": "itemstack"
		}/>
	</#if>
	return <#if hurtStack>true<#else>retval</#if>;
}
</#if>
</#macro>

<#macro onBlockDestroyedWith procedure="" hurtStack=false>
<#if hasProcedure(procedure) || hurtStack>
@Override public boolean onBlockDestroyed(ItemStack itemstack, World world, IBlockState blockstate, BlockPos pos, EntityLivingBase entity) {
	<#if hurtStack>
		itemstack.damageItem(1, entity);
	<#else>
		boolean retval = super.onBlockDestroyed(itemstack,world,blockstate,pos,entity);
	</#if>
	<#if hasProcedure(procedure)>
		<@procedureCode procedure, {
			"x": "pos.getX()",
			"y": "pos.getY()",
			"z": "pos.getZ()",
			"world": "world",
			"entity": "entity",
			"itemstack": "itemstack",
			"blockstate": "blockstate"
		}/>
	</#if>
	return <#if hurtStack>true<#else>retval</#if>;
}
</#if>
</#macro>

<#macro onRightClickedInAir procedure="">
<#if hasProcedure(procedure)>
@Override public ActionResult<ItemStack> onItemRightClick(World world, EntityPlayer entity, EnumHand hand) {
	ActionResult<ItemStack> ar = super.onItemRightClick(world, entity, hand);
	<@procedureCode procedure, {
		"x": "entity.posX",
		"y": "entity.posY",
		"z": "entity.posZ",
		"world": "world",
		"entity": "entity",
		"itemstack": "ar.getResult()"
	}/>
	return ar;
}
</#if>
</#macro>

<#macro onItemTick inUseProcedure="" inInvProcedure="">
<#if hasProcedure(inUseProcedure) || hasProcedure(inInvProcedure)>
@Override public void onUpdate(ItemStack itemstack, World world, Entity entity, int slot, boolean selected) {
	super.onUpdate(itemstack, world, entity, slot, selected);
	<#if hasProcedure(inUseProcedure)>
	if (selected)
		<@procedureCode inUseProcedure, {
			"x": "entity.posX",
			"y": "entity.posY",
			"z": "entity.posZ",
			"world": "world",
			"entity": "entity",
			"itemstack": "itemstack",
			"slot": "slot"
		}/>
	</#if>
	<#if hasProcedure(inInvProcedure)>
		<@procedureCode inInvProcedure, {
			"x": "entity.posX",
			"y": "entity.posY",
			"z": "entity.posZ",
			"world": "world",
			"entity": "entity",
			"itemstack": "itemstack",
			"slot": "slot"
		}/>
	</#if>
}
</#if>
</#macro>

<#macro onDroppedByPlayer procedure="">
<#if hasProcedure(procedure)>
@Override public boolean onDroppedByPlayer(ItemStack itemstack, EntityPlayer entity) {
	<@procedureCode procedure, {
		"x": "entity.posX",
		"y": "entity.posY",
		"z": "entity.posZ",
		"world": "entity.world",
		"entity": "entity",
		"itemstack": "itemstack"
	}/>
	return true;
}
</#if>
</#macro>

<#macro onItemUsedOnBlock procedure="">
<#if hasProcedure(procedure)>
@Override public EnumActionResult onItemUseFirst(EntityPlayer player, World world, BlockPos pos, EnumFacing side, float hitX, float hitY, float hitZ, EnumHand hand) {
	super.onItemUseFirst(player, world, pos, side, hitX, hitY, hitZ, hand);
	<@procedureCodeWithOptResult procedure, "actionresulttype", "EnumActionResult.SUCCESS", {
		"world": "world",
		"x": "pos.getX()",
		"y": "pos.getY()",
		"z": "pos.getZ()",
		"blockstate": "world.getBlockState(pos)",
		"entity": "player",
		"direction": "side",
		"itemstack": "player.getHeldItem(hand)"
	}/>
}
</#if>
</#macro>

<#macro hasGlow procedure="">
<#if procedure?has_content && (hasProcedure(procedure) || procedure.getFixedValue())>
@Override @SideOnly(Side.CLIENT) public boolean hasEffect(ItemStack itemstack) {
	<#if hasProcedure(procedure)>
		<#assign dependencies = procedure.getDependencies(generator.getWorkspace())>
		<#if !(dependencies.isEmpty() || (dependencies.size() == 1 && dependencies.get(0).getName() == "itemstack"))>
		Entity entity = Minecraft.getMinecraft().player;
		</#if>
		return <@procedureCode procedure, {
			"x": "entity.posX",
			"y": "entity.posY",
			"z": "entity.posZ",
			"entity": "entity",
			"world": "entity.world",
			"itemstack": "itemstack"
		}/>
	<#else>
		return true;
	</#if>
}
</#if>
</#macro>

<#-- Armor triggers -->
<#macro onArmorTick procedure="">
<#if hasProcedure(procedure)>
@Override public void onArmorTick(World world, EntityPlayer entity, ItemStack itemstack) {
	<@procedureCode procedure, {
		"x": "entity.posX",
		"y": "entity.posY",
		"z": "entity.posZ",
		"world": "world",
		"entity": "entity",
		"itemstack": "itemstack"
	}/>
}
</#if>
</#macro>

<#-- Not supported -->
<#macro onItemEntityDestroyed procedure="">
<#if hasProcedure(procedure)>
</#if>
</#macro>

<#-- Block-related triggers -->
<#macro onDestroyedByExplosion procedure="">
<#if hasProcedure(procedure)>
@Override public void onBlockDestroyedByExplosion(World world, BlockPos pos, Explosion e) {
	super.onBlockDestroyedByExplosion(world, pos, e);
	<@procedureCode procedure, {
	"x": "pos.getX()",
	"y": "pos.getY()",
	"z": "pos.getZ()",
	"world": "world"
	}/>
}
</#if>
</#macro>

<#macro onEntityCollides procedure="">
<#if hasProcedure(procedure)>
@Override public void onEntityCollidedWithBlock(World world, BlockPos pos, IBlockState blockstate, Entity entity) {
	super.onEntityCollidedWithBlock(world, pos, blockstate, entity);
	<@procedureCode procedure, {
	"x": "pos.getX()",
	"y": "pos.getY()",
	"z": "pos.getZ()",
	"world": "world",
	"entity": "entity",
	"blockstate": "blockstate"
	}/>
}
</#if>
</#macro>

<#macro onBlockAdded procedure="" scheduleTick=false tickRate=0>
<#if scheduleTick || hasProcedure(procedure)>
@Override public void onBlockAdded(World world, BlockPos pos, IBlockState blockstate) {
	super.onBlockAdded(world, pos, blockstate);
	<#if scheduleTick>
		world.scheduleUpdate(pos, this, ${tickRate});
	</#if>
	<#if hasProcedure(procedure)>
		<@procedureCode procedure, {
		"x": "pos.getX()",
		"y": "pos.getY()",
		"z": "pos.getZ()",
		"world": "world",
		"blockstate": "blockstate",
		"oldState": "null",
		"moving": "false"
		}/>
	</#if>
}
</#if>
</#macro>

<#macro onRedstoneOrNeighborChanged onRedstoneOn="" onRedstoneOff="" onNeighborChanged="">
<#if hasProcedure(onRedstoneOn) || hasProcedure(onRedstoneOff) || hasProcedure(onNeighborChanged)>
@Override public void neighborChanged(IBlockState blockstate, World world, BlockPos pos, Block neighborBlock, BlockPos fromPos) {
	super.neighborChanged(blockstate, world, pos, neighborBlock, fromPos);
	<#if hasProcedure(onRedstoneOn) || hasProcedure(onRedstoneOff)>
		if (world.isBlockIndirectlyGettingPowered(pos) > 0) {
		<#if hasProcedure(onRedstoneOn)>
			<@procedureCode onRedstoneOn, {
			"x": "pos.getX()",
			"y": "pos.getY()",
			"z": "pos.getZ()",
			"world": "world",
			"blockstate": "blockstate"
			}/>
		</#if>
		}
		<#if hasProcedure(onRedstoneOff)> else {
			<@procedureCode onRedstoneOff, {
			"x": "pos.getX()",
			"y": "pos.getY()",
			"z": "pos.getZ()",
			"world": "world",
			"blockstate": "blockstate"
			}/>
		}
		</#if>
	</#if>
	<#if hasProcedure(onNeighborChanged)>
		<@procedureCode onNeighborChanged, {
		"x": "pos.getX()",
		"y": "pos.getY()",
		"z": "pos.getZ()",
		"world": "world",
		"blockstate": "blockstate"
		}/>
	</#if>
}
</#if>
</#macro>

<#macro onAnimateTick procedure="">
<#if hasProcedure(procedure)>
@Override @SideOnly(Side.CLIENT) public void randomDisplayTick(IBlockState blockstate, World world, BlockPos pos, Random random) {
	super.randomDisplayTick(blockstate, world, pos, random);
	<@procedureCode procedure, {
	"x": "pos.getX()",
	"y": "pos.getY()",
	"z": "pos.getZ()",
	"world": "world",
	"entity": "Minecraft.getInstance().player",
	"blockstate": "blockstate"
	}/>
}
</#if>
</#macro>

<#macro onBlockTick procedure="" scheduleTick=false tickRate=0>
<#if hasProcedure(procedure)>
@Override public void updateTick(IBlockState blockstate, World world, BlockPos pos, Random random) {
	super.updateTick(blockstate, world, pos, random);
	<@procedureCode procedure, {
	"x": "pos.getX()",
	"y": "pos.getY()",
	"z": "pos.getZ()",
	"world": "world",
	"blockstate": "blockstate"
	}/>
	<#if scheduleTick>
	world.scheduleUpdate(pos, this, ${tickRate});
	</#if>
}
</#if>
</#macro>

<#macro onDestroyedByPlayer procedure="">
<#if hasProcedure(procedure)>
@Override public boolean removedByPlayer(IBlockState blockstate, World world, BlockPos pos, EntityPlayer entity, boolean willHarvest) {
	boolean retval = super.removedByPlayer(blockstate, world, pos, entity, willHarvest);
	<@procedureCode procedure, {
	"x": "pos.getX()",
	"y": "pos.getY()",
	"z": "pos.getZ()",
	"world": "world",
	"entity": "entity",
	"blockstate": "blockstate"
	}/>
	return retval;
}
</#if>
</#macro>

<#macro onEntityWalksOn procedure="" speedF=1.0>
<#if hasProcedure(procedure) || speedF != 1.0>
@Override public void onEntityWalk(World world, BlockPos pos, Entity entity) {
	super.onEntityWalk(world, pos, entity);

    <#if speedF != 1.0>
	entity.setMotion(entity.getMotion().mul(${speedF}D, 1.0D, ${speedF}D));
    </#if>

    <#if hasProcedure(procedure)>
	<@procedureCode procedure, {
	"x": "pos.getX()",
	"y": "pos.getY()",
	"z": "pos.getZ()",
	"world": "world",
	"entity": "entity",
	"blockstate": "world.getBlockState(pos)"
	}/>
	</#if>
}
</#if>
</#macro>

<#macro onEntityFallsOn procedure="">
<#if hasProcedure(data.onEntityFallsOn)>
@Override public void onFallenUpon(World world, BlockPos pos, Entity entity, float distance) {
	super.onFallenUpon(world, pos, entity, distance);
	<@procedureCode data.onEntityFallsOn, {
		"x": "pos.getX()",
		"y": "pos.getY()",
		"z": "pos.getZ()",
		"world": "world",
		"entity": "entity",
		"blockstate": "world.getBlockState(pos)",
		"distance": "distance"
	}/>
}
</#if>
</#macro>

<#macro onBlockPlacedBy procedure="">
<#if hasProcedure(procedure)>
@Override public void onBlockPlacedBy(World world, BlockPos pos, IBlockState blockstate, EntityLivingBase entity, ItemStack itemstack) {
	super.onBlockPlacedBy(world, pos, blockstate, entity, itemstack);
	<@procedureCode procedure, {
	"x": "pos.getX()",
	"y": "pos.getY()",
	"z": "pos.getZ()",
	"world": "world",
	"entity": "entity",
	"blockstate": "blockstate",
	"itemstack": "itemstack"
	}/>
}
</#if>
</#macro>

<#macro onStartToDestroy procedure="">
<#if hasProcedure(procedure)>
@Override public void onBlockClicked(World world, BlockPos pos, EntityPlayer entity) {
	super.onBlockClicked(world, pos, entity);
	<@procedureCode procedure, {
	"x": "pos.getX()",
	"y": "pos.getY()",
	"z": "pos.getZ()",
	"world": "world",
	"entity": "entity",
	"blockstate": "word.getBlockState(pos)"
	}/>
}
</#if>
</#macro>

<#macro onBlockRightClicked procedure="">
<#if hasProcedure(procedure)>
@Override public boolean onBlockActivated(World world, BlockPos pos, IBlockState blockstate, EntityPlayer entity, EnumHand hand, EnumFacing facing, float hitX, float hitY, float hitZ) {
	super.onBlockActivated(world, pos, blockstate, entity, hand, facing, hitX, hitY, hitZ);
	<@procedureCodeWithOptResult procedure, "actionresulttype", "EnumActionResult.SUCCESS", {
	"x": "pos.getX()",
	"y": "pos.getY()",
	"z": "pos.getZ()",
	"world": "world",
	"blockstate": "blockstate",
	"entity": "entity",
	"direction": "facing",
	"hitX": "hitX",
	"hitY": "hitY",
	"hitZ": "hitZ"
	}, true/>
}
</#if>
</#macro>

<#macro onHitByProjectile procedure="">
<#if hasProcedure(procedure)>
@Override public void onEntityCollidedWithBlock(World world, BlockPos pos, IBlockState blockstate, Entity entity) {
	<@procedureCode procedure, {
	"x": "pos.getX()",
	"y": "pos.getY()",
	"z": "pos.getZ()",
	"world": "world",
	"blockstate": "blockstate",
	"entity": "entity",
	"direction": "EnumFacing.getFacingFromVector(entity.posX, entity.posY, entity.posZ)",
	"hitX": "entity.posX",
	"hitY": "entity.posY",
	"hitZ": "entity.posZ"
	}/>
}
</#if>
</#macro>

<#macro bonemealEvents isBonemealTargetCondition="" bonemealSuccessCondition="" onBonemealSuccess="">
@Override public boolean canGrow(World worldIn, BlockPos pos, IBlockState blockstate, boolean clientSide) {
	<#if hasProcedure(isBonemealTargetCondition)>
		return <@procedureCode isBonemealTargetCondition, {
			"x": "pos.getX()",
			"y": "pos.getY()",
			"z": "pos.getZ()",
			"world": "world",
			"blockstate": "blockstate",
			"clientSide": "clientSide"
		}/>
	<#else>
	return true;
	</#if>
}

@Override public boolean canUseBonemeal(World world, Random random, BlockPos pos, IBlockState blockstate) {
	<#if hasProcedure(bonemealSuccessCondition)>
	return <@procedureCode bonemealSuccessCondition, {
		"x": "pos.getX()",
		"y": "pos.getY()",
		"z": "pos.getZ()",
		"world": "world",
		"blockstate": "blockstate"
	}/>
	<#else>
	return true;
	</#if>
}

@Override public void grow(World world, Random random, BlockPos pos, IBlockState blockstate) {
	<#if hasProcedure(onBonemealSuccess)>
	<@procedureCode onBonemealSuccess, {
	"x": "pos.getX()",
	"y": "pos.getY()",
	"z": "pos.getZ()",
	"world": "world",
	"blockstate": "blockstate"
	}/>
	</#if>
}
</#macro>