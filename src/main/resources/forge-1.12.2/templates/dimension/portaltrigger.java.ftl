<#--
 # MCreator (https://mcreator.net/)
 # Copyright (C) 2012-2020, Pylo
 # Copyright (C) 2020-2026, Pylo, opensource contributors
 #
 # This program is free software: you can redistribute it and/or modify
 # it under the terms of the GNU General Public License as published by
 # the Free Software Foundation, either version 3 of the License, or
 # (at your option) any later version.
 #
 # This program is distributed in the hope that it will be useful,
 # but WITHOUT ANY WARRANTY; without even the implied warranty of
 # MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 # GNU General Public License for more details.
 #
 # You should have received a copy of the GNU General Public License
 # along with this program.  If not, see <https://www.gnu.org/licenses/>.
 #
 # Additional permission for code generator templates (*.ftl files)
 #
 # As a special exception, you may create a larger work that contains part or
 # all of the MCreator code generator templates (*.ftl files) and distribute
 # that work under terms of your choice, so long as that work isn't itself a
 # template for code generation. Alternatively, if you modify or redistribute
 # the template itself, you may (at your option) remove this special exception,
 # which will cause the template and the resulting code generator output files
 # to be licensed under the GNU General Public License without this special
 # exception.
-->

<#-- @formatter:off -->
<#include "../procedures.java.ftl">
<#include "../triggers.java.ftl">
package ${package}.item;

public class ${name}Item extends Item {

	public ${name}Item() {
		setUnlocalizedName("${modid}.${registryname}");
		setCreativeTab(<@CreativeTabs data.creativeTabs/>);
		setMaxStackSize(1);
	    setMaxDamage(64);
	}

    <#if data.igniterRarity != "COMMON">
    @Override public EnumRarity getRarity(ItemStack stack) {
		return EnumRarity.${data.igniterRarity};
    }
    </#if>

	<@addSpecialInformation data.specialInformation, "item." + modid + "." + registryname/>

	@Override public EnumActionResult onItemUse(EntityPlayer entity, World world, BlockPos pos, EnumHand hand, EnumFacing facing, float hitX, float hitY, float hitZ) {
		pos = pos.offset(facing);
		ItemStack itemstack = entity.getHeldItem(hand);
		if (!entity.canPlayerEdit(pos, facing, itemstack)) {
			return EnumActionResult.FAIL;
		} else {
			int x = pos.getX();
			int y = pos.getY();
			int z = pos.getZ();
			boolean success = false;

			if (world.isAirBlock(pos) && <@procedureOBJToConditionCode data.portalMakeCondition/>) {
				${JavaModName}Blocks.${REGISTRYNAME}_PORTAL.portalSpawn(world, pos);
				itemstack.damageItem(1, entity);
				success = true;
			}

			<#if hasProcedure(data.whenPortaTriggerlUsed)>
				<#if hasReturnValueOf(data.whenPortaTriggerlUsed, "actionresulttype")>
					EnumActionResult result = <@procedureOBJToInteractionResultCode data.whenPortaTriggerlUsed/>;
					return success ? EnumActionResult.SUCCESS : result;
				<#else>
					<@procedureOBJToCode data.whenPortaTriggerlUsed/>
					return EnumActionResult.SUCCESS;
				</#if>
			<#else>
				return success ? EnumActionResult.SUCCESS : EnumActionResult.FAIL;
			</#if>
		}
	}
}
<#-- @formatter:on -->