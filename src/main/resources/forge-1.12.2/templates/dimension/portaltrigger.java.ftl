<#--
 # MCreator (https://mcreator.net/)
 # Copyright (C) 2020 Pylo and contributors
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
package ${package}.item;

public class Item${name} extends Item {

	@GameRegistry.ObjectHolder("${modid}:${registryname}")
	public static final Item block = null;

	public Item${name}() {
		super();
		this.maxStackSize = 1;
		setMaxDamage(64);
		setCreativeTab(${data.igniterTab});
	}

	@Override public EnumActionResult onItemUse(EntityPlayer entity, World world, BlockPos pos, EnumHand hand, EnumFacing facing, float hitX, float hitY, float hitZ) {
		pos = pos.offset(facing);
		ItemStack itemstack = entity.getHeldItem(hand);
		if (!entity.canPlayerEdit(pos, facing, itemstack)) {
			return EnumActionResult.FAIL;
		} else {
			int x = pos.getX();
			int y = pos.getY();
			int z = pos.getZ();

			if (world.isAirBlock(pos) && <@procedureOBJToConditionCode data.portalMakeCondition/>)
				World${name}.portal.portalSpawn(world, pos);

			<#if hasProcedure(data.whenPortaTriggerlUsed)>
				<@procedureOBJToCode data.whenPortaTriggerlUsed/>
			</#if>

			itemstack.damageItem(1, entity);
			return EnumActionResult.SUCCESS;
		}
	}
}
<#-- @formatter:on -->
