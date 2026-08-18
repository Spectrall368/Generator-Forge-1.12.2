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
<#include "mcitems.ftl">
<#include "procedures.java.ftl">
<#include "triggers.java.ftl">
package ${package}.item;

<#if data.toolType == "Shield">
import net.minecraft.util.text.translation.I18n;
</#if>

<@javacompress>
<#if data.toolType == "Pickaxe" || data.toolType == "Axe" || data.toolType == "Sword" || data.toolType == "Spade"
		|| data.toolType == "Hoe" || data.toolType == "Shears" || data.toolType == "Shield" || data.toolType == "MultiTool">
public class ${name}Item extends Item${data.toolType?replace("MultiTool", "Tool")} {
	public ${name}Item () {
		super(<#if data.toolType == "MultiTool">1f, ${data.attackSpeed - 4}f,</#if><#if data.toolType == "Pickaxe" || data.toolType == "Axe" || data.toolType == "Sword"
				|| data.toolType == "Spade" || data.toolType == "Hoe" || data.toolType == "MultiTool">
			EnumHelper.addToolMaterial("${registryname?upper_case}",
				<#if data.blockDropsTier == "WOOD" || data.blockDropsTier == "GOLD">
					0
				<#elseif data.blockDropsTier == "STONE">
					1
				<#elseif data.blockDropsTier == "IRON">
					2
				<#elseif data.blockDropsTier == "DIAMOND">
					3
				<#else>
					4
				</#if>, ${data.usageCount}, ${data.efficiency}f,
				<#if data.toolType == "Sword">
					${data.damageVsEntity - 4}f
				<#elseif data.toolType == "Spade">
					${data.damageVsEntity - 2.5}f
				<#elseif data.toolType == "Hoe">
					${data.damageVsEntity - 1}f
				<#else>
					${data.damageVsEntity - 2}f
				</#if>, ${data.enchantability})<#if data.toolType == "MultiTool">, Collections.emptySet()<#elseif data.toolType == "Axe">,${data.damageVsEntity - 1}f, ${data.attackSpeed - 4}f</#if>);

			<#if data.toolType == "Pickaxe" || data.toolType == "Spade">
				attackSpeed = ${data.attackSpeed - 4}f;
			<#elseif data.toolType == "Hoe">
				speed = ${data.attackSpeed}f;
			</#if>

				setUnlocalizedName("${modid}.${registryname}");
				setCreativeTab(<@CreativeTabs data.creativeTabs/>);
				<#if data.stayInGridWhenCrafting && data.usageCount != 0>
				setNoRepair();
				</#if>
		<#elseif data.toolType == "Shears" || data.toolType == "Shield">);
				setUnlocalizedName("${modid}.${registryname}");
				setCreativeTab(<@CreativeTabs data.creativeTabs/>);
				setMaxDamage(${data.usageCount});
				<#if data.stayInGridWhenCrafting && data.usageCount != 0>
				setNoRepair();
				</#if>
		</#if>
	}

	@Override public Set<String> getToolClasses(ItemStack stack) {
	    HashMap<String, Integer> ret = new HashMap<>();
	    ret.put("${data.blockDropsTier?lower_case}",
		    <#if data.blockDropsTier == "WOOD" || data.blockDropsTier == "GOLD">
				0
			<#elseif data.blockDropsTier == "STONE">
				1
			<#elseif data.blockDropsTier == "IRON">
				2
			<#elseif data.blockDropsTier == "DIAMOND">
				3
			<#else>
				4
			</#if>);
	    return ret.keySet();
	}

	<#if data.toolType == "Shield">
	@Override public String getItemStackDisplayName(ItemStack stack) {
        if (stack.getSubCompound("BlockEntityTag") != null) {
            EnumDyeColor enumdyecolor = TileEntityBanner.getColor(stack);
            return I18n.translateToLocal("item.${modid}.${registryname}." + enumdyecolor.getUnlocalizedName() + ".name");
        } else {
            return I18n.translateToLocal("item.${modid}.${registryname}.name");
        }
    }
	</#if>

	<#if hasProcedure(data.additionalDropCondition)>
	@Override public boolean canHarvestBlock(IBlockState blockstate, ItemStack itemstack) {
		return super.canHarvestBlock(blockstate, itemstack) && <@procedureCode data.additionalDropCondition, {
			"itemstack": "itemstack",
			"blockstate": "blockstate"
		}, false/>;
	}
	</#if>

	<#if data.repairItems?has_content>
	@Override public boolean getIsRepairable(ItemStack itemstack, ItemStack repairitem) {
		return ${mappedMCItemsToIngredient(data.repairItems)}.test(repairitem);
	}
	</#if>

	<#if data.toolType=="Shears">
		@Override public int getItemEnchantability() {
			return ${data.enchantability};
		}

		@Override public float getDestroySpeed(ItemStack stack, IBlockState blockstate) {
			return ${data.efficiency}f;
		}
	<#elseif data.toolType=="MultiTool">
		@Override public boolean canHarvestBlock(IBlockState blockstate) {
			<#if hasProcedure(data.additionalDropCondition)>
				if(!<@procedureCode data.additionalDropCondition, {
					"itemstack": "this.getDefaultInstance()",
					"blockstate": "blockstate"
				}, false/>) return false;
			</#if>
			return <#if data.blockDropsTier == "WOOD" || data.blockDropsTier == "GOLD">
			0
			<#elseif data.blockDropsTier == "STONE">
			1
			<#elseif data.blockDropsTier == "IRON">
			2
			<#elseif data.blockDropsTier == "DIAMOND">
			3
			<#else>
			4
			</#if> >= blockstate.getBlock().getHarvestLevel(blockstate);
		}

		@Override public float getDestroySpeed(ItemStack itemstack, IBlockState blockstate) {
			return ${data.efficiency}f;
		}
	</#if>

	<#if data.toolType == "Sword" || data.toolType == "Hoe">
		@Override public Multimap<String, AttributeModifier> getItemAttributeModifiers(EntityEquipmentSlot equipmentSlot) {
			if (equipmentSlot == EntityEquipmentSlot.MAINHAND) {
				ImmutableMultimap.Builder<String, AttributeModifier> builder = ImmutableMultimap.builder();
				builder.put(SharedMonsterAttributes.ATTACK_DAMAGE.getName(), new AttributeModifier(ATTACK_DAMAGE_MODIFIER, "Tool modifier", <#if data.toolType == "Hoe">${data.damageVsEntity - 1}f<#else>attackDamage</#if>, 0));
				builder.put(SharedMonsterAttributes.ATTACK_SPEED.getName(), new AttributeModifier(ATTACK_SPEED_MODIFIER, "Tool modifier", ${data.attackSpeed - 4}, 0));
				return builder.build();
			}

			return super.getItemAttributeModifiers(equipmentSlot);
		}
	</#if>

	<#if data.toolType=="MultiTool">
		<@onBlockDestroyedWith data.onBlockDestroyedWithTool, true/>

		<@onEntityHitWith data.onEntityHitWith, true/>
	<#else>
		<@onBlockDestroyedWith data.onBlockDestroyedWithTool/>

		<@onEntityHitWith data.onEntityHitWith/>
	</#if>

	<@onRightClickedInAir data.onRightClickedInAir/>

	<@commonMethods/>
}
<#elseif data.toolType=="Special">
public class ${name}Item extends Item {

	public ${name}Item() {
			setUnlocalizedName("${modid}.${registryname}");
			setCreativeTab(<@CreativeTabs data.creativeTabs/>);
			setMaxDamage(${data.usageCount});
			<#if data.stayInGridWhenCrafting && data.usageCount != 0>
			setNoRepair();
			</#if>
	}

	@Override public float getDestroySpeed(ItemStack itemstack, IBlockState blockstate) {
	    <#assign hasDefaultTag = data.blocksAffected?has_content && replaceInList(data.blocksAffected, "minecraft:stone_ore_replaceables", "stone_ore_replaceables")?seq_contains("TAG:stone_ore_replaceables")>
	    <#if hasDefaultTag>Block blockAt = blockstate.getBlock();</#if>
		return <#if data.blocksAffected?has_content><#if hasDefaultTag>blockAt == Blocks.STONE || blockAt == Blocks.GRANITE || blockAt == Blocks.DIORITE || blockAt == Blocks.ANDESITE <#if (data.blocksAffected?size > 1)>|| </#if></#if><#if !hasDefaultTag || (data.blocksAffected?size > 1)>${containsAnyOfBlocks(removeFromList(removeFromList(data.blocksAffected, "TAG:stone_ore_replaceables"), "TAG:minecraft:stone_ore_replaceables"), "blockstate")}</#if> ? ${data.efficiency}f : </#if>1;
	}

	<@onBlockDestroyedWith data.onBlockDestroyedWithTool, true/>

	<@onEntityHitWith data.onEntityHitWith, true/>

	<@onRightClickedInAir data.onRightClickedInAir/>

	@Override public int getItemEnchantability() {
		return ${data.enchantability};
	}

	@Override public Multimap<String, AttributeModifier> getItemAttributeModifiers(EntityEquipmentSlot equipmentSlot) {
		if (equipmentSlot == EntityEquipmentSlot.MAINHAND) {
			ImmutableMultimap.Builder<String, AttributeModifier> builder = ImmutableMultimap.builder();
			builder.putAll(super.getItemAttributeModifiers(equipmentSlot));
			builder.put(SharedMonsterAttributes.ATTACK_DAMAGE.getName(), new AttributeModifier(ATTACK_DAMAGE_MODIFIER, "Tool modifier", ${data.damageVsEntity - 1}f, 0));
			builder.put(SharedMonsterAttributes.ATTACK_SPEED.getName(), new AttributeModifier(ATTACK_SPEED_MODIFIER, "Tool modifier", ${data.attackSpeed - 4}, 0));
			return builder.build();
		}

		return super.getItemAttributeModifiers(equipmentSlot);
	}

	<@commonMethods/>
}
<#elseif data.toolType=="Fishing rod">
public class ${name}Item extends ItemFishingRod {

	public ${name}Item() {
			setUnlocalizedName("${modid}.${registryname}");
			setCreativeTab(<@CreativeTabs data.creativeTabs/>);
			setMaxDamage(${data.usageCount});
			<#if data.stayInGridWhenCrafting && data.usageCount != 0>
			setNoRepair();
			</#if>
	}

	<#if data.repairItems?has_content>
    	@Override public boolean getIsRepairable(ItemStack itemstack, ItemStack repairitem) {
			return ${mappedMCItemsToIngredient(data.repairItems)}.test(repairitem);
    	}
    </#if>

	@Override public int getItemEnchantability() {
		return ${data.enchantability};
	}

	<@onBlockDestroyedWith data.onBlockDestroyedWithTool/>

	<@onEntityHitWith data.onEntityHitWith/>

	<#if hasProcedure(data.onRightClickedInAir)>
	@Override public ActionResult<ItemStack> onItemRightClick(World world, EntityPlayer entity, EnumHand hand) {
		super.onItemRightClick(world, entity, hand);
		ItemStack itemstack = entity.getHeldItem(hand);
		<@procedureCode data.onRightClickedInAir, {
			"x": "entity.posX",
			"y": "entity.posY",
			"z": "entity.posZ",
			"world": "world",
			"entity": "entity",
			"itemstack": "itemstack"
		}/>

		return world.isRemote ? ActionResult.newResult(EnumActionResult.SUCCESS, itemstack) : ActionResult.newResult(EnumActionResult.FAIL, itemstack);
	}
	</#if>

	<@commonMethods/>
}
</#if>
</@javacompress>
<#macro commonMethods>
	<#if data.stayInGridWhenCrafting>
		@Override public boolean hasContainerItem() {
			return true;
		}

		<#if data.damageOnCrafting && data.usageCount != 0>
			@Override public ItemStack getContainerItem(ItemStack itemstack) {
				ItemStack retval = new ItemStack(this);
				retval.setDamage(itemstack.getDamage() + 1);
				if(retval.getDamage() >= retval.getMaxDamage()) {
					return ItemStack.EMPTY;
				}
				return retval;
			}
		<#else>
			@Override public ItemStack getContainerItem(ItemStack itemstack) {
				return new ItemStack(this);
			}
		</#if>
	</#if>

	<@addSpecialInformation data.specialInformation, "item." + modid + "." + registryname/>

	<@onItemUsedOnBlock data.onRightClickedOnBlock/>

	<@onCrafted data.onCrafted/>

	<@onEntitySwing data.onEntitySwing/>

	<@onItemTick data.onItemInUseTick, data.onItemInInventoryTick/>

	<@hasGlow data.glowCondition/>
</#macro>
<#-- @formatter:on -->
<#function removeFromList list value>
    <#local filteredList = []>
    <#list list as item>
        <#if item != value>
            <#local filteredList = filteredList + [item]>
        </#if>
    </#list>
    <#return filteredList>
</#function>
<#function replaceInList list oldValue newValue>
    <#local replacedList = []>
    <#list list as item>
        <#local replacedList = replacedList + [item?replace(oldValue, newValue)]>
    </#list>
    <#return replacedList>
</#function>