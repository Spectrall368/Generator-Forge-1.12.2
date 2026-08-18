<#--
 # MCreator (https://mcreator.net/)
 # Copyright (C) 2012-2020, Pylo
 # Copyright (C) 2020-2025, Pylo, opensource contributors
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
/*
 *    MCreator note: This file will be REGENERATED on each build.
 */
package ${package}.init;

<#assign hasBlocks = false>
<#assign hasDoubleBlocks = false>
<#assign hasItemsWithProperties = w.getGElementsOfType("item")?filter(e -> e.customProperties?has_content)?size != 0
	|| w.getGElementsOfType("tool")?filter(e -> e.toolType == "Shield")?size != 0>
<#assign tabMap = w.getCreativeTabMap()>
<#assign orderedCustomItems = []>
<#assign orderedVanillaItems = []>
<#assign orderedNullItems = []>
<#assign itemList = items>

<#list itemList as item>
    <#if item.creativeTabs == "[]">
        <#assign orderedNullItems = orderedNullItems + [item]>
    </#if>
</#list>

<#assign itemList = itemList?filter(item -> !orderedNullItems?seq_contains(item))>

<#list tabMap.keySet() as tabType>
	<#assign tab = tabType>
	<#assign isCustom = tabType?starts_with('CUSTOM:')>

	<#if isCustom>
		<#assign tab = "CUSTOM:" + w.getWorkspace().getModElementByName(tabType.replace("CUSTOM:", "")).getGeneratableElement().getModElement().getName()>
	</#if>

	<#list tabMap.get(tab) as tabElement>
		<#assign tabEName = tabElement?replace("CUSTOM:", "")?keep_before(".")>

		<#if prevElement?? && prevElement == tabEName>
			<#continue>
		</#if>

		<@setItem isCustom tabType tabEName/>

		<#assign prevElement = tabEName>
	</#list>
</#list>

