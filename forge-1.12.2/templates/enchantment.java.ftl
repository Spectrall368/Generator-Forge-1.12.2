<#--
 # MCreator (https://mcreator.net/)
 # Copyright (C) 2012-2020, Pylo
 # Copyright (C) 2020-2024, Pylo, opensource contributors
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
<#include "mcitems.ftl">
package ${package}.enchantment;

public class Enchantment${name} extends Enchantment {

	public EnchantmentCustom(EntityEquipmentSlot... slots) {
		super(Enchantment.Rarity.${data.rarity}, EnumEnchantmentType.${generator.map(data.type, "enchantmenttypes")}, slots);
		this.setName("${registryname}");
        }

	<#if data.maxLevel != 1>
	@Override public int getMaxLevel() {
		return ${data.maxLevel};
	}
	</#if>

	<#if data.damageModifier != 0>
	@Override public int calcModifierDamage(int level, DamageSource source) {
		return level * ${data.damageModifier};
	}
	</#if>

        <#if data.compatibleEnchantments?has_content>
	@Override protected boolean canApplyTogether(Enchantment ench) {
		List<Enchantment> compatibleEnchantments = new ArrayList<>();
		<#list data.compatibleEnchantments as compatibleEnchantment>
		compatibleEnchantments.add(${compatibleEnchantment});
		</#list>
		return <#if data.excludeEnchantments>this != ench && !</#if>compatibleEnchantments.contains(ench);
		}
	</#if>

        <#if data.compatibleItems?has_content>
		@Override public boolean canApplyAtEnchantingTable(ItemStack stack) {
			return <#if data.excludeItems>!</#if>${mappedMCItemsToIngredient(data.compatibleItems)}.test(itemstack);
		}
	</#if>

	<#if data.isTreasureEnchantment>
		@Override public boolean isTreasureEnchantment() {
			return true;
		}
	</#if>

	<#if data.isCurse>
		@Override public boolean isCurse() {
			return true;
		}
	</#if>

	<#if !data.isAllowedOnBooks>
		@Override public boolean isAllowedOnBooks() {
			return false;
		}
	</#if>
}
<#-- @formatter:on -->