<#assign orderedItems = orderedCustomItems + orderedVanillaItems + orderedNullItems>
@Mod.EventBusSubscriber(modid = "${modid}"<#if hasItemsWithProperties>
, value = Side.CLIENT
</#if>) public class ${JavaModName}Items {
    private static final List<Item> REGISTRY = new ArrayList<>();

	<#list orderedItems as item>
		<#if item.getModElement().getTypeString() == "armor">
			<#if item.enableHelmet>
			public static final Item ${item.getModElement().getRegistryNameUpper()}_HELMET =
				register("${item.getModElement().getRegistryName()}_helmet", ${item.getModElement().getName()}Item.Helmet::new);
			</#if>
			<#if item.enableBody>
			public static final Item ${item.getModElement().getRegistryNameUpper()}_CHESTPLATE =
				register("${item.getModElement().getRegistryName()}_chestplate", ${item.getModElement().getName()}Item.Chestplate::new);
			</#if>
			<#if item.enableLeggings>
			public static final Item ${item.getModElement().getRegistryNameUpper()}_LEGGINGS =
				register("${item.getModElement().getRegistryName()}_leggings", ${item.getModElement().getName()}Item.Leggings::new);
			</#if>
			<#if item.enableBoots>
			public static final Item ${item.getModElement().getRegistryNameUpper()}_BOOTS =
				register("${item.getModElement().getRegistryName()}_boots", ${item.getModElement().getName()}Item.Boots::new);
			</#if>
		<#elseif item.getModElement().getTypeString() == "livingentity">

		<#elseif item.getModElement().getTypeString() == "dimension" && item.hasIgniter()>
			public static final Item ${item.getModElement().getRegistryNameUpper()} =
				register("${item.getModElement().getRegistryName()}", ${item.getModElement().getName()}Item::new);
		<#elseif item.getModElement().getTypeString() == "fluid" && item.generateBucket>
			public static final Item ${item.getModElement().getRegistryNameUpper()}_BUCKET =
				register("${item.getModElement().getRegistryName()}_bucket", ${item.getModElement().getName()}Item::new);
		<#elseif item.getModElement().getTypeString() == "block" || item.getModElement().getTypeString() == "plant">
		    <#assign customProp = item.hasCustomItemProperties()>
			<#if item.isDoubleBlock()>
				<#assign hasDoubleBlocks = true>
				public static final Item ${item.getModElement().getRegistryNameUpper()} =
					doubleBlock<#if !customProp>CMT</#if>(${JavaModName}Blocks.${item.getModElement().getRegistryNameUpper()},
					<#if customProp><@blockItemProperties item/><#else><@CreativeTabs item.creativeTabs/></#if>);
			<#else>
				<#assign hasBlocks = true>
				public static final Item ${item.getModElement().getRegistryNameUpper()} =
					block<#if !customProp>CMT</#if>(${JavaModName}Blocks.${item.getModElement().getRegistryNameUpper()},
					<#if customProp><@blockItemProperties item/><#else><@CreativeTabs item.creativeTabs/></#if>);
			</#if>
		<#else>
			public static final Item ${item.getModElement().getRegistryNameUpper()} =
				register("${item.getModElement().getRegistryName()}", ${item.getModElement().getName()}Item::new);
		</#if>
	</#list>

    private static Item register(String registryname, Supplier<Item> item) {
        Item instance = item.get().setRegistryName(new ResourceLocation(${JavaModName}.MODID, registryname));
        REGISTRY.add(instance);
    	return instance;
    }

	@SubscribeEvent public static void registerItems(RegistryEvent.Register<Item> event) {
		event.getRegistry().registerAll(REGISTRY.toArray(new Item[0]));
	}

	// Start of user code block custom items
	// End of user code block custom items

	<#if hasBlocks>
	private static Item blockCMT(RegistryObject<Block> block, ItemGroup tab) {
		return block(block, new Item.Properties().group(tab));
	}

	private static Item block(RegistryObject<Block> block, Item.Properties properties) {
		return register(block.getId().getPath(), () -> new ItemBlock(block.get(), properties));
	}
	</#if>

	<#if hasDoubleBlocks>
	private static Item doubleBlockCMT(RegistryObject<Block> block, ItemGroup tab) {
		return doubleBlock(block, new Item.Properties().group(tab));
	}

	private static Item doubleBlock(RegistryObject<Block> block, Item.Properties properties) {
		return register(block.getId().getPath(), () -> new TallBlockItem(block.get(), properties));
	}
	</#if>

	<#if hasItemsWithProperties>
	<#compress>
	@SideOnly(Side.CLIENT) public static void clientLoad() {
		<#compress>
		<#list items as item>
			<#if item.getModElement().getTypeString() == "item">
				<#list item.customProperties.entrySet() as property>
				${item.getModElement().getRegistryNameUpper()}.addPropertyOverride(
					new ResourceLocation("${modid}:${item.getModElement().getRegistryName()}_${property.getKey()}"),
					(itemStackToRender, clientWorld, entity) ->
						<#if hasProcedure(property.getValue())>
							(float) <@procedureCode property.getValue(), {
								"x": "entity != null ? entity.posX : 0",
								"y": "entity != null ? entity.posY : 0",
								"z": "entity != null ? entity.posZ : 0",
								"world": "entity != null ? entity.world : clientWorld",
								"entity": "entity",
								"itemstack": "itemStackToRender"
							}, false/>
						<#else>0</#if>
				);
				</#list>
			<#elseif item.getModElement().getTypeString() == "tool" && item.toolType == "Shield">
				${item.getModElement().getRegistryNameUpper()}.addPropertyOverride(new ResourceLocation("minecraft:blocking"),
					Items.SHIELD.getPropertyGetter(new ResourceLocation("minecraft:blocking")));
			</#if>
		</#list>
		</#compress>
	}
	</#compress>
	</#if>

	@SubscribeEvent public static void registerModels(ModelRegistryEvent event) {
	<#list orderedItems as item>
		<#if item.getModElement().getTypeString() == "armor">
			<#if item.enableHelmet>
			ModelLoader.setCustomModelResourceLocation(${item.getModElement().getRegistryNameUpper()}_HELMET, 0, new ModelResourceLocation("${modid}:${item.getModElement().getRegistryName()}_helmet", "inventory"));
			</#if>
			<#if item.enableBody>
			ModelLoader.setCustomModelResourceLocation(${item.getModElement().getRegistryNameUpper()}_CHESTPLATE, 0, new ModelResourceLocation("${modid}:${item.getModElement().getRegistryName()}_chestplate", "inventory"));
			</#if>
			<#if item.enableLeggings>
			ModelLoader.setCustomModelResourceLocation(${item.getModElement().getRegistryNameUpper()}_LEGGINGS, 0, new ModelResourceLocation("${modid}:${item.getModElement().getRegistryName()}_leggings", "inventory"));
			</#if>
			<#if item.enableBoots>
			ModelLoader.setCustomModelResourceLocation(${item.getModElement().getRegistryNameUpper()}_BOOTS, 0, new ModelResourceLocation("${modid}:${item.getModElement().getRegistryName()}_boots", "inventory"));
			</#if>
		<#elseif item.getModElement().getTypeString() == "livingentity">

		<#elseif item.getModElement().getTypeString() == "dimension" && item.hasIgniter()>
			public static final Item ${item.getModElement().getRegistryNameUpper()} =
				register("${item.getModElement().getRegistryName()}", ${item.getModElement().getName()}Item::new);
		<#elseif item.getModElement().getTypeString() == "fluid" && item.generateBucket>
			public static final Item ${item.getModElement().getRegistryNameUpper()}_BUCKET =
				register("${item.getModElement().getRegistryName()}_bucket", ${item.getModElement().getName()}Item::new);
		<#elseif item.getModElement().getTypeString() == "block" || item.getModElement().getTypeString() == "plant">
		    <#assign customProp = item.hasCustomItemProperties()>
			<#if item.isDoubleBlock()>
				<#assign hasDoubleBlocks = true>
				public static final Item ${item.getModElement().getRegistryNameUpper()} =
					doubleBlock<#if !customProp>CMT</#if>(${JavaModName}Blocks.${item.getModElement().getRegistryNameUpper()},
					<#if customProp><@blockItemProperties item/><#else><@CreativeTabs item.creativeTabs/></#if>);
			<#else>
				<#assign hasBlocks = true>
				public static final Item ${item.getModElement().getRegistryNameUpper()} =
					block<#if !customProp>CMT</#if>(${JavaModName}Blocks.${item.getModElement().getRegistryNameUpper()},
					<#if customProp><@blockItemProperties item/><#else><@CreativeTabs item.creativeTabs/></#if>);
			</#if>
		<#else>
			ModelLoader.setCustomModelResourceLocation(${item.getModElement().getRegistryNameUpper()}, 0, new ModelResourceLocation("${modid}:${item.getModElement().getRegistryName()}", "inventory"));
		</#if>
	</#list>
	}
}
<#macro blockItemProperties block>
new Item.Properties()
<#if block.maxStackSize != 64>
	.maxStackSize(${block.maxStackSize})
</#if>
<#if block.rarity != "COMMON">
	.rarity(Rarity.${block.rarity})
</#if>
.group(<@CreativeTabs block.creativeTabs/>)
</#macro>
<#-- @formatter:on -->
<#macro setItem isCustom tabType itemName>
	<#list itemList as item>
	    <#assign currentTabs><@CreativeTabs item.creativeTabs/></#assign>

	    <#if currentTabs?trim == generator.map(tabType, "tabs")?trim>
			<#if item.getModElement().getName() == itemName>
				<#if isCustom>
					<#assign orderedCustomItems = orderedCustomItems + [item]>
				<#else>
					<#assign orderedVanillaItems = orderedVanillaItems + [item]>
				</#if>
				<#assign itemList = itemList?filter(n -> n != item)>
				<#break>
			</#if>
		</#if>
	</#list>
</#macro>